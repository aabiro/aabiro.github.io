#!/usr/bin/env python3
"""Shrink the Claude Design export in page/page.html.

The export inlines every asset as base64 inside the page, which made
index.html 983 KB - and 80% of that was fonts nobody on this site can read.
Three things come out:

  * assets no longer referenced by the page (the export carried a second,
    stale copy of the resume PDF that nothing links to - the page serves
    assets/Aaryn_Biro_Resume.pdf instead)
  * Inter subsets for scripts the page never uses. Which ones those are is
    measured, not assumed: every code point in the page's own text and data is
    checked against each subset's unicode-range, and a subset is dropped only
    when nothing needs it
  * the Material Symbols icon font, subset from the full ~3400-glyph set to the
    icons this page actually names

Run it after re-exporting page/page.html from Claude Design; it is idempotent,
so running it twice is harmless.

    python3 scripts/optimize_bundle.py [--dry-run]

Needs fonttools and brotli locally. Deliberately NOT part of build_site.sh:
the build has to be reproducible from committed files alone so CI can verify
docs/ by rebuilding it, and that rules out a step whose output depends on which
fonttools version happens to be installed.
"""
from __future__ import annotations

import base64
import io
import json
import os
import re
import sys
import zlib

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PAGE = os.path.join(ROOT, "page", "page.html")

MANIFEST_RE = r'(<script type="__bundler/manifest">)(.*?)(</script>)'
TEMPLATE_RE = r'(<script type="__bundler/template">)(.*?)(</script>)'


def load(path):
    text = open(path, encoding="utf-8").read()
    man = json.loads(re.search(MANIFEST_RE, text, re.S).group(2))
    tpl = json.loads(re.search(TEMPLATE_RE, text, re.S).group(2))
    return text, man, tpl


def asset_bytes(entry):
    """Decode one manifest entry. The loader inflates these with
    DecompressionStream('gzip'), so compressed entries are gzip, not zlib."""
    raw = base64.b64decode(entry["data"])
    if entry.get("compressed"):
        for wbits in (31, 15, -15):
            try:
                return zlib.decompress(raw, wbits)
            except zlib.error:
                continue
        raise ValueError("compressed entry is not gzip, zlib or raw deflate")
    return raw


def store(entry, raw):
    """Put bytes back in the same encoding the entry already used."""
    if entry.get("compressed"):
        co = zlib.compressobj(9, zlib.DEFLATED, 31)
        raw = co.compress(raw) + co.flush()
    entry["data"] = base64.b64encode(raw).decode("ascii")


def page_text(tpl, man):
    """Everything the page can render: its own markup plus its JS data."""
    chunks = [tpl]
    for entry in man.values():
        if entry["mime"] == "text/javascript":
            chunks.append(asset_bytes(entry).decode("utf-8", "replace"))
    return "".join(chunks)


def parse_ranges(spec):
    out = []
    for part in spec.split(","):
        part = part.strip().replace("U+", "").replace("u+", "")
        if not part:
            continue
        if "-" in part:
            a, b = part.split("-", 1)
            out.append((int(a, 16), int(b, 16)))
        else:
            if "?" in part:
                a = int(part.replace("?", "0"), 16)
                b = int(part.replace("?", "F"), 16)
                out.append((a, b))
            else:
                v = int(part, 16)
                out.append((v, v))
    return out


def main() -> int:
    dry = "--dry-run" in sys.argv
    text, man, tpl = load(PAGE)
    before = len(text)
    used_chars = {ord(c) for c in page_text(tpl, man)}
    removed, resized = [], []

    # 1. assets the page no longer references
    for uid in list(man):
        if uid not in tpl and not any(
            uid in asset_bytes(e).decode("utf-8", "replace")
            for e in man.values() if e["mime"] == "text/javascript"
        ):
            removed.append((uid, man[uid]["mime"], len(man[uid]["data"])))
            del man[uid]

    # 2. font subsets no code point on the page needs
    blocks = re.findall(r"@font-face\s*\{[^}]*\}", tpl)
    for block in blocks:
        uid_m = re.search(r'url\("([0-9a-f-]{36})"\)', block)
        rng_m = re.search(r"unicode-range:\s*([^;]+);", block)
        if not uid_m or not rng_m or uid_m.group(1) not in man:
            continue
        if any(a <= cp <= b for a, b in parse_ranges(rng_m.group(1)) for cp in used_chars):
            continue
        uid = uid_m.group(1)
        # every block pointing at this asset must be unneeded before it goes
        siblings = [b for b in blocks if uid in b]
        if all(
            not any(a <= cp <= b2 for a, b2 in parse_ranges(re.search(r"unicode-range:\s*([^;]+);", s).group(1))
                    for cp in used_chars)
            for s in siblings if re.search(r"unicode-range:\s*([^;]+);", s)
        ):
            for s in siblings:
                tpl = tpl.replace(s, "")
            if uid in man:
                removed.append((uid, man[uid]["mime"] + " (unused subset)", len(man[uid]["data"])))
                del man[uid]

    # 3. the icon font, down to the icons the page actually draws.
    #
    # Two things make this harder than it looks, and both broke a first attempt.
    #
    # Scanning the markup for <span class="msi">name</span> finds 13 of the 33
    # icons on the page; the rest are built from JS data. So candidates are
    # every quoted lowercase word in the page and its JS.
    #
    # And an icon name is not a glyph name. Material Symbols renders an icon
    # from its name through an rlig ligature, and the glyph it lands on can be
    # called something else: "smartphone" resolves to a glyph named "mobile".
    # Matching candidates against glyph names therefore silently drops icons -
    # smartphone rendered as the literal word. So the ligature table is read
    # (through its extension lookups) and a candidate is an icon only if its
    # characters actually form one. That also throws out words like "react"
    # that merely look like icon names.
    quoted = set(re.findall(r"['\"]([a-z][a-z0-9_]{1,40})['\"]", page_text(tpl, man)))
    quoted |= set(re.findall(r'class="msi"[^>]*>([a-z_0-9]+)<', tpl))
    for uid, entry in man.items():
        if entry["mime"] != "font/woff2":
            continue
        face = next((b for b in re.findall(r"@font-face\s*\{[^}]*\}", tpl) if uid in b), "")
        if "Material Symbols" not in face:
            continue
        from fontTools import subset
        from fontTools.ttLib import TTFont
        raw = asset_bytes(entry)
        font = TTFont(io.BytesIO(raw))

        cmap = font.getBestCmap()
        ligatures = {}
        for lookup in font["GSUB"].table.LookupList.Lookup:
            for sub_table in lookup.SubTable:
                inner = getattr(sub_table, "ExtSubTable", sub_table)
                for first, ligset in getattr(inner, "ligatures", {}).items():
                    for lig in ligset:
                        ligatures[(first, *lig.Component)] = lig.LigGlyph

        def glyph_for(name):
            try:
                seq = tuple(cmap[ord(ch)] for ch in name)
            except KeyError:
                return None
            return ligatures.get(seq)

        icons = sorted(n for n in quoted if glyph_for(n))
        if not icons:
            continue
        keep = sorted({glyph_for(n) for n in icons})

        opts = subset.Options()
        opts.layout_features = ["liga", "dlig", "rlig", "calt", "ccmp"]
        opts.recalc_timestamp = False        # keeps the output byte-stable
        opts.drop_tables += ["DSIG"]
        # layout_closure off is the other half of the trick. The letters a-z are
        # inputs to 4264 ligature rules, so with the closure on, asking for a
        # dozen icons by their letters drags in 1537 glyphs and 112 KB. Off,
        # naming the output glyphs explicitly, it is a few KB - and the rules
        # that survive are the ones whose inputs and outputs are both still
        # present, so the ligatures still fire.
        opts.layout_closure = False
        sub = subset.Subsetter(options=opts)
        sub.populate(text="".join(sorted(set("".join(icons)))) + " ", glyphs=keep)
        sub.subset(font)
        buf = io.BytesIO()
        font.flavor = "woff2"
        font.save(buf)
        new = buf.getvalue()
        if len(new) < len(raw):
            resized.append((uid, len(raw), len(new), icons))
            store(entry, new)

    def dump(obj, **kw):
        # The export escapes every "</" as "<\\u002F" so that no literal
        # </script> can appear inside these JSON strings and close the tag
        # early. json.dumps does not, and the first rewrite that forgot this
        # truncated the template at the first inner </div>.
        return json.dumps(obj, **kw).replace("</", "<\\u002F")

    out = re.sub(MANIFEST_RE, lambda m: m.group(1) + dump(man, separators=(",", ":")) + m.group(3), text, flags=re.S)
    out = re.sub(TEMPLATE_RE, lambda m: m.group(1) + dump(tpl) + m.group(3), out, flags=re.S)

    for uid, mime, n in removed:
        print(f"  removed  {uid[:8]}  {mime:34} -{n/1024:7.1f} KB")
    for uid, a, b, ic in resized:
        print(f"  subset   {uid[:8]}  Material Symbols -> {len(ic)} icons  {a/1024:.1f} KB -> {b/1024:.1f} KB")
        print(f"           icons kept: {', '.join(ic)}")
    print(f"\npage/page.html: {before/1024:.1f} KB -> {len(out)/1024:.1f} KB "
          f"({100*(before-len(out))/before:.1f}% smaller)")

    if dry:
        print("(dry run, nothing written)")
        return 0
    open(PAGE, "w", encoding="utf-8").write(out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
