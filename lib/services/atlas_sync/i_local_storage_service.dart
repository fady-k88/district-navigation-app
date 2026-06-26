abstract class ILocalStorageService {
  Future<String?> readHash();
  Future<void> writeHash(String hash);
  Future<String?> readKml();
  Future<void> writeKml(String kml);
}
