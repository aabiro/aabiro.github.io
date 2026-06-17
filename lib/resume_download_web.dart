import 'package:web/web.dart' as web;

Future<void> downloadResume(String assetPath, String fileName) async {
  final anchor = web.HTMLAnchorElement()
    ..href = assetPath
    ..download = fileName
    ..target = '_blank'
    ..rel = 'noopener';

  web.document.body?.appendChild(anchor);
  anchor.click();
  anchor.remove();
}
