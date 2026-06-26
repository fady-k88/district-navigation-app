import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:district_navigation_app/services/atlas_sync/i_remote_kml_service.dart';

class RemoteKmlService implements IRemoteKmlService {
  static const String _kmlUrl =
      'https://drive.google.com/uc?export=download&id=1Yw5vPEbBtlp8mJJBzFzCm3y_LPFGlHaI';

  @override
  Future<String> fetchKmlContent() async {
    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(_kmlUrl))
        ..followRedirects = true
        ..maxRedirects = 5
        ..headers['Accept'] = '*/*';

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return utf8.decode(response.bodyBytes);
      }

      throw Exception('Failed to fetch hash: ${response.statusCode}');
    } finally {
      client.close();
    }
  }
}
