import 'package:geocoding/geocoding.dart';

/// Versi Android/iOS: koordinat -> nama jalan / daerah.
/// Mengembalikan null jika gagal (tanpa internet, dll).
Future<String?> getPlaceName(double lat, double lng) async {
  try {
    final marks = await placemarkFromCoordinates(lat, lng);
    if (marks.isEmpty) return null;
    final m = marks.first;
    final name = <String?>[m.street, m.subLocality, m.locality]
        .where((e) => e != null && e.trim().isNotEmpty)
        .join(', ');
    return name.isEmpty ? null : name;
  } catch (_) {
    return null;
  }
}
