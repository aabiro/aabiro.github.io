#!/usr/bin/env python3
"""Give the built page a static, readable copy of the portfolio.

The Claude Design export keeps all of its content inside a bundled template and
a component script, so the HTML that crawlers, link previewers, recruiter tools
and LLM agents fetch holds nothing but an "Unpacking..." loader. This reads the
copy and the component data out of that template and writes them into the page
as plain, semantic HTML.

Browsers with JavaScript still get the designed page exactly as before: the
loader keeps its thumbnail over the static copy while it unpacks, then replaces
the whole document. Everything that does not run JavaScript reads the static
copy instead. Runs after inject_seo.py in scripts/build_site.sh; safe to re-run.
"""
import html
import json
import re
import sys

MARKER = 'id="static-profile"'
RESUME_HREF = "assets/Aaryn_Biro_Resume.pdf"


# --- JS literal parsing ------------------------------------------------------
# The component declares its content as class fields holding plain JS literals
# (single-quoted strings, bare keys, trailing commas). This reads that subset.

class _JSLiteral:
    def __init__(self, src: str, pos: int):
        self.src = src
        self.pos = pos

    def _ws(self) -> None:
        while self.pos < len(self.src):
            if self.src[self.pos].isspace():
                self.pos += 1
            elif self.src.startswith("//", self.pos):
                end = self.src.find("\n", self.pos)
                self.pos = len(self.src) if end == -1 else end
            elif self.src.startswith("/*", self.pos):
                self.pos = self.src.index("*/", self.pos) + 2
            else:
                return

    def value(self):
        self._ws()
        ch = self.src[self.pos]
        if ch == "[":
            return self._array()
        if ch == "{":
            return self._object()
        if ch in "'\"`":
            return self._string()
        m = re.compile(r"-?\d+(\.\d+)?|true|false|null").match(self.src, self.pos)
        if not m:
            raise ValueError(f"unsupported JS literal at {self.src[self.pos:self.pos + 40]!r}")
        self.pos = m.end()
        return json.loads(m.group(0))

    def _string(self) -> str:
        quote = self.src[self.pos]
        self.pos += 1
        out = []
        while self.src[self.pos] != quote:
            ch = self.src[self.pos]
            if ch == "\\":
                self.pos += 1
                ch = {"n": "\n", "t": "\t"}.get(self.src[self.pos], self.src[self.pos])
            out.append(ch)
            self.pos += 1
        self.pos += 1
        return "".join(out)

    def _array(self) -> list:
        self.pos += 1
        items = []
        while True:
            self._ws()
            if self.src[self.pos] == "]":
                self.pos += 1
                return items
            items.append(self.value())
            self._ws()
            if self.src[self.pos] == ",":
                self.pos += 1

    def _object(self) -> dict:
        self.pos += 1
        obj = {}
        while True:
            self._ws()
            if self.src[self.pos] == "}":
                self.pos += 1
                return obj
            if self.src[self.pos] in "'\"":
                key = self._string()
            else:
                m = re.compile(r"[A-Za-z_$][\w$]*").match(self.src, self.pos)
                if not m:
                    raise ValueError(f"unsupported object key at {self.src[self.pos:self.pos + 40]!r}")
                key = m.group(0)
                self.pos = m.end()
            self._ws()
            if self.src[self.pos] != ":":
                raise ValueError(f"expected ':' after key {key!r}")
            self.pos += 1
            obj[key] = self.value()
            self._ws()
            if self.src[self.pos] == ",":
                self.pos += 1


def _field(script: str, name: str):
    """Value of a `name = <literal>;` class field, or None if it is absent."""
    m = re.search(r"^\s*" + re.escape(name) + r"\s*=\s*(?=[\[{'\"])", script, re.M)
    if not m:
        return None
    try:
        return _JSLiteral(script, m.end()).value()
    except (ValueError, IndexError) as err:
        sys.exit(f"inject_static_profile: could not read {name!r}: {err}")


# --- Template copy -----------------------------------------------------------

def _text(fragment: str) -> str:
    """Visible text of an HTML fragment, whitespace-collapsed."""
    fragment = re.sub(r"<[^>]+>", " ", fragment)
    return re.sub(r"\s+", " ", html.unescape(fragment)).strip()


def _without_bindings(fragment: str) -> str:
    """Drop <sc-for>/<sc-if> blocks, innermost first: their copy is data-driven or conditional."""
    block = re.compile(r"<sc-(for|if)\b[^>]*>(?:(?!<sc-(?:for|if)\b).)*?</sc-\1>", re.S)
    while True:
        fragment, n = block.subn("", fragment)
        if not n:
            return fragment


def _static_texts(fragment: str, tag: str) -> list:
    """Text of every <tag> in the fragment that is not a template binding."""
    fragment = _without_bindings(fragment)
    out = []
    for m in re.finditer(rf"<{tag}\b[^>]*>(.*?)</{tag}>", fragment, re.S):
        if "{{" not in m.group(1):
            text = _text(m.group(1))
            if text:
                out.append(text)
    return out


def _sections(markup: str) -> list:
    """(id, heading, lead texts) for each <section id="sec-..."> in page order."""
    out = []
    for m in re.finditer(r'<section id="sec-([\w-]+)"[^>]*>(.*?)</section>', markup, re.S):
        body = m.group(2)
        h2 = _static_texts(body, "h2")
        out.append((m.group(1), h2[0] if h2 else "", _static_texts(body, "p")))
    return out


# --- Rendering ---------------------------------------------------------------

def _e(value) -> str:
    return html.escape(str(value), quote=True)


def _tags(tags) -> str:
    if not tags:
        return ""
    return f'<p class="sp-tags">{_e(", ".join(tags))}</p>'


def _render_work(data: dict) -> str:
    parts = []
    for s in data.get("caseStudies") or []:
        outcomes = "".join(f"<li>{_e(o)}</li>" for o in s.get("outcomes", []))
        parts.append(
            "<article>"
            f'<h3>{_e(s.get("title", ""))}</h3>'
            f'<p class="sp-meta">{_e(s.get("kicker", ""))}</p>'
            f'<p>{_e(s.get("summary", ""))}</p>'
            + (f"<ul>{outcomes}</ul>" if outcomes else "")
            + _tags(s.get("tags"))
            + "</article>"
        )
    return "".join(parts)


def _render_github(links: dict) -> str:
    return f'<p><a href="{_e(links["github"])}">View contribution history on GitHub (@aabiro)</a></p>'


def _render_systems(data: dict) -> str:
    parts = []
    for cap in data.get("capabilities") or []:
        items = "".join(
            f'<li><strong>{_e(i.get("title", ""))}.</strong> {_e(i.get("body", ""))}</li>'
            for i in cap.get("items", [])
        )
        parts.append(
            "<article>"
            f'<h3>{_e(cap.get("name", ""))}</h3>'
            f'<p>{_e(cap.get("summary", ""))}</p>'
            + (f"<ul>{items}</ul>" if items else "")
            + "</article>"
        )
    return "".join(parts)


def _render_experience(data: dict) -> str:
    parts = []
    for job in data.get("experience") or []:
        role, company = job.get("role", ""), job.get("company", "")
        meta = " | ".join(v for v in (job.get("period"), job.get("place")) if v)
        parts.append(
            "<article>"
            f"<h3>{_e(role)}, {_e(company)}</h3>"
            f'<p class="sp-meta">{_e(meta)}</p>'
            f'<p>{_e(job.get("summary", ""))}</p>'
            + _tags(job.get("tags"))
            + "</article>"
        )
    parts.append(f'<p><a href="{RESUME_HREF}">Download the full resume (PDF)</a></p>')
    return "".join(parts)


def _render_stack(data: dict) -> str:
    rows = "".join(
        f'<li><strong>{_e(col.get("title", ""))}:</strong> {_e(", ".join(col.get("skills", [])))}</li>'
        for col in data.get("skillColumns") or []
    )
    return f"<ul>{rows}</ul>" if rows else ""


def _render_contact(links: dict) -> str:
    return (
        "<ul>"
        f'<li>Email: <a href="mailto:{_e(links["email"])}">{_e(links["email"])}</a></li>'
        f'<li>LinkedIn: <a href="{_e(links["linkedin"])}">{_e(links["linkedin"])}</a></li>'
        f'<li>GitHub: <a href="{_e(links["github"])}">{_e(links["github"])}</a></li>'
        f'<li>Resume: <a href="{RESUME_HREF}">Aaryn_Biro_Resume.pdf</a></li>'
        "</ul>"
    )


def _links(template: str) -> dict:
    def first(pattern: str, default: str) -> str:
        m = re.search(pattern, template)
        return m.group(0) if m else default

    email = first(r"[\w.+-]+@[\w-]+\.[\w.]+", "aaryn.alexander@gmail.com")
    return {
        "email": email,
        "linkedin": first(r"https://www\.linkedin\.com/in/[\w-]+/?", "https://www.linkedin.com/in/aabiro/"),
        "github": first(r"https://github\.com/[\w-]+(?=['\"])", "https://github.com/aabiro"),
    }


def render(template: str) -> str:
    m = re.search(r'<script type="text/x-dc"[^>]*>(.*?)</script>', template, re.S)
    script = m.group(1) if m else ""
    data = {
        name: _field(script, name)
        for name in ("metrics", "caseStudies", "capabilities", "experience", "skillColumns", "heroTags")
    }
    links = _links(template)

    hero = re.search(r'data-screen-label="Hero".*?</section>', template, re.S)
    hero_markup = hero.group(0) if hero else ""
    name = (_static_texts(hero_markup, "h1") or ["Aaryn Biro"])[0]
    hero_paras = _static_texts(hero_markup, "p")

    out = ['<main id="static-profile">', "<header>", f"<h1>{_e(name)}</h1>"]
    out += [f"<p>{_e(p)}</p>" for p in hero_paras[:2]]
    out.append(
        '<p class="sp-links">'
        f'<a href="{RESUME_HREF}">Download resume (PDF)</a> | '
        f'<a href="mailto:{_e(links["email"])}">Email</a> | '
        f'<a href="{_e(links["linkedin"])}">LinkedIn</a> | '
        f'<a href="{_e(links["github"])}">GitHub</a>'
        "</p>"
    )
    out.append(_tags(data["heroTags"]))
    out.append("</header>")

    if data["metrics"]:
        items = "".join(
            f'<li><strong>{_e(m.get("value", ""))} {_e(m.get("label", ""))}:</strong> {_e(m.get("detail", ""))}</li>'
            for m in data["metrics"]
        )
        out.append(f'<section><h2>Highlights</h2><ul>{items}</ul></section>')

    renderers = {
        "Work": lambda: _render_work(data),
        "GitHub": lambda: _render_github(links),
        "Systems": lambda: _render_systems(data),
        "Experience": lambda: _render_experience(data),
        "Stack": lambda: _render_stack(data),
        "Contact": lambda: _render_contact(links),
    }
    for sec_id, heading, paras in _sections(template):
        out.append(f'<section id="static-{_e(sec_id)}"><h2>{_e(sec_id)}</h2>')
        if heading:
            out.append(f'<p class="sp-lead">{_e(heading)}</p>')
        out += [f"<p>{_e(p)}</p>" for p in paras]
        out.append(renderers.get(sec_id, lambda: "")())
        out.append("</section>")

    out.append("</main>")
    fallback = "\n".join(part for part in out if part)

    if not (data["experience"] or data["caseStudies"]):
        sys.exit("inject_static_profile: found no experience or work entries in the template")
    return fallback


STYLE = """<style>
    #__bundler_loading:empty { display: none; }
    #static-profile { width: 100%; max-width: 760px; margin: 0 auto; padding: 48px 20px 64px; color: #111312; font: 16px/1.6 -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
    #static-profile h1 { font-size: 40px; line-height: 1.1; }
    #static-profile h2 { margin-top: 40px; font-size: 24px; }
    #static-profile h3 { margin-top: 20px; font-size: 18px; }
    #static-profile p, #static-profile ul { margin-top: 10px; }
    #static-profile ul { padding-left: 20px; }
    #static-profile a { color: #0F766E; }
    #static-profile .sp-meta, #static-profile .sp-tags { color: #626861; font-size: 14px; }
    #static-profile .sp-lead { font-weight: 700; }
  </style>"""

NOSCRIPT = """<noscript>
    <style>#__bundler_thumbnail, #__bundler_loading { display: none; } body { display: block; }</style>
  </noscript>"""


def main(path: str) -> None:
    with open(path, "r", encoding="utf-8") as fh:
        page = fh.read()

    if MARKER in page:
        print("inject_static_profile: static profile already present, leaving as is")
        return

    m = re.search(r'<script type="__bundler/template">(.*?)</script>', page, re.S)
    if not m:
        sys.exit("inject_static_profile: bundled template not found")
    fallback = render(json.loads(m.group(1)))

    page, n = re.subn(r"<noscript>.*?</noscript>", NOSCRIPT, page, count=1, flags=re.S)
    if n != 1:
        sys.exit("inject_static_profile: expected loader <noscript> block not found")
    page = page.replace("</head>", f"  {STYLE}\n</head>", 1)

    loading = '<div id="__bundler_loading">Unpacking...</div>'
    if loading not in page:
        sys.exit("inject_static_profile: expected loader status element not found")
    page = page.replace(loading, '<div id="__bundler_loading"></div>', 1)

    body = re.search(r"<body[^>]*>", page)
    if not body:
        sys.exit("inject_static_profile: <body> not found")
    page = page[: body.end()] + "\n" + fallback + "\n" + page[body.end():]

    with open(path, "w", encoding="utf-8") as fh:
        fh.write(page)
    print(f"inject_static_profile: wrote static profile into {path}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("usage: inject_static_profile.py <site/index.html>")
    main(sys.argv[1])
