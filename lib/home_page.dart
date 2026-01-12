import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Map<String, String>> _highlights = [
    {'label': 'Years shipping', 'value': '5+', 'caption': 'Product & platform'},
    {
      'label': 'Stacks',
      'value': 'Mobile/Web',
      'caption': 'Flutter, React, Rails'
    },
    {
      'label': 'Recent focus',
      'value': 'AI + UX',
      'caption': 'Realtime + LLM assist'
    },
    {
      'label': 'Based in',
      'value': 'Canada',
      'caption': 'EST · Remote friendly'
    },
  ];

  final List<Map<String, dynamic>> _experiences = [
    {
      'role': 'Senior Software Engineer (Freelance)',
      'period': '2022 — Now',
      'bullets': [
        'Shipping full-stack apps across Flutter, React, and Rails.',
        'Realtime experiences: websockets, live maps, chat, streaming data.',
        'Cloud/devops: Firebase, Render, Heroku, CI/CD, observability.'
      ],
    },
    {
      'role': 'Full Stack Engineer',
      'period': '2019 — 2022',
      'bullets': [
        'Built SaaS features end-to-end with React, Node/Rails, and Postgres.',
        'Led UI refreshes with modern design systems and accessibility focus.',
        'Mentored juniors; improved release cadence with automation.'
      ],
    },
  ];

  final Map<String, List<String>> _skills = {
    'Frontend & Mobile': [
      'Flutter',
      'Dart',
      'React',
      'TypeScript',
      'Next.js',
      'Responsive UX',
    ],
    'Backend & Data': [
      'Node.js',
      'Ruby on Rails',
      'PostgreSQL',
      'MongoDB',
      'REST/GraphQL',
    ],
    'Cloud & Ops': [
      'AWS',
      'Firebase',
      'CI/CD',
      'Docker',
      'Testing/TDD',
      'Observability',
    ],
    'Product & Delivery': [
      'UX Writing',
      'Rapid prototyping',
      'Analytics',
      'A/B testing',
      'Agile delivery',
    ],
  };

  final List<Map<String, String?>> _projects = [
    {
      'title': 'AI Smart Subscription Tracker',
      'description':
          'Cross-platform (iOS/Android/Web) tracker with Firebase auth/hosting, Supabase realtime data, and AI-powered insights. Polished UX built in Flutter.',
      'imageUrl': 'https://i.imgur.com/1A76oxy.png',
      'githubUrl': 'https://github.com/aabiro/smart_subscription_tracker',
      'liveUrl': 'https://smart-subscription-tracker-app.web.app',
      'tags': 'Flutter · Firebase · Supabase · AI'
    },
    {
      'title': 'TTC LiveChat: Real-Time Transit Map',
      'description':
          'Rails API (Postgres, Redis, Action Cable) + React/TypeScript frontend for live vehicles, alerts, chat, and reporting with Leaflet maps.',
      'imageUrl': 'https://i.imgur.com/QrtWtLE.png',
      'githubUrl': 'https://github.com/aabiro/ttc_realtime_app',
      'liveUrl': 'https://ttc-realtime-app-frontend.onrender.com/',
      'tags': 'Rails · React · WebSockets · Leaflet'
    },
    {
      'title': 'GivnGo',
      'description':
          'Peer-to-peer bicycle rental app for iOS/Android with location search, secure payments, and real-time booking in Flutter.',
      'imageUrl':
          'https://raw.githubusercontent.com/aabiro/GivnGo/refs/heads/master/assets/gnglogo.png',
      'githubUrl': 'https://github.com/aabiro/GivnGo',
      'liveUrl': null,
      'tags': 'Flutter · Mobile · Payments'
    },
    {
      'title': 'Recipe Finder',
      'description':
          'Rails API + React frontend with live search filtering, deployed to Render. Clean separation of data + UI.',
      'imageUrl': 'https://i.imgur.com/1nC5IA0.jpeg',
      'githubUrl':
          'https://github.com/aabiro/react_rails_recipe_app?tab=readme-ov-file#recipe-finder-application',
      'liveUrl': 'https://rails-react-recipe-finder-frontend.onrender.com/',
      'tags': 'Rails · React · Render'
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
          _ambientBlur(const Color(0xFF7BD6F6),
              offset: const Offset(-120, -80)),
          _ambientBlur(const Color(0xFF9D7BFF),
              offset: Offset(size.width - 120, 120)),
          _ambientBlur(const Color(0xFF0CF3C5),
              offset: const Offset(120, size.height * 0.7), blur: 180),
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
          colors: [Color(0xFF0D1324), Color(0xFF0A0F1A)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 35,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Building thoughtful, fast experiences across mobile, web, and backend. Flutter fan, React/Rails fluent, obsessed with clean UX and realtime data.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _pill('Flutter & Dart', colorScheme.primary),
                    _pill('React / TypeScript', colorScheme.secondary),
                    _pill('Rails & Postgres', colorScheme.tertiary),
                    _pill('Realtime UX', Colors.white12),
                    _pill('Remote · EST', Colors.white12),
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
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: _projects.map((project) {
          return SizedBox(
            width: cardWidth,
            child: _glassCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(18)),
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
                  Padding(
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
                          style: textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70, height: 1.45),
                        ),
                        const SizedBox(height: 10),
                        if (project['tags'] != null)
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: project['tags']!
                                .split('·')
                                .map((t) => _pill(
                                    t.trim(), Colors.white.withOpacity(0.08)))
                                .toList(),
                          ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          children: [
                            if (project['githubUrl'] != null)
                              _linkButton(
                                context,
                                label: 'Code',
                                icon: Icons.code,
                                onTap: () => _launchURL(project['githubUrl']!),
                              ),
                            if (project['liveUrl'] != null)
                              _linkButton(
                                context,
                                label: 'Live',
                                icon: Icons.open_in_new_rounded,
                                onTap: () => _launchURL(project['liveUrl']!),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
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
            'Open to product-minded roles, freelance engagements, and collaborations. I care about craft, clear communication, and shipping fast.',
            style: textTheme.bodyLarge
                ?.copyWith(color: Colors.white70, height: 1.55),
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
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7BD6F6),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        side: BorderSide(color: Colors.white.withOpacity(0.25)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.white.withOpacity(0.04),
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
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
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
