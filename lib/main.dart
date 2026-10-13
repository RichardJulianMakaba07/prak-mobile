import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';
import 'providers/navigation_provider.dart';
import 'providers/report_provider.dart';
import 'providers/user_provider.dart';

// Fungsi main() adalah titik masuk (entry point) dari aplikasi Flutter
void main() {
  runApp(
    // MultiProvider mendaftarkan beberapa ChangeNotifier sekaligus di atas
    // MaterialApp, sehingga semua halaman bisa mengakses state yang sama.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// MyApp adalah root widget dari keseluruhan aplikasi Campus Lost & Found
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp -> widget wrapper utama aplikasi
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),

      // home, halaman pertama = MainPage (kerangka dengan bottom navigation)
      home: const MainPage(),
    );
  }
}
