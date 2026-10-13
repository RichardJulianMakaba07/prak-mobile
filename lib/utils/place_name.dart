/// Conditional export: pilih implementasi sesuai platform saat kompilasi.
///  - Android / iOS (ada dart:io) -> place_name_io.dart (pakai package geocoding)
///  - Web (Edge/Chrome)           -> place_name_stub.dart (package geocoding
///                                   tidak mendukung web, jadi mengembalikan null)
export 'place_name_stub.dart' if (dart.library.io) 'place_name_io.dart';
