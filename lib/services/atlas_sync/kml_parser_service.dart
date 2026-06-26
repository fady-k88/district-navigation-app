// kml_parser_service.dart
import 'package:xml/xml.dart';
import 'package:district_navigation_app/models/building.dart';
import 'package:district_navigation_app/services/atlas_sync/i_kml_parser_service.dart';

class KmlParserService implements IKmlParserService {
  @override
  List<Building> parse(String kmlContent) {
    final document = XmlDocument.parse(kmlContent);
    final buildings = <Building>[];

    for (final folder in document.findAllElements('Folder')) {
      final project =
          folder.findElements('name').firstOrNull?.innerText.trim() ?? '';
      print(project);
      for (final placemark in folder.findAllElements('Placemark')) {
        final id = placemark.getAttribute('id');
        final name = placemark
            .findElements('name')
            .firstOrNull
            ?.innerText
            .trim();
        final coordsText = placemark
            .findAllElements('coordinates')
            .firstOrNull
            ?.innerText
            .trim();

        // skip unnamed or non-numeric placemarks
        if (name == null || int.tryParse(name) == null) continue;
        if (coordsText == null) continue;

        final parts = coordsText.split(',');
        if (parts.length < 2) continue;

        final lon = double.tryParse(parts[0].trim());
        final lat = double.tryParse(parts[1].trim());
        if (lon == null || lat == null) continue;

        buildings.add(
          Building(
            id: id ?? name,
            number: name,
            project: project,
            latitude: lat,
            longitude: lon,
          ),
        );
      }
    }

    return buildings;
  }
}
