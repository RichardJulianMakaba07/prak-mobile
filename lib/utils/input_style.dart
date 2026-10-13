import 'package:flutter/material.dart';

/// Gaya InputDecoration yang seragam (sama dengan search bar di Beranda).
/// Dipakai di form Laporkan dan form Edit Profil agar tidak menulis ulang.
InputDecoration appInputDecoration(
  BuildContext context, {
  required String label,
  String? hint,
  IconData? icon,
}) {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: color),
      );

  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    prefixIcon: icon == null ? null : Icon(icon, color: Colors.grey.shade500),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: border(Colors.grey.shade300),
    focusedBorder: border(Theme.of(context).colorScheme.primary),
    errorBorder: border(Colors.red),
    focusedErrorBorder: border(Colors.red),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  );
}
