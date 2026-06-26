// hash_comparison_service.dart
import 'package:district_navigation_app/services/atlas_sync/i_hash_comparison_service.dart';

class HashComparisonService implements IHashComparisonService {
  @override
  bool hasChanged(String remoteHash, String? localHash) {
    // if local hash doesn't exist then return true, otherwise compare both.
    if (localHash == null) return true;
    return remoteHash.trim() != localHash.trim();
  }
}
