import 'package:http/http.dart' as http;
import 'package:district_navigation_app/services/atlas_sync/i_remote_hash_service.dart';

class RemoteHashService implements IRemoteHashService {
  static const String _hashUrl =
      'https://drive.google.com/uc?export=download&id=19h4hLsV3vq2qmRHkgEe8tZDBNHCJ8k38';

  @override
  Future<String> fetchRemoteHash() async {
    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(_hashUrl))
        ..followRedirects = true
        ..maxRedirects = 5
        ..headers['Accept'] = '*/*';

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.body.trim();
      }

      throw Exception('Failed to fetch hash: ${response.statusCode}');
    } finally {
      client.close();
    }
  }
}
