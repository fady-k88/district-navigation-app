import 'package:url_launcher/url_launcher.dart';

/// Service class for handling URL launching with special support for Google Drive links
class UrlLauncherService {
  /// Launches a URL with smart handling for different types of links
  ///
  /// For Google Drive links, converts them to streaming format and opens in web view
  /// For other links, opens in external application
  ///
  /// Throws [Exception] if URL cannot be launched
  static Future<void> launchURL(String url) async {
    try {
      // Parse the url first
      final Uri uri = Uri.parse(url);

      // Check if it's possible to lanuce the url.
      if (await canLaunchUrl(uri)) {
        // Launche the url.
        await launchUrl(uri);
      }
    } catch (e) {
      // Fallback to external browser if in-app web view fails
      try {
        final Uri uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (fallbackError) {
        throw Exception('Unable to launch URL: $url. Error: $fallbackError');
      }
    }
  }
}
