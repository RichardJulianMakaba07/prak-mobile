import 'package:flutter/foundation.dart';

/// UserProvider (ChangeNotifier) menyimpan data profil user & pengaturan.
/// Nanti bisa diganti data dari login/API tanpa mengubah UI-nya.
class UserProvider extends ChangeNotifier {
  String _name = 'Richard';
  String _nim = '2409106001';
  String _email = 'richard@student.kampus.ac.id';
  String _phone = '0812-3456-7890';
  String _major = 'Informatika';
  bool _notificationOn = true;

  String get name => _name;
  String get nim => _nim;
  String get email => _email;
  String get phone => _phone;
  String get major => _major;
  bool get notificationOn => _notificationOn;

  /// Inisial untuk avatar, contoh "Richard" -> "R"
  String get initial => _name.isEmpty ? '?' : _name[0].toUpperCase();

  void updateProfile({
    required String name,
    required String nim,
    required String email,
    required String phone,
    required String major,
  }) {
    _name = name;
    _nim = nim;
    _email = email;
    _phone = phone;
    _major = major;
    notifyListeners(); // Beranda & Profil otomatis ikut berubah
  }

  void toggleNotification(bool value) {
    _notificationOn = value;
    notifyListeners();
  }
}
