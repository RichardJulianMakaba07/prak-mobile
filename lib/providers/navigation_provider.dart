import 'package:flutter/foundation.dart';

/// ==================== STATE MANAGEMENT: PROVIDER ====================
/// Konsep yang dipakai: ChangeNotifier + ChangeNotifierProvider.
///  - ChangeNotifier : class yang menyimpan state dan punya notifyListeners().
///  - notifyListeners(): memberi tahu semua widget yang "mendengarkan"
///                       bahwa data berubah, sehingga widget dibangun ulang.
///  - context.watch<T>() : baca state + rebuild otomatis saat berubah.
///  - context.read<T>()  : akses/panggil method tanpa rebuild (untuk onPressed).
///
/// NavigationProvider menyimpan index tab bottom navigation. Dengan ini
/// halaman mana pun (mis. tombol "Laporkan Barang" di Beranda) bisa
/// berpindah tab tanpa Navigator.push.
class NavigationProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(int value) {
    if (value == _index) return;
    _index = value;
    notifyListeners();
  }
}
