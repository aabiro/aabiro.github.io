import 'package:aabiro_github_io/home_page.dart';
import 'package:flutter/material.dart';
import 'package:github_pages/github_pages.dart' as ghpages;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  ghpages.publish('build/web', {});
  WidgetsFlutterBinding.ensureInitialized();

  // 5. Initialize Firebase **HERE**
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aaryn Biro - Personal Website',
      theme: ThemeData(
        useMaterial3: true,
        // Define a more distinct color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // Choose a base color
          brightness: Brightness.light,
        ),
        // Define text theme for consistent typography
        textTheme: const TextTheme(
          // Use slightly more modern/clean font styles if available
          // Consider adding a Google Font via pubspec.yaml and specifying here
          displayLarge: TextStyle(
              fontSize: 60.0, fontWeight: FontWeight.bold, letterSpacing: -1.5),
          headlineMedium:
              TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(
              fontSize: 22.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500),
          bodyLarge:
              TextStyle(fontSize: 16.0, height: 1.5), // Increased line height
          bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
          labelLarge: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold), // For buttons
        ),
        // Style ElevatedButtons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8), // Slightly rounded corners
            ),
          ),
        ),
        // Style Chips
        chipTheme: ChipThemeData(
          backgroundColor: Colors.teal.withOpacity(0.1),
          labelStyle:
              TextStyle(color: Colors.teal[800], fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // More rounded chips
            side: BorderSide(color: Colors.teal.withOpacity(0.3)),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
