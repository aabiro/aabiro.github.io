import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'resume_download.dart';

const _ink = Color(0xFF111312);
const _paper = Color(0xFFFAFAF8);
const _paperRaised = Color(0xFFFFFFFF);
const _line = Color(0xFFDDE2DC);
const _muted = Color(0xFF626861);
const _soft = Color(0xFFF1F4EF);
const _green = Color(0xFF0F766E);
const _coral = Color(0xFFD85C46);
const _blue = Color(0xFF2F6F9F);
const _resumeAssetPath = 'assets/assets/Aaryn_Biro_Resume.pdf';
const _resumeFileName = 'Aaryn_Biro_Resume.pdf';

Color _alpha(Color color, double opacity) => color.withValues(alpha: opacity);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _sectionKeys = <String, GlobalKey>{
    'Work': GlobalKey(),
    'Systems': GlobalKey(),
    'Experience': GlobalKey(),
    'Stack': GlobalKey(),
    'Contact': GlobalKey(),
  };

  String _selectedCapability = 'Platform';
  Offset? _cursor;
  double _scrollProgress = 0;

  static const _metrics = [
    _Metric('8+', 'years',
        'Production backend, mobile, and cloud platform delivery.'),
    _Metric('2', 'founder-led platforms',
        'Xcelsior compute orchestration and PixelEnhance AI media.'),
    _Metric('Sub-25ms', 'inference target',
        'GPU pipelines tuned for low-latency media workflows.'),
    _Metric('End-to-end', 'ownership',
        'APIs, scheduling, billing, deployment, observability, and UX.'),
  ];

  static const _caseStudies = [
    _CaseStudy(
      title: 'Xcelsior distributed compute platform',
      kicker: '2025 - Present',
      summary:
          'A secure GPU workload orchestration platform spanning public APIs, scheduler logic, worker coordination, billing workflows, and developer tooling.',
      outcomes: [
        'Designed admission-gated workers, private mesh networking, container isolation, and audit-oriented event handling.',
        'Built modular backend and Next.js interfaces across routing, scheduling, billing, privacy, persistence, CI, and deployment paths.',
        'Created production-minded tooling for multi-node operations instead of one-off scripts.',
      ],
      tags: [
        'GPU orchestration',
        'Secure APIs',
        'Schedulers',
        'Billing',
        'Next.js',
        'Developer tools'
      ],
      accent: _green,
      icon: Icons.hub_outlined,
    ),
    _CaseStudy(
      title: 'PixelEnhance AI media platform',
      kicker: 'Jan 2024 - Present',
      summary:
          'An AI media platform for enhancement workflows, async processing, cloud routing, and provider-aware GPU scheduling across hybrid infrastructure.',
      outcomes: [
        'Owned FastAPI, PostgreSQL, Redis, Celery, React, Docker, Nginx, and Linux deployment infrastructure end to end.',
        'Built queue-based execution, autoscaling, cloud routing, and orchestration layers for GPU-intensive jobs.',
        'Improved reliability with deployment automation, environment management, and observability practices.',
      ],
      tags: ['FastAPI', 'React', 'PostgreSQL', 'Redis', 'Celery', 'Nginx'],
      accent: _coral,
      icon: Icons.auto_awesome_motion_outlined,
    ),
    _CaseStudy(
      title: 'Consumer product engineering',
      kicker: '2021 - 2023',
      summary:
          'Mobile and full-stack product work across rewards, sign-in, verification, monitoring, analytics, API integration, and release workflows.',
      outcomes: [
        'Delivered iOS and Android product surfaces at Snappy with reliable iteration inside a distributed team.',
        'Built Flutter and Dart features at Neurolign with modern state management and robust API integration.',
        'Contributed across CI/CD, monitoring, analytics, Node.js, MongoDB, Express, and React functionality.',
      ],
      tags: ['Flutter', 'Dart', 'iOS', 'Android', 'Node.js', 'React'],
      accent: _blue,
      icon: Icons.phone_iphone_outlined,
    ),
  ];

  static const _capabilities = [
    _CapabilityGroup(
      name: 'Platform',
      summary:
          'Architecture for systems that need to coordinate work, money, trust, and operators.',
      items: [
        _Capability('Admission and trust boundaries',
            'Worker registration, secure control planes, private network design, and audit-friendly event models.'),
        _Capability('Schedulers and queues',
            'Queue-based execution, provider-aware routing, background jobs, autoscaling, and fault-aware retry paths.'),
        _Capability('Commercial plumbing',
            'Billing workflows, developer-facing tooling, persistence, and product surfaces that make infrastructure usable.'),
      ],
    ),
    _CapabilityGroup(
      name: 'AI Media',
      summary:
          'GPU-heavy media systems built around repeatable pipelines instead of fragile demos.',
      items: [
        _Capability('Inference pipelines',
            'PyTorch, TensorRT, FFmpeg, model benchmarking, video upscaling, denoise, and enhancement workloads.'),
        _Capability('Hybrid infrastructure',
            'Cloud GPU routing, autoscaling, Linux deployment, Docker environments, and edge-aware media delivery.'),
        _Capability('Operational visibility',
            'Job telemetry, release checks, environment hygiene, and observability loops for long-running media workloads.'),
      ],
    ),
    _CapabilityGroup(
      name: 'Product Apps',
      summary:
          'Consumer and business-facing surfaces that hold up under iteration and release pressure.',
      items: [
        _Capability('Mobile execution',
            'Flutter, Dart, SwiftUI, Android workflows, state management, async APIs, and release readiness.'),
        _Capability('Frontend systems',
            'React, TypeScript, responsive UX, customer workflows, admin surfaces, and data-heavy product screens.'),
        _Capability('User-critical flows',
            'Membership, rewards, sign-in, verification, onboarding, and verification-heavy product paths.'),
      ],
    ),
    _CapabilityGroup(
      name: 'Delivery',
      summary:
          'The engineering habits that keep ambitious builds from collapsing under their own complexity.',
      items: [
        _Capability('Testing and CI',
            'Automated checks, CI/CD, release discipline, and code paths designed for fast feedback.'),
        _Capability('Deployment systems',
            'Docker, Linux, Nginx, cloud deployment, environment management, and production rollout practices.'),
        _Capability('Technical leadership',
            'Roadmapping, product judgment, customer discovery, mentoring, and converting ambiguity into shipped systems.'),
      ],
    ),
  ];

  static const _experience = [
    _ExperienceItem(
      role: 'Founder and Principal Engineer',
      company: 'Xcelsior',
      period: '2025 - Present',
      place: 'London, ON / Remote',
      summary:
          'Building a distributed compute platform for GPU workload orchestration, secure worker admission, scheduling, billing, and developer tooling.',
      tags: ['Distributed systems', 'GPU compute', 'Secure workers', 'Billing'],
    ),
    _ExperienceItem(
      role: 'Founder and Principal Engineer',
      company: 'PixelEnhance Labs',
      period: 'Jan 2024 - Present',
      place: 'London, ON / Remote',
      summary:
          'Architected and delivered an AI media platform with backend services, async processing, orchestration, deployment automation, and observability.',
      tags: ['AI media', 'FastAPI', 'React', 'GPU workloads'],
    ),
    _ExperienceItem(
      role: 'Software Developer',
      company: 'Snappy Inc.',
      period: 'Mar 2023 - Dec 2023',
      place: 'Toronto, ON / Remote',
      summary:
          'Delivered iOS and Android product features, including membership, rewards, sign-in, and verification workflows with reliable release iteration.',
      tags: ['Mobile product', 'iOS', 'Android', 'Release workflows'],
    ),
    _ExperienceItem(
      role: 'Software Developer',
      company: 'Neurolign Technologies Inc.',
      period: 'Jun 2021 - Dec 2022',
      place: 'Toronto, ON / Remote',
      summary:
          'Built Flutter features, API integrations, monitoring, analytics, and frontend/backend functionality across Node.js, MongoDB, Express, and React.',
      tags: ['Flutter', 'Dart', 'APIs', 'Analytics'],
    ),
    _ExperienceItem(
      role: 'Earlier full-stack SaaS engineering',
      company: 'realxdata GmbH',
      period: 'May 2018 - Sep 2019',
      place: 'Berlin, Germany',
      summary:
          'Built data-driven workflows, reporting capabilities, AWS integrations, third-party API integrations, automated tests, and CI quality loops.',
      tags: ['SaaS', 'Data workflows', 'AWS', 'CI quality'],
    ),
  ];

  static const _skillColumns = [
    _SkillColumn(
      title: 'Backend and orchestration',
      skills: [
        'Python',
        'FastAPI',
        'Node.js',
        'PostgreSQL',
        'Redis',
        'MongoDB',
        'REST APIs',
        'background jobs',
        'service-oriented architecture'
      ],
    ),
    _SkillColumn(
      title: 'AI and media systems',
      skills: [
        'PyTorch',
        'TensorRT',
        'FFmpeg',
        'model benchmarking',
        'inference pipelines',
        'GPU orchestration',
        'video enhancement'
      ],
    ),
    _SkillColumn(
      title: 'Frontend and mobile',
      skills: [
        'React',
        'Next.js',
        'TypeScript',
        'SwiftUI',
        'Flutter',
        'Dart',
        'Kotlin',
        'responsive UX',
        'release workflows'
      ],
    ),
    _SkillColumn(
      title: 'Infrastructure and delivery',
      skills: [
        'Docker',
        'Linux',
        'Nginx',
        'AWS',
        'Firebase',
        'CI/CD',
        'observability',
        'cloud deployment'
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final next =
        max <= 0 ? 0.0 : (_scrollController.offset / max).clamp(0.0, 1.0);
    if ((next - _scrollProgress).abs() > 0.002) {
      setState(() => _scrollProgress = next);
    }
  }

  void _scrollTo(String label) {
    final context = _sectionKeys[label]?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeInOutCubic,
      alignment: 0.14,
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _launchEmail({String subject = 'Project conversation'}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'aaryn.alexander@gmail.com',
      queryParameters: {'subject': subject},
    );
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch email');
    }
  }

  Future<void> _downloadResume() =>
      downloadResume(_resumeAssetPath, _resumeFileName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isDesktop = width >= 1040;
            final isCompact = width < 760;
            final maxWidth =
                math.min(width - (isCompact ? 40 : 64), 1180).toDouble();

            return MouseRegion(
              onHover: isDesktop
                  ? (event) => setState(() => _cursor = event.localPosition)
                  : null,
              onExit: isDesktop ? (_) => setState(() => _cursor = null) : null,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _PortfolioBackdropPainter(
                        cursor: _cursor,
                        scrollProgress: _scrollProgress,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, isCompact ? 100 : 118, 0, isCompact ? 44 : 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _heroSection(context,
                                  isDesktop: isDesktop, isCompact: isCompact),
                              const SizedBox(height: 46),
                              _sectionAnchor('Work',
                                  _workSection(context, isDesktop: isDesktop)),
                              const SizedBox(height: 82),
                              _sectionAnchor(
                                  'Systems',
                                  _systemsSection(context,
                                      isDesktop: isDesktop)),
                              const SizedBox(height: 82),
                              _sectionAnchor(
                                  'Experience', _experienceSection(context)),
                              const SizedBox(height: 82),
                              _sectionAnchor('Stack',
                                  _stackSection(context, isDesktop: isDesktop)),
                              const SizedBox(height: 82),
                              _sectionAnchor(
                                  'Contact',
                                  _contactSection(context,
                                      isDesktop: isDesktop)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _topNavigation(context, isCompact: isCompact),
                  _scrollProgressBar(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionAnchor(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(key: _sectionKeys[label], height: 1),
        child,
      ],
    );
  }

  Widget _heroSection(BuildContext context,
      {required bool isDesktop, required bool isCompact}) {
    final textTheme = Theme.of(context).textTheme;
    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusLine(),
        const SizedBox(height: 24),
        Text(
          'Aaryn Biro',
          style: textTheme.displayLarge?.copyWith(
            color: _ink,
            fontSize: isCompact ? 58 : 96,
            fontWeight: FontWeight.w800,
            height: 0.96,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            'Founder and principal engineer building GPU compute platforms, Next.js interfaces, AI media systems, and production-grade experiences.',
            style: textTheme.headlineSmall?.copyWith(
              color: _ink,
              height: 1.22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            'I work across architecture, backend services, mobile apps, infrastructure, and release systems - the unglamorous details that make ambitious products shippable.',
            style: textTheme.bodyLarge?.copyWith(
              color: _muted,
              height: 1.65,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: _downloadResume,
              icon: const Icon(Icons.file_download_outlined, size: 19),
              label: const Text('Download resume'),
            ),
            OutlinedButton.icon(
              onPressed: () => _launchEmail(subject: 'Building together'),
              icon: const Icon(Icons.mail_outline, size: 19),
              label: const Text('Email'),
            ),
            TextButton.icon(
              onPressed: () =>
                  _launchURL('https://www.linkedin.com/in/aabiro/'),
              icon: const Icon(Icons.north_east_rounded, size: 18),
              label: const Text('LinkedIn'),
              style: TextButton.styleFrom(foregroundColor: _ink),
            ),
            TextButton.icon(
              onPressed: () => _launchURL('https://github.com/aabiro'),
              icon: const Icon(Icons.code_rounded, size: 19),
              label: const Text('GitHub'),
              style: TextButton.styleFrom(foregroundColor: _ink),
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Wrap(
          spacing: 9,
          runSpacing: 9,
          children: [
            _Tag('GPU orchestration'),
            _Tag('FastAPI / Next.js'),
            _Tag('Flutter / SwiftUI'),
            _Tag('Docker / Nginx'),
            _Tag('London, ON'),
          ],
        ),
      ],
    );

    final visual = _HeroVisual(onDownload: _downloadResume);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: intro),
              const SizedBox(width: 54),
              Expanded(flex: 4, child: visual),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              intro,
              const SizedBox(height: 34),
              visual,
            ],
          ),
        const SizedBox(height: 42),
        _metricsGrid(isDesktop: isDesktop),
      ],
    );
  }

  Widget _statusLine() {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              const BoxDecoration(color: _green, shape: BoxShape.circle),
        ),
        const _MonoLabel('AVAILABLE FOR SELECT BUILDS'),
        Container(width: 1, height: 18, color: _line),
        Text(
          'Remote-friendly from Eastern time',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: _muted, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _metricsGrid({required bool isDesktop}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 960
            ? 4
            : (constraints.maxWidth > 600 ? 2 : 1);
        const gap = 12.0;
        final cardWidth =
            (constraints.maxWidth - (gap * (columns - 1))) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: _metrics.map((metric) {
            return SizedBox(
              width: cardWidth,
              child: _MetricCard(metric: metric),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _workSection(BuildContext context, {required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'Selected work',
          title: 'Proof over decoration.',
          body:
              'A portfolio should make the work legible fast. These are the systems and product surfaces that best represent the current direction.',
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 980 ? 3 : 1;
            const gap = 16.0;
            final cardWidth =
                (constraints.maxWidth - (gap * (columns - 1))) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: _caseStudies.map((study) {
                return SizedBox(
                  width: cardWidth,
                  child: _CaseStudyCard(study: study),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _systemsSection(BuildContext context, {required bool isDesktop}) {
    final selected =
        _capabilities.firstWhere((group) => group.name == _selectedCapability);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'Systems thinking',
          title: 'Built for moving parts.',
          body:
              'The common thread is coordination: compute, workers, queues, people, releases, and product surfaces all need to line up.',
        ),
        const SizedBox(height: 24),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 6, child: _SystemMap()),
              const SizedBox(width: 18),
              Expanded(flex: 5, child: _capabilityPanel(context, selected)),
            ],
          )
        else
          Column(
            children: [
              const _SystemMap(),
              const SizedBox(height: 18),
              _capabilityPanel(context, selected),
            ],
          ),
      ],
    );
  }

  Widget _capabilityPanel(BuildContext context, _CapabilityGroup selected) {
    return _Panel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MonoLabel('CAPABILITY LENS'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _capabilities.map((group) {
              final isSelected = group.name == _selectedCapability;
              return _SegmentButton(
                label: group.name,
                selected: isSelected,
                onTap: () => setState(() => _selectedCapability = group.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: Column(
              key: ValueKey(selected.name),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected.summary,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _ink,
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 16),
                ...selected.items.map((item) => _CapabilityRow(item: item)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _experienceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'Experience',
          title: 'Founder range, engineer depth.',
          body:
              'The page stays focused on current platform, AI, mobile, and infrastructure work. The downloadable resume carries the longer career history.',
        ),
        const SizedBox(height: 18),
        Column(
          children:
              _experience.map((item) => _TimelineItem(item: item)).toList(),
        ),
      ],
    );
  }

  Widget _stackSection(BuildContext context, {required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'Stack',
          title: 'Tools chosen for shipping.',
          body:
              'The skill set is broad, but the center of gravity is production systems: clear APIs, reliable workers, polished client surfaces, and observable deployments.',
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 980
                ? 4
                : (constraints.maxWidth > 620 ? 2 : 1);
            const gap = 14.0;
            final cardWidth =
                (constraints.maxWidth - (gap * (columns - 1))) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: _skillColumns.map((column) {
                return SizedBox(
                  width: cardWidth,
                  child: _SkillCard(column: column),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _contactSection(BuildContext context, {required bool isDesktop}) {
    final textTheme = Theme.of(context).textTheme;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MonoLabel('CONTACT'),
        const SizedBox(height: 16),
        Text(
          'Need someone who can move from architecture to shipped product?',
          style: textTheme.headlineMedium
              ?.copyWith(color: _ink, fontWeight: FontWeight.w800, height: 1.1),
        ),
        const SizedBox(height: 14),
        Text(
          'I am most useful where a product has real technical weight: compute orchestration, AI media pipelines, mobile surfaces, backend services, and the deployment machinery around them.',
          style: textTheme.bodyLarge?.copyWith(color: _muted, height: 1.62),
        ),
      ],
    );

    final actions = _Panel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Start with context.',
              style: textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800, color: _ink)),
          const SizedBox(height: 10),
          Text(
            'Send the problem, constraints, and the decision you are trying to make. I will respond with a practical next step.',
            style: textTheme.bodyMedium?.copyWith(color: _muted, height: 1.55),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => _launchEmail(subject: 'Project conversation'),
                icon: const Icon(Icons.mail_outline, size: 19),
                label: const Text('Email Aaryn'),
              ),
              OutlinedButton.icon(
                onPressed: _downloadResume,
                icon: const Icon(Icons.file_download_outlined, size: 19),
                label: const Text('Resume'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 18),
          _ContactLink(
              label: 'aaryn.alexander@gmail.com',
              icon: Icons.alternate_email,
              onTap: () => _launchEmail()),
          _ContactLink(
              label: 'linkedin.com/in/aabiro',
              icon: Icons.north_east_rounded,
              onTap: () => _launchURL('https://www.linkedin.com/in/aabiro/')),
          _ContactLink(
              label: 'github.com/aabiro',
              icon: Icons.code_rounded,
              onTap: () => _launchURL('https://github.com/aabiro')),
        ],
      ),
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: copy),
          const SizedBox(width: 28),
          Expanded(flex: 5, child: actions),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [copy, const SizedBox(height: 22), actions],
    );
  }

  Widget _topNavigation(BuildContext context, {required bool isCompact}) {
    final visibleItems = isCompact
        ? const ['Work', 'Stack', 'Contact']
        : _sectionKeys.keys.toList();
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: SafeArea(
            bottom: false,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: _alpha(_paper, 0.86),
                border: const Border(bottom: BorderSide(color: _line)),
              ),
              child: Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isCompact ? 16 : 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => _scrollController.animateTo(0,
                              duration: const Duration(milliseconds: 520),
                              curve: Curves.easeOutCubic),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _ink,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('AB',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12)),
                                ),
                                if (!isCompact) ...[
                                  const SizedBox(width: 10),
                                  const Text('Aaryn Biro',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: _ink)),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: visibleItems.map((label) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: TextButton(
                                    onPressed: () => _scrollTo(label),
                                    style: TextButton.styleFrom(
                                        foregroundColor: _ink,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10)),
                                    child: Text(label),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        if (isCompact)
                          IconButton(
                            tooltip: 'Download resume',
                            onPressed: _downloadResume,
                            icon: const Icon(Icons.file_download_outlined),
                          )
                        else
                          OutlinedButton.icon(
                            onPressed: _downloadResume,
                            icon: const Icon(Icons.file_download_outlined,
                                size: 18),
                            label: const Text('Resume'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _scrollProgressBar() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: _scrollProgress.clamp(0.0, 1.0),
            child: Container(height: 3, color: _green),
          ),
        ),
      ),
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.onDownload});

  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 0.86,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _line),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.asset('assets/headshot.JPG',
                        fit: BoxFit.cover, alignment: Alignment.topCenter),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, _alpha(_ink, 0.78)],
                      stops: const [0.56, 1],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _MonoLabel('PRINCIPAL ENGINEER', dark: false),
                    const SizedBox(height: 7),
                    Text(
                      'Architecture, infrastructure, product surfaces.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          height: 1.25,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Panel(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.description_outlined, color: _green),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Resume saved as a downloadable site asset.',
                  style: TextStyle(
                      color: _muted, height: 1.35, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                tooltip: 'Download resume',
                onPressed: onDownload,
                icon: const Icon(Icons.file_download_outlined),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(metric.value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: _ink, fontWeight: FontWeight.w900, height: 1)),
            const SizedBox(height: 8),
            Text(metric.label,
                style:
                    const TextStyle(color: _ink, fontWeight: FontWeight.w800)),
            const Spacer(),
            Text(metric.detail,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: _muted, height: 1.35)),
          ],
        ),
      ),
    );
  }
}

class _CaseStudyCard extends StatefulWidget {
  const _CaseStudyCard({required this.study});

  final _CaseStudy study;

  @override
  State<_CaseStudyCard> createState() => _CaseStudyCardState();
}

class _CaseStudyCardState extends State<_CaseStudyCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _hovering ? -4 : 0, 0),
        curve: Curves.easeOutCubic,
        child: _Panel(
          padding: EdgeInsets.zero,
          shadow: _hovering,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 5, color: widget.study.accent),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                              color: _alpha(widget.study.accent, 0.1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(widget.study.icon,
                              color: widget.study.accent),
                        ),
                        const Spacer(),
                        _MonoLabel(widget.study.kicker),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(widget.study.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: _ink,
                            fontWeight: FontWeight.w900,
                            height: 1.1)),
                    const SizedBox(height: 12),
                    Text(widget.study.summary,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: _muted, height: 1.55)),
                    const SizedBox(height: 18),
                    ...widget.study.outcomes.map((outcome) => _OutcomeLine(
                        text: outcome, color: widget.study.accent)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          widget.study.tags.map((tag) => _Tag(tag)).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SystemMap extends StatelessWidget {
  const _SystemMap();

  static const _nodes = [
    _MapNode('Public API', 'auth / contracts', Offset(0.16, 0.22), _green),
    _MapNode('Scheduler', 'queues / routing', Offset(0.50, 0.22), _coral),
    _MapNode('GPU workers', 'containers / mesh', Offset(0.84, 0.22), _blue),
    _MapNode('Billing', 'events / usage', Offset(0.30, 0.74), _blue),
    _MapNode('Observability', 'logs / traces', Offset(0.68, 0.74), _green),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 620) {
          return _Panel(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: _nodes
                  .map((node) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SystemNode(node: node),
                      ))
                  .toList(),
            ),
          );
        }
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, progress, _) {
            return _Panel(
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 370,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: CustomPaint(
                            painter: _MapLinesPainter(
                                nodes: _nodes, progress: progress))),
                    ..._nodes.map((node) {
                      return Positioned(
                        left: node.position.dx * constraints.maxWidth - 82,
                        top: node.position.dy * 370 - 42,
                        width: 164,
                        child: _SystemNode(node: node),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SystemNode extends StatelessWidget {
  const _SystemNode({required this.node});

  final _MapNode node;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _paperRaised,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 18, height: 3, color: node.color),
          const SizedBox(height: 10),
          Text(node.title,
              style: const TextStyle(color: _ink, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(node.caption,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: _muted, height: 1.25)),
        ],
      ),
    );
  }
}

class _CapabilityRow extends StatelessWidget {
  const _CapabilityRow({required this.item});

  final _Capability item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.check_rounded, color: _green, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        color: _ink, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(item.body,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: _muted, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.item});

  final _ExperienceItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Column(
            children: [
              Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                      color: _green, shape: BoxShape.circle)),
              Container(width: 1, height: 210, color: _line),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _Panel(
              padding: const EdgeInsets.all(18),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final titleWidth = math
                      .max(180.0, constraints.maxWidth - 170.0)
                      .clamp(0.0, constraints.maxWidth)
                      .toDouble();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SizedBox(
                            width: titleWidth,
                            child: Text(
                              '${item.role} / ${item.company}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: _ink, fontWeight: FontWeight.w900),
                            ),
                          ),
                          _MonoLabel(item.period),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(item.place,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: _muted, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      Text(item.summary,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: _muted, height: 1.55)),
                      const SizedBox(height: 13),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.tags.map((tag) => _Tag(tag)).toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.column});

  final _SkillColumn column;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(column.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: _ink, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: column.skills.map((skill) => _Tag(skill)).toList(),
          ),
        ],
      ),
    );
  }
}

class _ContactLink extends StatelessWidget {
  const _ContactLink(
      {required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: _green),
            const SizedBox(width: 10),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: _ink, fontWeight: FontWeight.w700))),
          ],
        ),
      ),
    );
  }
}

class _OutcomeLine extends StatelessWidget {
  const _OutcomeLine({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
                color: _alpha(color, 0.1),
                borderRadius: BorderRadius.circular(5)),
            child: Icon(Icons.arrow_forward_rounded, size: 13, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: _muted, height: 1.45))),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(
      {required this.eyebrow, required this.title, required this.body});

  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MonoLabel(eyebrow.toUpperCase()),
          const SizedBox(height: 12),
          Text(title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: _ink, fontWeight: FontWeight.w900, height: 1.05)),
          const SizedBox(height: 12),
          Text(body,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: _muted, height: 1.62)),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel(
      {required this.child,
      this.padding = const EdgeInsets.all(16),
      this.shadow = false});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: _paperRaised,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(8),
        boxShadow: shadow
            ? [
                BoxShadow(
                    color: _alpha(_ink, 0.1),
                    blurRadius: 22,
                    offset: const Offset(0, 12))
              ]
            : null,
      ),
      padding: padding,
      child: child,
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? _ink : _soft,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? _ink : _line),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: selected ? Colors.white : _ink,
              fontWeight: FontWeight.w800,
              fontSize: 13),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: _soft,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: _ink, fontWeight: FontWeight.w700)),
    );
  }
}

class _MonoLabel extends StatelessWidget {
  const _MonoLabel(this.label, {this.dark = true});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: dark ? _green : Colors.white,
        fontFamily: 'monospace',
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    );
  }
}

class _PortfolioBackdropPainter extends CustomPainter {
  const _PortfolioBackdropPainter(
      {required this.cursor, required this.scrollProgress});

  final Offset? cursor;
  final double scrollProgress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(_paper, BlendMode.src);
    final grid = Paint()
      ..color = _alpha(_ink, 0.035)
      ..strokeWidth = 1;
    const step = 38.0;
    final offset = (scrollProgress * 60) % step;
    for (double x = -offset; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = offset; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final bandPaint = Paint()
      ..color = _alpha(_green, 0.055)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 44;
    final band = Path()
      ..moveTo(size.width * 0.70, -80)
      ..lineTo(size.width + 120, size.height * 0.35);
    canvas.drawPath(band, bandPaint);

    if (cursor != null) {
      final cursorPaint = Paint()
        ..color = _alpha(_green, 0.075)
        ..strokeWidth = 1;
      canvas.drawLine(
          Offset(cursor!.dx, 0), Offset(cursor!.dx, size.height), cursorPaint);
      canvas.drawLine(
          Offset(0, cursor!.dy), Offset(size.width, cursor!.dy), cursorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PortfolioBackdropPainter oldDelegate) {
    return oldDelegate.cursor != cursor ||
        oldDelegate.scrollProgress != scrollProgress;
  }
}

class _MapLinesPainter extends CustomPainter {
  const _MapLinesPainter({required this.nodes, required this.progress});

  final List<_MapNode> nodes;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = _alpha(_ink, 0.18)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final accentPaint = Paint()
      ..color = _green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Offset point(_MapNode node) =>
        Offset(node.position.dx * size.width, node.position.dy * size.height);
    final pairs = [
      [nodes[0], nodes[1]],
      [nodes[1], nodes[2]],
      [nodes[1], nodes[3]],
      [nodes[1], nodes[4]],
      [nodes[3], nodes[4]],
    ];

    for (final pair in pairs) {
      final a = point(pair[0]);
      final b = point(pair[1]);
      final path = Path()
        ..moveTo(a.dx, a.dy)
        ..cubicTo((a.dx + b.dx) / 2, a.dy, (a.dx + b.dx) / 2, b.dy, b.dx, b.dy);
      canvas.drawPath(path, linePaint);
    }

    final animatedPair = pairs[
        (progress * (pairs.length - 1)).floor().clamp(0, pairs.length - 1)];
    final a = point(animatedPair[0]);
    final b = point(animatedPair[1]);
    final t = (progress * pairs.length) % 1;
    final marker =
        Offset(ui.lerpDouble(a.dx, b.dx, t)!, ui.lerpDouble(a.dy, b.dy, t)!);
    canvas.drawCircle(marker, 4, Paint()..color = _green);
    canvas.drawLine(Offset(marker.dx - 12, marker.dy),
        Offset(marker.dx + 12, marker.dy), accentPaint);
  }

  @override
  bool shouldRepaint(covariant _MapLinesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _Metric {
  const _Metric(this.value, this.label, this.detail);

  final String value;
  final String label;
  final String detail;
}

class _CaseStudy {
  const _CaseStudy({
    required this.title,
    required this.kicker,
    required this.summary,
    required this.outcomes,
    required this.tags,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String kicker;
  final String summary;
  final List<String> outcomes;
  final List<String> tags;
  final Color accent;
  final IconData icon;
}

class _CapabilityGroup {
  const _CapabilityGroup(
      {required this.name, required this.summary, required this.items});

  final String name;
  final String summary;
  final List<_Capability> items;
}

class _Capability {
  const _Capability(this.title, this.body);

  final String title;
  final String body;
}

class _ExperienceItem {
  const _ExperienceItem({
    required this.role,
    required this.company,
    required this.period,
    required this.place,
    required this.summary,
    required this.tags,
  });

  final String role;
  final String company;
  final String period;
  final String place;
  final String summary;
  final List<String> tags;
}

class _SkillColumn {
  const _SkillColumn({required this.title, required this.skills});

  final String title;
  final List<String> skills;
}

class _MapNode {
  const _MapNode(this.title, this.caption, this.position, this.color);

  final String title;
  final String caption;
  final Offset position;
  final Color color;
}
