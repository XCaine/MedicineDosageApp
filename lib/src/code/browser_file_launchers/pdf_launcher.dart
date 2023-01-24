import 'package:url_launcher/url_launcher.dart';

class PdfLauncher {

  static launch(String pdfUrl) async {
    final uri = Uri.parse(pdfUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(enableJavaScript: false)
      );
    } else {
      throw 'Could not launch $pdfUrl';
    }
  }
}