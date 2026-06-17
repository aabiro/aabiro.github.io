import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> downloadResume(String assetPath, String fileName) async {
  final uri = Uri.parse(assetPath);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('Could not open resume at $assetPath');
  }
}
