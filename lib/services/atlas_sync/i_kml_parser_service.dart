import 'package:district_navigation_app/models/building.dart';

abstract class IKmlParserService {
  List<Building> parse(String kmlContent);
}
