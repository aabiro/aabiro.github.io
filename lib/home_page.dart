import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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

  final Map<String, List<String>> _skills = {
    'AI & Video Platform': [
      'PyTorch',
      'TensorRT',
      'GPU inference pipelines',
      'FFmpeg / WebCodecs',
      'Real-time HLS streaming',
      'Computer vision upscaling/denoise',
      'Edge caching with Nginx',
    ],
    'Backend & Data': [
      'Python / FastAPI',
      'Node.js',
      'PostgreSQL',
      'Redis',
      'Celery & queues',
      'REST / GraphQL',
      'Pub/Sub & messaging',
    ],
    'Frontend & Mobile': [
      'React 18',
      'TypeScript',
      'Tailwind CSS',
      'Flutter / Dart',
      'Kotlin / Gradle',
      'Responsive UX',
    ],
    'Cloud, Ops & Delivery': [
      'Multi-cloud GPU orchestration',
      'Docker',
      'CI/CD & GitOps',
      'AWS & Firebase',
      'Monitoring & analytics',
      'Performance tuning',
    ],
    'Product & Leadership': [
      'Product strategy',
      'Roadmapping',
      'Agile delivery',
      'Mentorship',
      'Customer discovery',
      'Rapid prototyping',
    ],
  };

  final List<Map<String, String?>> _projects = [
    {
      'title': 'PixelEnhance Labs Platform',
      'description':
          'Enterprise AI video enhancement platform for studios, creators, and media pipelines: upscaling, denoise, face/relight, and audio/VR optimization with GPU-accelerated inference.',
      'imageUrl':
          'https://images.unsplash.com/photo-1487014679447-9f8336841d58?auto=format&fit=crop&w=1200&q=80',
      'githubUrl': null,
      'liveUrl': 'https://www.linkedin.com/in/aabiro/',
      'tags': 'AI video · PyTorch · TensorRT · HLS'
    },
    {
      'title': 'Phantom Trades',
      'description':
          'AI-driven trading copilot with automated DCA-out to lock profits, controllable via Claude Desktop MCP. Runs locally on Ollama with transparent command execution (file edits, shell ops, model routing) and multi-agent handoffs.',
      'imageUrl':
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80',
      'githubUrl': null,
      'liveUrl': null,
      'tags': 'React · TypeScript · WebSockets · Ollama · MCP'
    },
    {
      'title': 'Ara Code',
      'description':
          'AI-assisted code review and authoring companion powered by Ollama + Claude Desktop MCP. Performs repo-aware search, inline linting, patch suggestions, and safe shell automation with auditable execution.',
      'imageUrl':
          'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
      'githubUrl': null,
      'liveUrl': null,
      'tags': 'FastAPI · Postgres · React · LLM tooling · MCP'
    },
    {
      'title': 'PixelSpark',
      'description':
          'On-device AI video studio for creators (Android) to capture, enhance, and publish cinematic clips with real-time GPU pipelines and ffmpeg-kit processing. Companion PixelSpark iOS client delivers native AI-powered media enhancement and export.',
      'imageUrl':
          'https://images.unsplash.com/photo-1506157786151-b8491531f063?auto=format&fit=crop&w=1200&q=80',
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 1100;
    final horizontalPadding = isWide ? 120.0 : 26.0;

    return Scaffold(
      backgroundColor: const Color(0xFF05060B),
      body: Stack(
        children: [
          _ambientBlur(const Color(0xFFF5A524),
              offset: const Offset(-120, -80)),
          _ambientBlur(const Color(0xFF6C5DD3),
              offset: Offset(size.width - 120, 120)),
          _ambientBlur(const Color(0xFF24C8A0),
              offset: Offset(120, size.height * 0.7), blur: 180),
          SingleChildScrollView(
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
        ],
      ),
    );
  }

  Widget _hero(BuildContext context, {required bool isWide}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final heroCard = Container(
      padding: EdgeInsets.all(isWide ? 32 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0C15), Color(0xFF0E1220)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF5A524).withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
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
                Text('Aaryn Biro',
                    style: textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(
                  'Founder & CEO at PixelEnhance Labs, building an enterprise AI video platform. Full-stack engineer shipping across Python/FastAPI, React/TypeScript, Flutter/Dart, and GPU-accelerated pipelines.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
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
                          subject: 'Let’s build something'),
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
                child: Container(
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
                        color: const Color(0xFF7BD6F6).withOpacity(0.35),
                        blurRadius: 45,
                        spreadRadius: 10,
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
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 18),
        child,
      ],
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
            child: SizedBox(
              height: cardHeight,
              child: _glassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18)),
                        child: Image.network(
                          project['imageUrl']!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.white10,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image_outlined,
                                color: Colors.white54),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(project['title']!,
                                style: textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(
                              project['description']!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70, height: 1.45),
                            ),
                            const SizedBox(height: 10),
                            if (project['tags'] != null)
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: project['tags']!
                                    .split('·')
                                    .map((t) => _pill(t.trim(),
                                        Colors.white.withOpacity(0.08)))
                                    .toList(),
                              ),
                            const Spacer(),
                            Wrap(
                              spacing: 10,
                              children: [
                                if (project['githubUrl'] != null)
                                  _linkButton(
                                    context,
                                    label: 'Code',
                                    icon: Icons.code,
                                    onTap: () =>
                                        _launchURL(project['githubUrl']!),
                                  ),
                                if (project['liveUrl'] != null)
                                  _linkButton(
                                    context,
                                    label: 'Live',
                                    icon: Icons.open_in_new_rounded,
                                    onTap: () =>
                                        _launchURL(project['liveUrl']!),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
    return LayoutBuilder(builder: (context, constraints) {
      final cardWidth = constraints.maxWidth / (isWide ? 2 : 1) - 10;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _skills.entries.map((entry) {
          return SizedBox(
            width: cardWidth,
            child: _glassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: entry.value
                        .map((skill) =>
                            _pill(skill, Colors.white.withOpacity(0.08)))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _cta(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _glassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Let’s build something',
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(
            'Focused on enterprise AI video products and technical leadership. If you want to ship fast with reliable GPU pipelines, let’s connect.',
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
    return ElevatedButton.icon(
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
    );
  }

  Widget _ghostButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return OutlinedButton.icon(
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }

  Widget _ambientBlur(Color color,
      {required Offset offset, double blur = 200}) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
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
    );
  }
}
