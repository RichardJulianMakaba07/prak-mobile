import 'package:flutter/material.dart';
import 'home_page.dart';

// Fungsi main() adalah titik masuk (entry point) dari aplikasi Flutter
void main() {
  runApp(const MyApp());
}

// MyApp adalah root widget dari keseluruhan aplikasi Campus Lost & Found
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp -> widget wrapper utama aplikasi (Modul 2: MaterialApp)
    // Semua konfigurasi global aplikasi (judul, tema, halaman awal) diatur di sini
    return MaterialApp(
      // title, nama aplikasi (dipakai oleh OS, tidak tampil di UI)
      title: 'Campus Lost & Found',

      // debugShowCheckedModeBanner, menonaktifkan tulisan "DEBUG" di pojok kanan atas
      debugShowCheckedModeBanner: false,

      // theme, menentukan aturan visual umum aplikasi (font, warna, dll)
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        // colorScheme.fromSeed menghasilkan palet warna otomatis dari satu warna dasar
        // Dipilih warna biru navy untuk kesan akademik/kampus yang terpercaya
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),

      // home, menentukan halaman pertama yang ditampilkan ketika aplikasi dibuka
      home: const HomePage(),
    );
  }
}