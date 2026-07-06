import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const _ink = Color(0xFF111312);
const _paperRaised = Color(0xFFFFFFFF);
const _line = Color(0xFFDDE2DC);
const _muted = Color(0xFF626861);
const _green = Color(0xFF0F766E);

/// GitHub's five contribution intensity levels, remapped onto the site's
/// teal so the graph reads as part of this page rather than a screenshot.
const _levelColors = [
  Color(0xFFEBF0EA),
  Color(0xFFB3DCD5),
  Color(0xFF6CBCB1),
  Color(0xFF2D948A),
  Color(0xFF0F766E),
];

const _cellSize = 11.0;
const _cellGap = 3.0;
const _cellPitch = _cellSize + _cellGap;
const _labelTrailingPad = 30.0;

const _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
const _weekdayNames = [
  'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
];

class _DayContribution {
  const _DayContribution(this.date, this.count, this.level);

  final DateTime date;
  final int count;
  final int level;
}

/// Live GitHub contribution graph for [username], from [since] through today.
///
/// Data comes from github-contributions-api.jogruber.de, a public mirror of
/// the exact per-day counts and levels GitHub renders on the profile page,
/// served with open CORS so the static site can query it directly.
class GithubContributionsCard extends StatefulWidget {
  const GithubContributionsCard({
    super.key,
    this.username = 'aabiro',
    DateTime? since,
  }) : _since = since;

  final String username;
  final DateTime? _since;

  DateTime get since => _since ?? DateTime(2025, 4, 1);

  @override
  State<GithubContributionsCard> createState() =>
      _GithubContributionsCardState();
}

class _GithubContributionsCardState extends State<GithubContributionsCard> {
  List<_DayContribution>? _days;
  bool _loading = true;
  bool _failed = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetch();
    // Keep the graph live while the tab stays open. Web-only so widget
    // tests do not end with a pending timer.
    if (kIsWeb) {
      _refreshTimer = Timer.periodic(
        const Duration(minutes: 5),
        (_) => _fetch(silent: true),
      );
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetch({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _failed = false;
      });
    }
    try {
      final now = DateTime.now();
      final years = [
        for (var y = widget.since.year; y <= now.year; y++) 'y=$y'
      ].join('&');
      final response = await http
          .get(Uri.parse(
              'https://github-contributions-api.jogruber.de/v4/${widget.username}?$years'))
          .timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) {
        throw http.ClientException('HTTP ${response.statusCode}');
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final today = DateTime(now.year, now.month, now.day);
      final days = <_DayContribution>[];
      for (final entry in decoded['contributions'] as List<dynamic>) {
        final map = entry as Map<String, dynamic>;
        final date = DateTime.parse(map['date'] as String);
        if (date.isBefore(widget.since) || date.isAfter(today)) continue;
        days.add(_DayContribution(
            date, map['count'] as int, (map['level'] as int).clamp(0, 4)));
      }
      days.sort((a, b) => a.date.compareTo(b.date));
      if (!mounted) return;
      setState(() {
        _days = days;
        _loading = false;
        _failed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = _days == null;
      });
    }
  }

  Future<void> _openProfile() async {
    final uri = Uri.parse('https://github.com/${widget.username}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _paperRaised,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const SizedBox(height: 18),
          if (_loading)
            const _GraphSkeleton()
          else if (_failed)
            _errorState(context)
          else
            _ContributionGraph(days: _days!),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final total =
        _days?.fold<int>(0, (sum, day) => sum + day.count);
    final sinceLabel =
        '${_monthNames[widget.since.month - 1]} ${widget.since.year}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LIVE FROM GITHUB',
                style: TextStyle(
                  color: _green,
                  fontFamily: 'monospace',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                total == null
                    ? 'Contributions since $sinceLabel'
                    : '$total contributions since $sinceLabel',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _ink, fontWeight: FontWeight.w900, height: 1.2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        TextButton.icon(
          onPressed: _openProfile,
          icon: const Icon(Icons.north_east_rounded, size: 16),
          label: Text('@${widget.username}'),
          style: TextButton.styleFrom(foregroundColor: _ink),
        ),
      ],
    );
  }

  Widget _errorState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The live contribution feed is unavailable right now.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: _muted, height: 1.5),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: _fetch,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
            TextButton.icon(
              onPressed: _openProfile,
              icon: const Icon(Icons.north_east_rounded, size: 16),
              label: const Text('View on GitHub'),
              style: TextButton.styleFrom(foregroundColor: _ink),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContributionGraph extends StatefulWidget {
  const _ContributionGraph({required this.days});

  final List<_DayContribution> days;

  @override
  State<_ContributionGraph> createState() => _ContributionGraphState();
}

class _ContributionGraphState extends State<_ContributionGraph> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Land on the most recent weeks, like the GitHub profile does.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Columns are calendar weeks starting on Sunday, GitHub-style.
    final first = widget.days.first.date;
    final leading = first.weekday % 7;
    final weeks = <List<_DayContribution?>>[];
    var week = List<_DayContribution?>.filled(7, null, growable: false);
    var slot = leading;
    for (final day in widget.days) {
      week[slot] = day;
      slot++;
      if (slot == 7) {
        weeks.add(week);
        week = List<_DayContribution?>.filled(7, null, growable: false);
        slot = 0;
      }
    }
    if (slot > 0) weeks.add(week);

    final monthLabels = _monthLabels(weeks);
    final gridWidth = weeks.length * _cellPitch - _cellGap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _weekdayGutter(),
                const SizedBox(width: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, progress, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          // Trailing room so the final month label (e.g. the
                          // current partial month) is not clipped by the Stack.
                          width: gridWidth + _labelTrailingPad,
                          height: 16,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              for (final label in monthLabels)
                                Positioned(
                                  left: label.$1 * _cellPitch,
                                  top: 0,
                                  child: Text(
                                    label.$2,
                                    style: const TextStyle(
                                        color: _muted,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var w = 0; w < weeks.length; w++)
                              Padding(
                                padding: EdgeInsets.only(
                                    right:
                                        w == weeks.length - 1 ? 0 : _cellGap),
                                child: Opacity(
                                  opacity: _columnReveal(
                                      progress, w, weeks.length),
                                  child: Column(
                                    children: [
                                      for (var d = 0; d < 7; d++)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  d == 6 ? 0 : _cellGap),
                                          child:
                                              _DayCell(day: weeks[w][d]),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _legend(context),
      ],
    );
  }

  /// Sweeps the reveal left to right across the columns.
  double _columnReveal(double progress, int column, int columns) {
    final start = column / columns * 0.6;
    return ((progress - start) / 0.4).clamp(0.0, 1.0);
  }

  /// (weekIndex, label) pairs; a month is labelled at the first column
  /// containing one of its days, matching GitHub's placement.
  List<(int, String)> _monthLabels(List<List<_DayContribution?>> weeks) {
    final labels = <(int, String)>[];
    int? lastMonth;
    var lastLabelWeek = -10;
    for (var w = 0; w < weeks.length; w++) {
      final firstDay = weeks[w].firstWhere((d) => d != null)!;
      final month = firstDay.date.month;
      if (month != lastMonth) {
        // Skip a label that would collide with the previous one.
        if (w - lastLabelWeek >= 3) {
          labels.add((w, _monthNames[month - 1]));
          lastLabelWeek = w;
        }
        lastMonth = month;
      }
    }
    return labels;
  }

  Widget _weekdayGutter() {
    const rowLabels = {1: 'Mon', 3: 'Wed', 5: 'Fri'};
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var d = 0; d < 7; d++)
            Container(
              height: _cellSize + (d == 6 ? 0 : _cellGap),
              alignment: Alignment.topRight,
              child: Text(
                rowLabels[d] ?? '',
                style: const TextStyle(
                    color: _muted,
                    fontSize: 9.5,
                    height: 1.15,
                    fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _legend(BuildContext context) {
    final labelStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: _muted, fontWeight: FontWeight.w600);
    return Row(
      children: [
        Text('Updated live from public GitHub activity', style: labelStyle),
        const Spacer(),
        Text('Less', style: labelStyle),
        const SizedBox(width: 6),
        for (final color in _levelColors)
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: _square(color),
          ),
        const SizedBox(width: 3),
        Text('More', style: labelStyle),
      ],
    );
  }

  Widget _square(Color color) {
    return Container(
      width: _cellSize,
      height: _cellSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.5),
        border: Border.all(color: _ink.withValues(alpha: 0.06)),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day});

  final _DayContribution? day;

  @override
  Widget build(BuildContext context) {
    final day = this.day;
    if (day == null) {
      return const SizedBox(width: _cellSize, height: _cellSize);
    }
    final date = day.date;
    final label = day.count == 1
        ? '1 contribution'
        : '${day.count == 0 ? 'No' : day.count} contributions';
    return Tooltip(
      message: '$label on ${_weekdayNames[date.weekday % 7]}, '
          '${_monthNames[date.month - 1]} ${date.day}, ${date.year}',
      waitDuration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        color: _ink,
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      child: Container(
        width: _cellSize,
        height: _cellSize,
        decoration: BoxDecoration(
          color: _levelColors[day.level],
          borderRadius: BorderRadius.circular(2.5),
          border: Border.all(color: _ink.withValues(alpha: 0.06)),
        ),
      ),
    );
  }
}

class _GraphSkeleton extends StatelessWidget {
  const _GraphSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            ((constraints.maxWidth + _cellGap) / _cellPitch).floor();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var d = 0; d < 7; d++)
              Padding(
                padding: EdgeInsets.only(bottom: d == 6 ? 0 : _cellGap),
                child: Row(
                  children: [
                    for (var w = 0; w < columns; w++)
                      Padding(
                        padding: EdgeInsets.only(
                            right: w == columns - 1 ? 0 : _cellGap),
                        child: Container(
                          width: _cellSize,
                          height: _cellSize,
                          decoration: BoxDecoration(
                            color: _levelColors[0],
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
