import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Helper function to launch URLs safely
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Log or show an error message if the URL can't be launched
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Define consistent horizontal padding based on screen size (basic responsiveness)
    final horizontalPadding = screenSize.width > 800 ? 80.0 : 30.0;
    const String profileImagePath = 'assets/headshot.JPG';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- 1. Hero/Header Section ---
            Container(
              height: screenSize.height * 0.6, // Slightly taller header
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 40.0),
              // Apply a gradient background
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary, // Teal
                    colorScheme
                        .secondary, // Default secondary, adjust if needed
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        Colors.white.withOpacity(0.8), // Fallback background
                    // Use backgroundImage for the asset image
                    backgroundImage: profileImagePath != null
                        ? AssetImage(profileImagePath) // Load image from assets
                        : null, // Set to null if no image path is provided
                    // Use child for the placeholder icon ONLY if backgroundImage is null
                    child: profileImagePath == null
                        ? Icon(Icons.person,
                            size: 60, color: colorScheme.primary)
                        : null, // Don't show icon if image is present
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Aaryn Biro',
                    style:
                        textTheme.displayLarge?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Software Developer / Flutter Developer | Web Enthusiast',
                    style: textTheme.titleLarge
                        ?.copyWith(color: Colors.white.withOpacity(0.9)),
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
                style: textTheme.bodyLarge,
              ),
              backgroundColor: colorScheme.surface, // Use theme surface color
              horizontalPadding: horizontalPadding,
            ),

            // --- 3. Projects Section ---
            _buildSection(
              context: context,
              title: 'Projects',
              child: _buildProjectsGrid(
                  context), // Use a helper for project layout
              backgroundColor: colorScheme.surfaceContainerHighest
                  .withOpacity(0.3), // Slightly different background
              horizontalPadding: horizontalPadding,
            ),

            // --- 4. Skills Section ---
            _buildSection(
              context: context,
              title: 'Skills',
              child: const Wrap(
                spacing: 12.0, // Increased spacing
                runSpacing: 12.0,
                children: <Widget>[
                  //Mobile development (Flutter), Full Stack web development (Node.js, Mongo, Express, Angular, React), AWS, SQL, HTML, CSS, JavaScript, AJAX, Git, Docker, CI/CD, TDD, BDD, Building RESTful API's
                  // Use the themed Chip
                  Chip(label: Text('Mobile development (Flutter)')),
                  Chip(label: Text('Full Stack web development')),
                  Chip(label: Text('Node.js')),
                  Chip(label: Text('Mongo')),
                  Chip(label: Text('React')),
                  Chip(label: Text('Ruby on Rails')),
                  Chip(label: Text('JavaScript')),
                  Chip(label: Text('HTML')),
                  Chip(label: Text('CSS')),
                  Chip(label: Text('AWS')),
                  Chip(label: Text('SQL')),
                  Chip(label: Text('Docker')),
                  Chip(label: Text('Firebase')),
                  Chip(label: Text('Git')),
                  Chip(label: Text('REST APIs')),
                  Chip(label: Text('UI/UX (Basics)')),
                  Chip(label: Text('Responsive Design')),
                  Chip(label: Text('CI/CD')),
                  Chip(label: Text('TDD')),
                  Chip(label: Text('BDD')),
                  Chip(label: Text('Ruby')),
                  Chip(label: Text('Dart')),
                  // Add more skills
                ],
              ),
              backgroundColor: colorScheme.surface,
              horizontalPadding: horizontalPadding,
            ),

            // --- 5. Contact Section ---
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 60.0),
              color:
                  colorScheme.primaryContainer, // Use primary container color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Get In Touch',
                    style: textTheme.headlineMedium
                        ?.copyWith(color: colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "I'm currently open to new opportunities and collaborations. Feel free to reach out via email or connect with me on LinkedIn!",
                    style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.8)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // Contact Buttons with Icons and Hover Effect
                  Wrap(
                    // Use Wrap for better responsiveness of buttons
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.email),
                        label: const Text('Email'),
                        onPressed: () => _launchEmail(
                            'aaryn.alexander@gmail.com',
                            subject: 'Website Contact'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: colorScheme.onPrimary,
                          backgroundColor: colorScheme.primary,
                        ).copyWith(
                          // Basic hover effect for web
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered)) {
                                return colorScheme.onPrimary.withOpacity(0.1);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons
                            .link), // Replace with a LinkedIn specific icon if you add an icon font
                        label: const Text('LinkedIn'),
                        onPressed: () =>
                            _launchURL('https://www.linkedin.com/in/aabiro/'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: colorScheme.primary, // Text color
                          backgroundColor:
                              colorScheme.surface, // Background color
                          side:
                              BorderSide(color: colorScheme.primary), // Border
                        ).copyWith(
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered)) {
                                return colorScheme.primary.withOpacity(0.1);
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(
                            Icons.code), // Replace with a GitHub specific icon
                        label: const Text('GitHub'),
                        onPressed: () =>
                            _launchURL('https://github.com/aabiro'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          backgroundColor: colorScheme.surface,
                          side: BorderSide(color: colorScheme.primary),
                        ).copyWith(
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.hovered)) {
                                return colorScheme.primary.withOpacity(0.1);
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      // Add more buttons (Twitter, Portfolio, etc.)
                    ],
                  ),
                ],
              ),
            ),

            // --- 6. Footer ---
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 25.0, horizontal: horizontalPadding),
              color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
              alignment: Alignment.center,
              child: Text(
                '© ${DateTime.now().year} Aaryn Biro. Built with Flutter.',
                style: textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 50.0),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.headlineMedium
                ?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 30), // Increased spacing after title
          child,
        ],
      ),
    );
  }

  // Helper widget to build the projects grid/list
  Widget _buildProjectsGrid(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;

    final projects = [
      {
        'title': 'GivnGo',
        'description':
            'Developed a peer-to-peer bicycle rental mobile app (iOS/Android) using Flutter/Dart. The platform allows users to easily find and rent bikes for city transport or lend their own for extra income.',
        'imageUrl':
            'https://raw.githubusercontent.com/aabiro/crypto_bank_mobile/refs/heads/master/assets/gnglogo.png', // Placeholder
        'githubUrl': 'https://github.com/aabiro/crypto_bank_mobile',
        'liveUrl': null, // Optional live demo URL
      },
      {
        'title': 'Flutter Countdown Timer',
        'description':
            'Developed a responsive countdown timer using Flutter, demonstrating cross-platform capabilities for seamless use on mobile devices and the web.',
        'imageUrl': 'https://i.imgur.com/z68LtyT.png',
        'githubUrl':
            'https://github.com/aabiro/flutter_countdown_timer?tab=readme-ov-file#countdown_pal_app',
        'liveUrl': 'https://your-dashboard-live-url.com',
      },
      {
        'title': 'Recipe Finder Application',
        'description':
            'A checklist of ingredients to render recipes that are associated with all selected ingredients.',
        'imageUrl': 'https://i.imgur.com/1nC5IA0.jpeg',
        'githubUrl':
            'https://github.com/aabiro/react_rails_recipe_app?tab=readme-ov-file#recipe-finder-application',
        'liveUrl': null,
      },
    ];

    // Determine number of columns based on screen width (simple responsiveness)
    int crossAxisCount =
        screenSize.width > 1200 ? 3 : (screenSize.width > 800 ? 2 : 1);

    return GridView.builder(
      shrinkWrap: true, // Important inside SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.8, // Adjust aspect ratio (width/height) as needed
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          clipBehavior: Clip.antiAlias, // Ensures image corners are clipped
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Image (Use AspectRatio for consistent height)
              AspectRatio(
                aspectRatio: 16 / 9, // Common image aspect ratio
                child: Image.network(
                  project['imageUrl']!,
                  fit: BoxFit.cover,
                  // Add error builder for placeholder if image fails
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: Icon(Icons.image_not_supported,
                          color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              // Project Details
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['title']!,
                      style: textTheme.titleLarge?.copyWith(
                          fontSize: 18), // Slightly smaller title for card
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project['description']!,
                      style: textTheme.bodyMedium,
                      maxLines: 3, // Limit description lines
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 15),
                    // Action Buttons (GitHub, Live Demo)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (project['githubUrl'] != null)
                          TextButton.icon(
                            icon: const Icon(Icons.code, size: 18),
                            label: const Text('GitHub'),
                            onPressed: () => _launchURL(project['githubUrl']!),
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
                          ),
                        if (project['liveUrl'] != null)
                          TextButton.icon(
                            icon: const Icon(Icons.open_in_new, size: 18),
                            label: const Text('Live Demo'),
                            onPressed: () => _launchURL(project['liveUrl']!),
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
