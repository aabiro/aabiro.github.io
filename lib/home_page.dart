import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui';

import 'package:aabiro_github_io/grid_pattern_painter.dart';
import 'package:aabiro_github_io/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  double _scrollOffset = 0.0;
  bool _isHeroCardHovered = false;
  bool _isPhotoHovered = false;
  String _selectedSkillCategory = 'All';
  bool _showAllSkills = false;

  bool _showCaseStudy = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _highlights = [
    {'label': 'Role', 'value': 'Founder & CEO', 'caption': 'PixelEnhance Labs'},
    {
      'label': 'Focus',
      'value': 'Enterprise AI Video',
      'caption': 'Upscale · Denoise · Realtime'
    },
    {
      'label': 'Stack',
      'value': 'Python • React',
      'caption': 'TypeScript · Node.js · Flutter · Nginx'
    },
    {
      'label': 'Location',
      'value': 'Toronto · EST',
      'caption': 'Remote friendly'
    },
  ];

  final List<Map<String, String>> _metrics = [
    {
      'value': '10K+',
      'label': 'Hours of Video',
      'caption': 'Processed & Enhanced',
    },
    {
      'value': '<25ms',
      'label': 'Latency',
      'caption': 'GPU Pipeline Performance',
    },
    {
      'value': '50+',
      'label': 'Studios',
      'caption': 'Trust PixelEnhance',
    },
    {
      'value': '4+',
      'label': 'Years',
      'caption': 'Building Production Systems',
    },
  ];

  final List<Map<String, String>> _testimonials = [
    {
      'quote':
          'Aaryn delivered exceptional work on our mobile platform. His ability to rapidly prototype and ship features while maintaining code quality was impressive.',
      'author': 'Engineering Manager',
      'company': 'Snappy',
      'role': 'Mobile Development Lead',
    },
    {
      'quote':
          'A standout engineer who combines deep technical expertise with strong product sense. Aaryn\'s contributions to our Flutter codebase were instrumental.',
      'author': 'Technical Lead',
      'company': 'Neurolign Technologies',
      'role': 'Senior Software Architect',
    },
    {
      'quote':
          'Incredibly reliable and detail-oriented. Aaryn\'s full-stack skills and AWS knowledge helped us scale our SaaS platform efficiently.',
      'author': 'CTO',
      'company': 'realxdata GmbH',
      'role': 'Chief Technology Officer',
    },
  ];

  final List<Map<String, dynamic>> _experiences = [
    {
      'role': 'Founder & CEO — PixelEnhance Labs',
      'period': 'Jan 2024 — Present',
      'bullets': [
        'Building an enterprise AI video platform for upscaling, denoising, relighting, and audio/VR optimization.',
        'Designed Python/FastAPI microservices with Redis/PostgreSQL and secure APIs.',
        'Developed React/TypeScript control plane for customers to run GPU workflows.',
        'GPU pipelines with PyTorch and TensorRT delivering sub-25ms latency.',
        'Hybrid cloud GPU fleet orchestration, observability, and Nginx edge configs.',
      ],
    },
    {
      'role': 'Software Engineer — Snappy',
      'period': 'Mar 2023 — Dec 2023',
      'bullets': [
        'Spearheaded mobile feature delivery with daily App Store/Play Store builds.',
        'Built end-to-end membership and rewards flows with robust auth/verification.',
        'Partnered in Agile sprints to turn around customer requests rapidly.',
      ],
    },
    {
      'role': 'Software Developer — Neurolign Technologies',
      'period': 'Jun 2021 — Dec 2022',
      'bullets': [
        'Shipped complex Flutter/Dart components with multithreading and modern state management.',
        'Integrated third-party APIs, CircleCI pipelines, testing, and Firebase analytics.',
        'Collaborated in Figma to deliver fully responsive mobile experiences.',
        'Built and consumed APIs with Node.js, MongoDB, and Express.',
      ],
    },
    {
      'role': 'Full Stack Software Engineer — realxdata GmbH',
      'period': 'May 2018 — Sep 2019',
      'bullets': [
        'Developed SaaS features with Ruby on Rails, React/TypeScript, Redux, and PostgreSQL.',
        'Automated workflows and data visualizations; integrated AWS (EC2, Lambda, S3) services.',
        'Maintained quality with RSpec tests and CI/CD, reducing testing time and release risk.',
      ],
    },
  ];

  final Map<String, List<Map<String, dynamic>>> _skills = {
    'AI & Video Platform': [
      {'name': 'PyTorch', 'level': 0.95},
      {'name': 'TensorRT', 'level': 0.90},
      {'name': 'GPU inference pipelines', 'level': 0.93},
      {'name': 'FFmpeg / WebCodecs', 'level': 0.88},
      {'name': 'Real-time HLS streaming', 'level': 0.85},
      {'name': 'Computer vision upscaling/denoise', 'level': 0.92},
      {'name': 'Edge caching with Nginx', 'level': 0.87},
    ],
    'Backend & Data': [
      {'name': 'Python / FastAPI', 'level': 0.95},
      {'name': 'Node.js', 'level': 0.88},
      {'name': 'PostgreSQL', 'level': 0.90},
      {'name': 'Redis', 'level': 0.85},
      {'name': 'Celery & queues', 'level': 0.82},
      {'name': 'REST / GraphQL', 'level': 0.92},
      {'name': 'Pub/Sub & messaging', 'level': 0.80},
    ],
    'Frontend & Mobile': [
      {'name': 'React 18', 'level': 0.93},
      {'name': 'TypeScript', 'level': 0.94},
      {'name': 'Tailwind CSS', 'level': 0.88},
      {'name': 'Flutter / Dart', 'level': 0.91},
      {'name': 'Kotlin / Gradle', 'level': 0.78},
      {'name': 'Responsive UX', 'level': 0.90},
    ],
    'Cloud, Ops & Delivery': [
      {'name': 'Multi-cloud GPU orchestration', 'level': 0.89},
      {'name': 'Docker', 'level': 0.92},
      {'name': 'CI/CD & GitOps', 'level': 0.87},
      {'name': 'AWS & Firebase', 'level': 0.85},
      {'name': 'Monitoring & analytics', 'level': 0.83},
      {'name': 'Performance tuning', 'level': 0.91},
    ],
    'Product & Leadership': [
      {'name': 'Product strategy', 'level': 0.88},
      {'name': 'Roadmapping', 'level': 0.85},
      {'name': 'Agile delivery', 'level': 0.90},
      {'name': 'Mentorship', 'level': 0.87},
      {'name': 'Customer discovery', 'level': 0.86},
      {'name': 'Rapid prototyping', 'level': 0.92},
    ],
  };

  final List<Map<String, String?>> _projects = [
    {
      'title': 'PixelEnhance Labs Platform',
      'description':
          'Enterprise AI video enhancement platform for studios, creators, and media pipelines: upscaling, denoise, face/relight, and audio/VR optimization with GPU-accelerated inference.',
      'imageAsset': 'assets/projects/pixelenhance.png',
      'gradientColors': '0xFF7B2FF7,0xFFF107A3', // Purple to pink gradient
      'githubUrl': null,
      'liveUrl': 'https://www.linkedin.com/in/aabiro/',
      'tags': 'AI video · PyTorch · TensorRT · HLS'
    },
    {
      'title': 'Phantom Trades',
      'description':
          'AI-driven trading copilot with automated DCA-out to lock profits, controllable via Claude Desktop MCP. Runs locally on Ollama with transparent command execution (file edits, shell ops, model routing) and multi-agent handoffs.',
      'imageAsset': 'assets/projects/phantom-trades.png',
      'gradientColors': '0xFF00D4AA,0xFF0099FF', // Teal to blue gradient
      'githubUrl': null,
      'liveUrl': null,
      'tags': 'React · TypeScript · WebSockets · Ollama · MCP'
    },
    {
      'title': 'Ara Code',
      'description':
          'AI-assisted code review and authoring companion powered by Ollama + Claude Desktop MCP. Performs repo-aware search, inline linting, patch suggestions, and safe shell automation with auditable execution.',
      'imageAsset': 'assets/projects/ara-code.png',
      'gradientColors': '0xFFFF6B6B,0xFFFFE66D', // Red to yellow gradient
      'githubUrl': null,
      'liveUrl': null,
      'tags': 'FastAPI · Postgres · React · LLM tooling · MCP'
    },
    {
      'title': 'PixelSpark',
      'description':
          'On-device AI video studio for creators (Android) to capture, enhance, and publish cinematic clips with real-time GPU pipelines and ffmpeg-kit processing. Companion PixelSpark iOS client delivers native AI-powered media enhancement and export.',
      'imageAsset': 'assets/projects/pixelspark.png',
      'gradientColors': '0xFF4FACFE,0xFF00F2FE', // Light blue to cyan gradient
      'githubUrl': null,
      'liveUrl': null,
      'tags': 'Flutter · Android GPU · ffmpeg-kit · iOS client'
    },
  ];

  // --- URL helpers ---
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _launchEmail(String email, {String subject = ''}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject},
    );
    if (!await launchUrl(emailLaunchUri)) {
      debugPrint('Could not launch email to $email');
    }
  }

  void _downloadResume() {
    // Generate resume content
    final resumeContent = _generateResumeContent();

    // Create blob and download
    final bytes = utf8.encode(resumeContent);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'Aaryn_Biro_Resume.txt')
      ..click();
    html.Url.revokeObjectUrl(url);

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resume downloaded successfully!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _generateResumeContent() {
    final buffer = StringBuffer();
    buffer.writeln('AARYN BIRO');
    buffer.writeln('=' * 80);
    buffer.writeln('Founder & CEO at PixelEnhance Labs');
    buffer.writeln('Email: aaryn.alexander@gmail.com');
    buffer.writeln('LinkedIn: https://www.linkedin.com/in/aabiro/');
    buffer.writeln('GitHub: https://github.com/aabiro');
    buffer.writeln('Location: Toronto, EST (Remote friendly)');
    buffer.writeln('\n');

    buffer.writeln('SUMMARY');
    buffer.writeln('-' * 80);
    buffer.writeln(
        'Full-stack engineer building enterprise AI video platform. Specialized in');
    buffer.writeln(
        'Python/FastAPI, React/TypeScript, Flutter/Dart, and GPU-accelerated pipelines.');
    buffer.writeln('Expertise in real-time video processing, ML model optimization, and cloud');
    buffer.writeln('infrastructure at scale.');
    buffer.writeln('\n');

    buffer.writeln('EXPERIENCE');
    buffer.writeln('-' * 80);
    for (final exp in _experiences) {
      buffer.writeln(exp['role']);
      buffer.writeln(exp['period']);
      for (final bullet in exp['bullets'] as List<String>) {
        buffer.writeln('  • $bullet');
      }
      buffer.writeln();
    }

    buffer.writeln('SKILLS');
    buffer.writeln('-' * 80);
    _skills.forEach((category, skills) {
      buffer.writeln('\n$category:');
      for (final skill in skills) {
        final level = ((skill['level'] as double) * 100).toInt();
        buffer.writeln('  • ${skill['name']} ($level%)');
      }
    });
    buffer.writeln('\n');

    buffer.writeln('PROJECTS');
    buffer.writeln('-' * 80);
    for (final project in _projects) {
      buffer.writeln('\n${project['title']}');
      buffer.writeln(project['description']);
      if (project['tags'] != null) {
        buffer.writeln('Tech: ${project['tags']}');
      }
      if (project['liveUrl'] != null) {
        buffer.writeln('URL: ${project['liveUrl']}');
      }
    }
    buffer.writeln('\n');

    buffer.writeln('=' * 80);
    buffer.writeln('Generated on ${DateTime.now().toString().split('.')[0]}');

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 1100;
    final horizontalPadding = isWide ? 120.0 : 26.0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF05060B) : const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          // Only show ambient blur in dark mode
          if (isDarkMode) ...[
            _ambientBlur(const Color(0xFFF5A524),
                offset: Offset(-120, -80 - (_scrollOffset * 0.15))),
            _ambientBlur(const Color(0xFF6C5DD3),
                offset: Offset(size.width - 120, 120 + (_scrollOffset * 0.25))),
            _ambientBlur(const Color(0xFF24C8A0),
                offset: Offset(120, size.height * 0.7 - (_scrollOffset * 0.1)), blur: 180),
          ],
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 48, horizontalPadding, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _hero(context, isWide: isWide),
                const SizedBox(height: 28),
                _highlightRow(context, isWide: isWide),
                const SizedBox(height: 36),
                _section(
                  context,
                  title: 'Projects',
                  child: _projectsGrid(context, isWide: isWide),
                ),
                const SizedBox(height: 36),
                _section(
                  context,
                  title: 'Impact & Trust',
                  child: _testimonialSection(context, isWide: isWide),
                ),
                const SizedBox(height: 36),
                _section(
                  context,
                  title: 'Case Study: PixelEnhance Labs',
                  child: _caseStudySection(context, isWide: isWide),
                ),
                const SizedBox(height: 36),
                _section(
                  context,
                  title: 'Experience',
                  child: _experienceList(context),
                ),
                const SizedBox(height: 36),
                _section(
                  context,
                  title: 'Toolkit',
                  child: _skillsGrid(context, isWide: isWide),
                ),
                const SizedBox(height: 44),
                _cta(context),
              ],
            ),
          ),
          // Theme toggle button
          Positioned(
            top: 20,
            right: isWide ? 80 : 20,
            child: _ThemeToggleButton(),
          ),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context, {required bool isWide}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final heroCard = Semantics(
      header: true,
      label: 'Introduction section with contact information',
      child: MouseRegion(
      onEnter: (_) => setState(() => _isHeroCardHovered = true),
      onExit: (_) => setState(() => _isHeroCardHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHeroCardHovered ? -2 : 0, 0),
        padding: EdgeInsets.all(isWide ? 32 : 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [const Color(0xFF0A0C15), const Color(0xFF0E1220)]
                : [const Color(0xFFFAFBFC), const Color(0xFFF8F9FA)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHeroCardHovered
                ? const Color(0xFFF5A524).withOpacity(0.4)
                : const Color(0xFFF5A524).withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.45)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 35,
              offset: const Offset(0, 14),
            ),
          ],
        ),
      child: Row(
        crossAxisAlignment:
            isWide ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isWide ? 3 : 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  style: textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: _isHeroCardHovered
                        ? const Color(0xFFF5A524)
                        : (isDarkMode ? Colors.white : const Color(0xFF0F172A)),
                  ),
                  child: const Text('Aaryn Biro'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Founder & CEO at PixelEnhance Labs, building an enterprise AI video platform. Full-stack engineer shipping across Python/FastAPI, React/TypeScript, Flutter/Dart, and GPU-accelerated pipelines.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.9)
                        : const Color(0xFF0F172A).withOpacity(0.8),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _pill('AI Video Platform', Colors.white.withOpacity(0.12)),
                    _pill('PyTorch + TensorRT', Colors.white.withOpacity(0.12)),
                    _pill('React / TypeScript', Colors.white.withOpacity(0.12)),
                    _pill('Flutter / Dart', Colors.white.withOpacity(0.12)),
                    _pill('Remote · EST', Colors.white.withOpacity(0.12)),
                  ],
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _primaryButton(
                      context,
                      label: 'Email me',
                      icon: Icons.mail_outline,
                      onTap: () => _launchEmail('aaryn.alexander@gmail.com',
                          subject: 'Let\'s build something'),
                    ),
                    _ghostButton(
                      context,
                      label: 'Download Resume',
                      icon: Icons.download,
                      onTap: _downloadResume,
                    ),
                    _ghostButton(
                      context,
                      label: 'LinkedIn',
                      icon: Icons.link,
                      onTap: () =>
                          _launchURL('https://www.linkedin.com/in/aabiro/'),
                    ),
                    _ghostButton(
                      context,
                      label: 'GitHub',
                      icon: Icons.code,
                      onTap: () => _launchURL('https://github.com/aabiro'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isWide) const SizedBox(width: 28),
          if (isWide)
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isPhotoHovered = true),
                  onExit: (_) => setState(() => _isPhotoHovered = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.identity()
                      ..scale(_isPhotoHovered ? 1.05 : 1.0)
                      ..rotateZ(_isPhotoHovered ? 0.02 : 0.0),
                    transformAlignment: Alignment.center,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7BD6F6), Color(0xFF9D7BFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7BD6F6).withOpacity(
                            _isPhotoHovered ? 0.55 : 0.35,
                          ),
                          blurRadius: _isPhotoHovered ? 55 : 45,
                          spreadRadius: _isPhotoHovered ? 15 : 10,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      backgroundImage: const AssetImage('assets/headshot.JPG'),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      ),
      ),
    );

    return heroCard;
  }

  Widget _highlightRow(BuildContext context, {required bool isWide}) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth / (isWide ? 4 : 2) - 12;
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: _highlights.map((h) {
          return SizedBox(
            width: itemWidth,
            child: _glassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h['label']!,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text(
                    h['value']!,
                    style: textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(h['caption']!,
                      style:
                          textTheme.bodySmall?.copyWith(color: Colors.white60)),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _section(BuildContext context,
      {required String title, required Widget child}) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      label: '$title section',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(title,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _projectsGrid(BuildContext context, {required bool isWide}) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: (context, constraints) {
      final columns = constraints.maxWidth > 1200
          ? 3
          : (constraints.maxWidth > 800 ? 2 : 1);
      final cardWidth = constraints.maxWidth / columns - 14;
      final cardHeight = constraints.maxWidth > 1200
          ? 520.0
          : (constraints.maxWidth > 800 ? 560.0 : 620.0);
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: _projects.map((project) {
          return SizedBox(
            width: cardWidth,
            child: _ProjectCard(
              project: project,
              cardHeight: cardHeight,
              textTheme: textTheme,
              launchURL: _launchURL,
              glassCard: _glassCard,
              pill: _pill,
              linkButton: _linkButton,
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _experienceList(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: _experiences.map((exp) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _glassCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7BD6F6), Color(0xFF9D7BFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exp['role']!,
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(exp['period']!,
                          style: textTheme.bodySmall
                              ?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 10),
                      ...List<Widget>.from(
                          (exp['bullets'] as List<String>).map((b) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Icon(Icons.brightness_1,
                                    size: 6, color: Colors.white54),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  b,
                                  style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.white70, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      })),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _skillsGrid(BuildContext context, {required bool isWide}) {
    final textTheme = Theme.of(context).textTheme;

    // Get categories for filter chips
    final categories = ['All', ..._skills.keys];

    // Filter skills based on selected category
    final filteredSkills = _selectedSkillCategory == 'All'
        ? _skills
        : {_selectedSkillCategory: _skills[_selectedSkillCategory]!};

    // Flatten skills for display limit
    final allFilteredSkills = filteredSkills.entries
        .expand((entry) => entry.value.map((skill) => {'category': entry.key, ...skill}))
        .toList();

    final displayLimit = _showAllSkills ? allFilteredSkills.length : 12;
    final displaySkills = allFilteredSkills.take(displayLimit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter chips
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories.map((category) {
            final isSelected = category == _selectedSkillCategory;
            return _filterChip(
              context,
              label: category,
              isSelected: isSelected,
              onTap: () => setState(() => _selectedSkillCategory = category),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Skills display
        LayoutBuilder(builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...displaySkills.asMap().entries.map((entry) {
                final index = entry.key;
                final skill = entry.value;
                return _AnimatedSkillBar(
                  skill: skill,
                  index: index,
                  textTheme: textTheme,
                );
              }).toList(),

              // Show All Skills button
              if (allFilteredSkills.length > 12 && !_showAllSkills)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _showAllSkills = true),
                      icon: const Icon(Icons.expand_more, size: 20, color: Color(0xFFF5A524)),
                      label: Text(
                        'Show All Skills (${allFilteredSkills.length - 12} more)',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF5A524),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF5A524)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: const Color(0xFFF5A524).withOpacity(0.1),
                      ),
                    ),
                  ),
                ),

              // Show Less button
              if (_showAllSkills && allFilteredSkills.length > 12)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _showAllSkills = false),
                      icon: const Icon(Icons.expand_less, size: 20, color: Colors.white70),
                      label: const Text(
                        'Show Less',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _filterChip(BuildContext context,
      {required String label, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF5A524).withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF5A524)
                : Colors.white.withOpacity(0.15),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isSelected ? const Color(0xFFF5A524) : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _testimonialSection(BuildContext context, {required bool isWide}) {
    return Column(
      children: [
        // Metrics row
        _metricsRow(context, isWide: isWide),
        const SizedBox(height: 32),
        // Testimonials carousel
        _testimonialsCarousel(context, isWide: isWide),
      ],
    );
  }

  Widget _metricsRow(BuildContext context, {required bool isWide}) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = constraints.maxWidth / (isWide ? 4 : 2) - 12;
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: _metrics.map((metric) {
          return SizedBox(
            width: itemWidth,
            child: _MetricCard(
              metric: metric,
              textTheme: textTheme,
              glassCard: _glassCard,
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _testimonialsCarousel(BuildContext context, {required bool isWide}) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: (context, constraints) {
      final cardWidth = constraints.maxWidth / (isWide ? 3 : 1) - (isWide ? 12 : 0);
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: _testimonials.map((testimonial) {
          return SizedBox(
            width: isWide ? cardWidth : constraints.maxWidth,
            child: _TestimonialCard(
              testimonial: testimonial,
              textTheme: textTheme,
              glassCard: _glassCard,
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _caseStudySection(BuildContext context, {required bool isWide}) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Overview card
        _glassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B2FF7), Color(0xFFF107A3)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.video_library, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enterprise AI Video Platform',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'GPU-accelerated video enhancement at scale',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Building a production-grade platform to upscale, denoise, relight, and optimize video content for studios, creators, and media pipelines. The system processes thousands of hours of video with sub-25ms GPU inference latency.',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _showCaseStudy = !_showCaseStudy),
                  icon: Icon(
                    _showCaseStudy ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF7B2FF7),
                  ),
                  label: Text(
                    _showCaseStudy ? 'Hide Details' : 'View Architecture & Details',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7B2FF7),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF7B2FF7)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: const Color(0xFF7B2FF7).withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Expanded details
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: _showCaseStudy
              ? Column(
                  children: [
                    const SizedBox(height: 20),

                    // Architecture diagram
                    _glassCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'System Architecture',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _ArchitectureDiagram(isWide: isWide),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Technical challenges grid
                    LayoutBuilder(builder: (context, constraints) {
                      final columns = isWide ? 2 : 1;
                      final cardWidth = constraints.maxWidth / columns - (isWide ? 10 : 0);
                      return Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          SizedBox(
                            width: isWide ? cardWidth : constraints.maxWidth,
                            child: _challengeCard(
                              context,
                              icon: Icons.speed,
                              title: 'Real-time Processing',
                              challenge: 'Video enhancement requires GPU-intensive ML models that traditionally take seconds per frame, making real-time processing impossible.',
                              solution: 'Optimized PyTorch models with TensorRT quantization, batching strategies, and CUDA kernel fusion to achieve <25ms inference latency on 1080p frames.',
                            ),
                          ),
                          SizedBox(
                            width: isWide ? cardWidth : constraints.maxWidth,
                            child: _challengeCard(
                              context,
                              icon: Icons.cloud_queue,
                              title: 'Multi-Cloud GPU Orchestration',
                              challenge: 'GPU availability varies across cloud providers, requiring dynamic workload distribution and failover without service interruption.',
                              solution: 'Built hybrid orchestration layer with Redis-backed queue system, health monitoring, and automatic failover across AWS, GCP, and bare-metal GPU clusters.',
                            ),
                          ),
                          SizedBox(
                            width: isWide ? cardWidth : constraints.maxWidth,
                            child: _challengeCard(
                              context,
                              icon: Icons.security,
                              title: 'Secure Video Pipeline',
                              challenge: 'Handling sensitive media content from studios requires end-to-end encryption, access control, and audit logging.',
                              solution: 'Implemented AES-256 encryption at rest, TLS 1.3 in transit, JWT-based auth with role-based access control, and comprehensive audit trails in PostgreSQL.',
                            ),
                          ),
                          SizedBox(
                            width: isWide ? cardWidth : constraints.maxWidth,
                            child: _challengeCard(
                              context,
                              icon: Icons.analytics,
                              title: 'Edge Caching & Delivery',
                              challenge: 'Global users require low-latency access to processed videos, but storing all variants is cost-prohibitive.',
                              solution: 'Designed Nginx-based edge caching with HLS streaming, adaptive bitrate encoding, and intelligent cache invalidation reducing CDN costs by 65%.',
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _challengeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String challenge,
    required String solution,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return _glassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A524).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFFF5A524), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red.shade300),
                    const SizedBox(width: 6),
                    Text(
                      'Challenge',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  challenge,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00D4AA).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF00D4AA).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: const Color(0xFF00D4AA)),
                    const SizedBox(width: 6),
                    const Text(
                      'Solution',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color(0xFF00D4AA),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  solution,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cta(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _glassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Let\'s build something',
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(
            'Focused on enterprise AI video products and technical leadership. If you want to ship fast with reliable GPU pipelines, let\'s connect.',
            style: textTheme.bodyLarge
                ?.copyWith(color: Colors.white.withOpacity(0.9), height: 1.55),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _primaryButton(
                context,
                label: 'Email',
                icon: Icons.mail,
                onTap: () => _launchEmail('aaryn.alexander@gmail.com',
                    subject: 'Collaboration'),
              ),
              _ghostButton(
                context,
                label: 'LinkedIn',
                icon: Icons.person_pin_circle_outlined,
                onTap: () => _launchURL('https://www.linkedin.com/in/aabiro/'),
              ),
              _ghostButton(
                context,
                label: 'GitHub',
                icon: Icons.code_outlined,
                onTap: () => _launchURL('https://github.com/aabiro'),
              ),
            ],
          )
        ],
      ),
    );
  }

  // --- UI helpers ---
  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Text(
        text,
        style:
            const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }

  Widget _primaryButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return Semantics(
      button: true,
      label: label,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: const Color(0xFF0A0C15)),
        label: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: Color(0xFF0A0C15))),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5A524),
          foregroundColor: const Color(0xFF0A0C15),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          shadowColor: Colors.black.withOpacity(0.35),
          elevation: 4,
          overlayColor: Colors.black.withOpacity(0.05),
        ),
      ),
    );
  }

  Widget _ghostButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return Semantics(
      button: true,
      label: label,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: Colors.white),
        label: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: Colors.white)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white.withOpacity(0.65)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: Colors.white.withOpacity(0.08),
          overlayColor: Colors.white.withOpacity(0.12),
        ),
      ),
    );
  }

  Widget _linkButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _glassCard(
      {required Widget child,
      EdgeInsetsGeometry padding = const EdgeInsets.all(16)}) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.06)
                    : const Color(0xFFF8FAFC).withOpacity(0.9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.12)
                      : Colors.black.withOpacity(0.08),
                ),
              ),
              padding: padding,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _ambientBlur(Color color,
      {required Offset offset, double blur = 200}) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 0),
      left: offset.dx,
      top: offset.dy,
      child: IgnorePointer(
        child: Container(
          width: blur,
          height: blur,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.25),
                color.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatefulWidget {
  const _MetricCard({
    required this.metric,
    required this.textTheme,
    required this.glassCard,
  });

  final Map<String, String> metric;
  final TextTheme textTheme;
  final Widget Function({required Widget child, EdgeInsetsGeometry padding}) glassCard;

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -4.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7BD6F6).withOpacity(_isHovered ? 0.15 : 0.0),
              blurRadius: _isHovered ? 20 : 0,
              spreadRadius: _isHovered ? 1 : 0,
              offset: Offset(0, _isHovered ? 8 : 0),
            ),
          ],
        ),
        child: widget.glassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.metric['value']!,
                style: widget.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF7BD6F6),
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.metric['label']!,
                style: widget.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.metric['caption']!,
                style: widget.textTheme.bodySmall?.copyWith(
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatefulWidget {
  const _TestimonialCard({
    required this.testimonial,
    required this.textTheme,
    required this.glassCard,
  });

  final Map<String, String> testimonial;
  final TextTheme textTheme;
  final Widget Function({required Widget child, EdgeInsetsGeometry padding}) glassCard;

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -2.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF5A524).withOpacity(_isHovered ? 0.1 : 0.0),
              blurRadius: _isHovered ? 20 : 0,
              spreadRadius: _isHovered ? 1 : 0,
              offset: Offset(0, _isHovered ? 6 : 0),
            ),
          ],
        ),
        child: widget.glassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote icon
              Icon(
                Icons.format_quote,
                size: 32,
                color: const Color(0xFFF5A524).withOpacity(0.3),
              ),
              const SizedBox(height: 12),
              // Quote text
              Text(
                widget.testimonial['quote']!,
                style: widget.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              // Divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF5A524).withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Author info
              Row(
                children: [
                  // Avatar placeholder
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7BD6F6), Color(0xFF9D7BFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.testimonial['author']!.substring(0, 1),
                        style: widget.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.testimonial['author']!,
                          style: widget.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.testimonial['role']} · ${widget.testimonial['company']}',
                          style: widget.textTheme.bodySmall?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedSkillBar extends StatefulWidget {
  const _AnimatedSkillBar({
    required this.skill,
    required this.index,
    required this.textTheme,
  });

  final Map<String, dynamic> skill;
  final int index;
  final TextTheme textTheme;

  @override
  State<_AnimatedSkillBar> createState() => _AnimatedSkillBarState();
}

class _AnimatedSkillBarState extends State<_AnimatedSkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Stagger the animation based on index
    final delay = widget.index * 50;
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        _controller.forward();
      }
    });

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.skill['level'] as double,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColorForLevel(double level) {
    if (level >= 0.9) {
      return const Color(0xFF00D4AA); // Cyan for expert
    } else if (level >= 0.75) {
      return const Color(0xFFF5A524); // Golden for proficient
    } else {
      return const Color(0xFF9D7BFF); // Purple for intermediate
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.skill['level'] as double;
    final name = widget.skill['name'] as String;
    final color = _getColorForLevel(level);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skill name and percentage
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: widget.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.95),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isHovered ? 1.0 : 0.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: color.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              '${(level * 100).toInt()}%',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Progress bar background
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Stack(
                        children: [
                          // Animated progress bar
                          FractionallySizedBox(
                            widthFactor: _progressAnimation.value,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    color,
                                    color.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: _isHovered
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.4),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThemeToggleButton extends StatefulWidget {
  @override
  State<_ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<_ThemeToggleButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFF8FAFC);
    final iconColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);

    if (isDarkMode) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    return Semantics(
      button: true,
      label: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                MyApp.of(context)?.toggleTheme();
              },
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.15)
                        : Colors.black.withOpacity(0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: _isHovered ? 16 : 12,
                      offset: Offset(0, _isHovered ? 6 : 4),
                    ),
                  ],
                ),
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 400),
                  turns: isDarkMode ? 0.0 : 0.5,
                  child: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArchitectureDiagram extends StatelessWidget {
  const _ArchitectureDiagram({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Client Layer
            _architectureRow(
              context,
              title: 'Client Layer',
              color: const Color(0xFF7BD6F6),
              components: [
                _component('React/TypeScript Control Plane', Icons.web),
                _component('HLS Video Player', Icons.play_circle_outline),
                _component('Real-time Dashboard', Icons.dashboard),
              ],
            ),
            _arrow(context),

            // API Gateway
            _architectureRow(
              context,
              title: 'API Gateway',
              color: const Color(0xFFF5A524),
              components: [
                _component('FastAPI Services', Icons.api),
                _component('JWT Auth', Icons.security),
                _component('Rate Limiting', Icons.speed),
              ],
            ),
            _arrow(context),

            // Processing Layer
            _architectureRow(
              context,
              title: 'GPU Processing',
              color: const Color(0xFF7B2FF7),
              components: [
                _component('PyTorch Models', Icons.psychology),
                _component('TensorRT Inference', Icons.bolt),
                _component('FFmpeg Pipeline', Icons.video_library),
              ],
            ),
            _arrow(context),

            // Storage & Delivery
            _architectureRow(
              context,
              title: 'Storage & CDN',
              color: const Color(0xFF00D4AA),
              components: [
                _component('S3 Object Storage', Icons.cloud),
                _component('Nginx Edge Cache', Icons.cached),
                _component('HLS Streaming', Icons.stream),
              ],
            ),
            _arrow(context),

            // Data Layer
            _architectureRow(
              context,
              title: 'Data Layer',
              color: const Color(0xFF9D7BFF),
              components: [
                _component('PostgreSQL', Icons.storage),
                _component('Redis Queue', Icons.queue),
                _component('Analytics DB', Icons.analytics),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _architectureRow(
    BuildContext context, {
    required String title,
    required Color color,
    required List<Widget> components,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: components,
        ),
      ],
    );
  }

  Widget _component(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_downward,
            color: Colors.white.withOpacity(0.3),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard(
      {required this.project,
      required this.cardHeight,
      required this.textTheme,
      required this.launchURL,
      required this.glassCard,
      required this.pill,
      required this.linkButton});

  final Map<String, String?> project;
  final double cardHeight;
  final TextTheme textTheme;
  final Future<void> Function(String url) launchURL;
  final Widget Function({required Widget child, EdgeInsetsGeometry padding})
      glassCard;
  final Widget Function(String text, Color color) pill;
  final Widget Function(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) linkButton;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool expanded = false;
  bool _imageLoadError = false;

  Widget _buildProjectImage(Map<String, String?> project) {
    final imageAsset = project['imageAsset'];
    final gradientColorsStr = project['gradientColors'];

    // Try to load local asset first
    if (imageAsset != null && !_imageLoadError) {
      return Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // If asset doesn't exist, show gradient placeholder
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _imageLoadError = true);
            }
          });
          return _buildGradientPlaceholder(gradientColorsStr);
        },
      );
    }

    // Show gradient placeholder
    return _buildGradientPlaceholder(gradientColorsStr);
  }

  Widget _buildGradientPlaceholder(String? gradientColorsStr) {
    List<Color> gradientColors = [
      const Color(0xFF7BD6F6),
      const Color(0xFF9D7BFF)
    ];

    if (gradientColorsStr != null) {
      final colors = gradientColorsStr.split(',');
      if (colors.length == 2) {
        try {
          gradientColors = [
            Color(int.parse(colors[0])),
            Color(int.parse(colors[1])),
          ];
        } catch (e) {
          // Use default gradient if parsing fails
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Pattern overlay for visual interest
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: GridPatternPainter(),
              ),
            ),
          ),
          // Project icon
          Center(
            child: Icon(
              Icons.image_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // "Add Screenshot" hint
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Text(
                'Add Screenshot',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desc = widget.project['description'] ?? '';
    final isLong = desc.length > 180;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: widget.cardHeight),
      child: widget.glassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: _buildProjectImage(widget.project),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.project['title']!,
                      style: widget.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    maxLines: expanded ? null : 4,
                    overflow:
                        expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: widget.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white70, height: 1.45),
                  ),
                  const SizedBox(height: 10),
                  if (widget.project['tags'] != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: widget.project['tags']!
                          .split('·')
                          .map((t) => widget.pill(
                              t.trim(), Colors.white.withOpacity(0.08)))
                          .toList(),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            if (widget.project['githubUrl'] != null)
                              widget.linkButton(
                                context,
                                label: 'Code',
                                icon: Icons.code,
                                onTap: () => widget
                                    .launchURL(widget.project['githubUrl']!),
                              ),
                            if (widget.project['liveUrl'] != null)
                              widget.linkButton(
                                context,
                                label: 'Live',
                                icon: Icons.open_in_new_rounded,
                                onTap: () => widget
                                    .launchURL(widget.project['liveUrl']!),
                              ),
                          ],
                        ),
                      ),
                      if (isLong)
                        TextButton(
                          onPressed: () => setState(() => expanded = !expanded),
                          child: Text(
                            expanded ? 'Show less' : 'Show more',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
