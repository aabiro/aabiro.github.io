import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Helper function to launch URLs safely
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
      // Consider showing a SnackBar or Dialog to the user
    }
  }

  // Helper function to launch email client
  Future<void> _launchEmail(String email, {String subject = ''}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject},
    );
    if (!await launchUrl(emailLaunchUri)) {
      print('Could not launch email to $email');
    }
  }

  // Helper function to get chip color based on skill text
  Color _getChipColor(String skill, ColorScheme colorScheme) {
    // Simple categorization based on keywords
    final lowerSkill = skill.toLowerCase();
    // Using slightly less saturated colors for a softer look
    if (lowerSkill.contains('flutter') || lowerSkill.contains('dart')) {
      return Colors.blue[100] ?? colorScheme.primaryContainer; // Mobile
    } else if (lowerSkill.contains('react') ||
        lowerSkill.contains('javascript') ||
        lowerSkill.contains('html') ||
        lowerSkill.contains('css')) {
      return Colors.teal[100] ?? colorScheme.secondaryContainer; // Frontend
    } else if (lowerSkill.contains('node.js') ||
        lowerSkill.contains('ruby') ||
        lowerSkill.contains('rails') ||
        lowerSkill.contains('sql') ||
        lowerSkill.contains('mongo') ||
        lowerSkill.contains('rest')) {
      return Colors.amber[200] ?? colorScheme.tertiaryContainer; // Backend
    } else if (lowerSkill.contains('aws') ||
        lowerSkill.contains('docker') ||
        lowerSkill.contains('git') ||
        lowerSkill.contains('ci/cd')) {
      return Colors.deepPurple[100] ?? Colors.indigo[100]!; // DevOps/Tools
    } else {
      return Colors.grey[300] ?? colorScheme.surfaceVariant; // Concepts/Other
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Define consistent horizontal padding based on screen size
    final horizontalPadding = screenSize.width > 900
        ? screenSize.width * 0.1
        : 30.0; // Use percentage for larger screens
    const String profileImagePath =
        'assets/headshot.JPG'; // Ensure this path is correct in pubspec.yaml

    return Scaffold(
      // Use a slightly off-white background for the main body
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- 1. Hero/Header Section ---
            Container(
              // Slightly reduced height for better balance on smaller screens
              height: screenSize.height * 0.55 < 400
                  ? 400
                  : screenSize.height * 0.55,
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 50.0),
              decoration: BoxDecoration(
                // More subtle gradient using theme colors
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withOpacity(0.9),
                    colorScheme.secondary.withOpacity(0.8),
                  ],
                ),
                // Optional: Add a subtle bottom curve or shape
                // borderRadius: const BorderRadius.vertical(bottom: Radius.elliptical(150, 30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add a subtle shadow/border to the avatar
                  CircleAvatar(
                    radius: 65, // Slightly larger
                    backgroundColor: colorScheme
                        .surface, // Use surface color for border effect
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300], // Fallback background
                      backgroundImage: const AssetImage(profileImagePath),
                      onBackgroundImageError: (exception, stackTrace) {
                        print('Error loading profile image: $exception');
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Aaryn Biro',
                    // Use headlineLarge for more impact, adjust size if needed
                    style: textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold, // Bolder name
                        shadows: [
                          // Add subtle text shadow for readability
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(1.0, 1.0),
                          ),
                        ]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Software Developer | Flutter Enthusiast | Web Creator', // Slightly refined title
                    style: textTheme.titleMedium?.copyWith(
                      // Slightly smaller subtitle
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 0.5, // Add subtle letter spacing
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // --- 2. About Section ---
            _buildSection(
              context: context,
              title: 'About Me',
              child: Text(
                'Hello! I\'m Aaryn, a Canadian with a love for both coding and adventure. As a Software Engineer, I\'ve had the opportunity to work on exciting projects in diverse locations, including Berlin and Toronto, building everything from mobile apps to complex SaaS platforms. My tech stack includes a wide range of technologies, from JavaScript and React to Ruby on Rails and Flutter. Beyond the keyboard, I\'m an avid runner, traveler, and skier, always eager to discover new places and meet new people. I\'m excited to connect with the online community to share stories and learn from others\' experiences!',
                // Increased line height for better readability
                style: textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
              // Use alternating background colors for sections
              backgroundColor: colorScheme.surfaceContainerLowest,
              horizontalPadding: horizontalPadding,
            ),

            // --- 3. Projects Section ---
            _buildSection(
              context: context,
              title: 'Projects',
              // --- FIX: Pass horizontalPadding to _buildProjectsGrid ---
              child: _buildProjectsGrid(context,
                  horizontalPadding: horizontalPadding),
              // --- END FIX ---
              // Use alternating background colors
              backgroundColor: colorScheme.surfaceContainerLow,
              horizontalPadding: horizontalPadding,
            ),

            // --- 4. Skills Section ---
            _buildSection(
              context: context,
              title: 'Skills',
              child: Builder(builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                final skills = [
                  'Mobile development (Flutter)',
                  'Full Stack web development',
                  'Node.js',
                  'Mongo',
                  'React',
                  'Ruby on Rails',
                  'JavaScript',
                  'HTML',
                  'CSS',
                  'AWS',
                  'SQL',
                  'Docker',
                  'Firebase',
                  'Git',
                  'REST APIs',
                  'UI/UX (Basics)',
                  'Responsive Design',
                  'CI/CD',
                  'TDD',
                  'BDD',
                  'Ruby',
                  'Dart'
                ];

                return Wrap(
                  spacing: 10.0, // Slightly reduced spacing
                  runSpacing: 10.0,
                  children: skills.map((skill) {
                    final chipColor = _getChipColor(skill, colorScheme);
                    final textColor = chipColor.computeLuminance() > 0.5
                        ? Colors.black
                            .withOpacity(0.8) // Slightly transparent black
                        : Colors.white
                            .withOpacity(0.95); // Slightly transparent white

                    return Chip(
                      label: Text(skill),
                      backgroundColor:
                          chipColor.withOpacity(0.9), // Slight transparency
                      labelStyle: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13, // Slightly smaller font size
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0), // Adjusted padding
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Less rounded
                          side: BorderSide(
                            color: chipColor.computeLuminance() > 0.5
                                ? Colors.black.withOpacity(0.1)
                                : Colors.white.withOpacity(
                                    0.2), // Border based on contrast
                            width: 1.0,
                          )),
                      // Removed elevation for a flatter look, relying on color and border
                      // elevation: 1.0,
                    );
                  }).toList(),
                );
              }),
              backgroundColor:
                  colorScheme.surfaceContainerLowest, // Alternating color
              horizontalPadding: horizontalPadding,
            ),

            // --- 5. Contact Section ---
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 70.0), // Increased padding
              color: colorScheme.primaryContainer
                  .withOpacity(0.8), // Use primary container color with opacity
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Get In Touch',
                    style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "I'm currently open to new opportunities and collaborations.\nFeel free to reach out via email or connect with me on LinkedIn!", // Added line break
                    style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.9),
                        height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: [
                      // Enhanced Button Styles
                      _buildContactButton(
                        context: context,
                        icon: Icons.email,
                        label: 'Email Me',
                        onPressed: () => _launchEmail(
                            'aaryn.alexander@gmail.com',
                            subject: 'Website Contact'),
                        isPrimary: true, // Primary style for email
                      ),
                      _buildContactButton(
                        context: context,
                        icon: Icons.link, // Consider specific icons later
                        label: 'LinkedIn',
                        onPressed: () =>
                            _launchURL('https://www.linkedin.com/in/aabiro/'),
                      ),
                      _buildContactButton(
                        context: context,
                        icon: Icons.code, // Consider specific icons later
                        label: 'GitHub',
                        onPressed: () =>
                            _launchURL('https://github.com/aabiro'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- 6. Footer ---
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: horizontalPadding), // Increased padding
              color: colorScheme
                  .surfaceContainer, // Slightly darker footer background
              alignment: Alignment.center,
              child: Text(
                '© ${DateTime.now().year} Aaryn Biro. Built with Flutter.',
                style: textTheme.bodyMedium // Slightly larger footer text
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build standard sections
  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Widget child,
    required Color backgroundColor,
    required double horizontalPadding,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 60.0), // Increased vertical padding
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            // Bolder section titles
            style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 35), // Increased spacing after title
          child,
        ],
      ),
    );
  }

  // Helper widget to build the projects grid/list
  // --- FIX: Added horizontalPadding parameter ---
  Widget _buildProjectsGrid(BuildContext context,
      {required double horizontalPadding}) {
    // --- END FIX ---
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;

    // Project data (ensure descriptions are detailed enough for expansion)
    final projects = [
      {
        'title': 'TTC LiveChat: Real-Time Transit Map',
        'description':
            'Full-stack real-time TTC tracking & chat app using a Rails API (PostgreSQL, Redis, Action Cable) and a React/TypeScript frontend. Demonstrates WebSocket data handling, API integration, and Leaflet map visualization. The Rails API serves live vehicle/alert/route data and persists user messages/reports via REST and WebSockets. The React frontend consumes these streams for a dynamic Leaflet map showing live vehicles, routes, reports, alerts, and includes route-specific chat. Deployed with Rails on Heroku and React on Render (Static Site), showcasing full-stack deployment with WebSockets. Backend: Ruby on Rails (API), PostgreSQL, Redis, Action Cable, Puma. Frontend: React, TypeScript, Vite, Leaflet, React-Leaflet, Tailwind CSS, Axios. Deployment: Heroku (Backend), Render (Frontend Static Site).',
        'imageUrl': 'https://i.imgur.com/QrtWtLE.png',
        'githubUrl':
            'https://github.com/aabiro/ttc_realtime_app',
        'liveUrl': 'https://ttc-realtime-app-frontend.onrender.com/',
      },
      {
        'title': 'GivnGo',
        'description':
            'Developed a peer-to-peer bicycle rental mobile app (iOS/Android) using Flutter/Dart. The platform allows users to easily find and rent bikes for city transport or lend their own for extra income. Features include location-based search, secure payments, user profiles, and real-time booking management.',
        'imageUrl':
            'https://raw.githubusercontent.com/aabiro/GivnGo/refs/heads/master/assets/gnglogo.png', // Placeholder
        'githubUrl': 'https://github.com/aabiro/GivnGo',
        'liveUrl': null, // Optional live demo URL
      },
      {
        'title': 'Flutter Countdown Timer',
        'description':
            'Developed a responsive countdown timer using Flutter, demonstrating cross-platform capabilities for seamless use on mobile devices and the web. Includes features like setting custom durations, pause/resume functionality, and visual feedback.',
        'imageUrl': 'https://i.imgur.com/z68LtyT.png',
        'githubUrl':
            'https://github.com/aabiro/flutter_countdown_timer?tab=readme-ov-file#countdown_pal_app',
        // 'liveUrl': 'https://your-dashboard-live-url.com',
      },
      {
        'title': 'Recipe Finder Application',
        'description':
            'A full-stack recipe search application featuring a Ruby on Rails API backend (with PostgreSQL) and a dynamic React frontend. Demonstrates REST API consumption and separation of concerns between data management and user interface presentation. The Rails API serves recipe data through RESTful endpoints, while the React frontend consumes this API to provide a seamless and interactive user experience, including real-time search filtering and detailed recipe views. Both components are deployed live using Render, showcasing experience with cloud platform deployment for full-stack applications.',
        'imageUrl': 'https://i.imgur.com/1nC5IA0.jpeg',
        'githubUrl':
            'https://github.com/aabiro/react_rails_recipe_app?tab=readme-ov-file#recipe-finder-application',
        'liveUrl': 'https://rails-react-recipe-finder-frontend.onrender.com/',
      },
    ];

    // Determine number of columns based on screen width
    int crossAxisCount = screenSize.width > 1200
        ? 3
        : (screenSize.width > 700 ? 2 : 1); // Adjusted breakpoint

    // Calculate desired aspect ratio based on testing or fixed height approach
    double cardHeight = 420; // Define a target height for the card
    // --- FIX: Use horizontalPadding in calculation ---
    double availableWidth = screenSize.width - (horizontalPadding * 2);
    double cardWidth =
        (availableWidth - (25.0 * (crossAxisCount - 1))) / crossAxisCount;
    // --- END FIX ---
    double aspectRatio =
        cardWidth > 0 ? cardWidth / cardHeight : 0.8; // Avoid division by zero

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 25.0, // Increased spacing
        mainAxisSpacing: 25.0, // Increased spacing
        // Use calculated aspect ratio
        childAspectRatio: aspectRatio,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          // Slightly increased elevation and softer shadow
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12)), // Slightly larger radius
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  project['imageUrl']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200], // Lighter placeholder
                      alignment: Alignment.center,
                      child: Icon(Icons.broken_image_outlined, // Different icon
                          color: Colors.grey[500],
                          size: 40),
                    );
                  },
                ),
              ),
              // Project Details - Use Flexible instead of Expanded for better control with SingleChildScrollView
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0), // Consistent padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Take minimum space needed
                    children: [
                      Text(
                        project['title']!,
                        style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold), // Bolder title
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      _ExpandableText(
                        text: project['description']!,
                        style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant), // Subtler text color
                        maxLength: 90, // Slightly shorter default length
                      ),
                      const SizedBox(height: 16), // More space before buttons
                      Wrap(
                        spacing: 10,
                        runSpacing: 4,
                        children: [
                          if (project['githubUrl'] != null)
                            _buildLinkButton(
                              context: context,
                              icon: Icons.code_outlined, // Outlined icon
                              label: 'GitHub',
                              onPressed: () =>
                                  _launchURL(project['githubUrl']!),
                            ),
                          if (project['liveUrl'] != null)
                            _buildLinkButton(
                              context: context,
                              icon: Icons.open_in_new_outlined, // Outlined icon
                              label: 'Live Demo',
                              onPressed: () => _launchURL(project['liveUrl']!),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- ADDED: Helper for consistent TextButton styling in cards ---
  Widget _buildLinkButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextButton.icon(
      icon: Icon(icon, size: 18, color: colorScheme.primary),
      label: Text(label, style: TextStyle(color: colorScheme.primary)),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            horizontal: 4, vertical: 2), // Minimal padding
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Smaller tap target
        visualDensity: VisualDensity.compact, // Compact density
        textStyle: const TextStyle(fontSize: 13), // Smaller text
      ),
    );
  }

  // --- ADDED: Helper for consistent ElevatedButton styling in contact section ---
  Widget _buildContactButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false, // Flag for primary button style
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton.icon(
      icon: Icon(icon, size: 20), // Slightly larger icon
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // Conditional styling based on isPrimary flag
        foregroundColor:
            isPrimary ? colorScheme.onPrimary : colorScheme.primary,
        backgroundColor: isPrimary ? colorScheme.primary : colorScheme.surface,
        side: isPrimary
            ? null
            : BorderSide(
                color: colorScheme.primary
                    .withOpacity(0.5)), // Subtle border for secondary
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 12), // More padding
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)), // Pill shape
        textStyle: textTheme.labelLarge, // Use theme's label style
        elevation: isPrimary ? 2 : 1, // Subtle elevation difference
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return isPrimary
                  ? colorScheme.onPrimary.withOpacity(0.1)
                  : colorScheme.primary.withOpacity(0.05);
            }
            return null;
          },
        ),
      ),
    );
  }
}

// ======================================================================
// Stateful Widget for Expandable Text (No changes needed here)
// ======================================================================
class _ExpandableText extends StatefulWidget {
  final String text;
  final int maxLength;
  final TextStyle? style; // Allow passing text style

  const _ExpandableText({
    required this.text,
    this.maxLength = 100, // Default max length
    this.style,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool needsTruncation = widget.text.length > widget.maxLength;

    // Determine the text to display
    final String displayText = needsTruncation && !_isExpanded
        ? '${widget.text.substring(0, widget.maxLength)}...' // Truncated text
        : widget.text; // Full text

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the text
        Text(
          displayText,
          style: widget.style,
        ),
        // Show the button only if truncation is needed
        if (needsTruncation)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Show Less' : 'Read More',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
