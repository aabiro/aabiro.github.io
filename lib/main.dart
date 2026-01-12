import 'package:aabiro_github_io/home_page.dart';
import 'package:flutter/material.dart';
import 'package:github_pages/github_pages.dart' as ghpages;
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7BD6F6),
      brightness: Brightness.dark,
      surface: const Color(0xFF0A0F1A),
      background: const Color(0xFF05060B),
    );

    return MaterialApp(
      title: 'Aaryn Biro - Personal Website',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.background,
        textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        cardColor: colorScheme.surface,
        chipTheme: ChipThemeData(
          backgroundColor: colorScheme.secondaryContainer.withOpacity(0.2),
          labelStyle: TextStyle(
            color: colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
