import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest2/history_page.dart';
import 'package:posttest2/home_page.dart';
import 'package:posttest2/profile_page.dart';
import 'package:posttest2/providers/navigation_provider.dart';
import 'package:posttest2/report_page.dart';

/// Kerangka utama aplikasi: menampung 4 tab + bottom navigation.
/// StatelessWidget karena index tab disimpan di NavigationProvider,
/// bukan di State milik widget ini.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  // Urutan harus sama dengan urutan destinations di NavigationBar
  static const List<Widget> _pages = [
    HomePage(),
    ReportPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // watch -> MainPage dibangun ulang saat index berubah
    final nav = context.watch<NavigationProvider>();

    return Scaffold(
      // IndexedStack menjaga state tiap halaman (isi form, scroll, filter)
      // tetap tersimpan saat berpindah tab.
      body: IndexedStack(index: nav.index, children: _pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.deepOrange,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: NavigationBar(
            selectedIndex: nav.index,
            backgroundColor: Colors.transparent,
            elevation: 0,
            // read -> hanya memanggil method, tidak perlu rebuild
            onDestinationSelected: (i) =>
                context.read<NavigationProvider>().setIndex(i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.add_circle_outline),
                selectedIcon: Icon(Icons.add_circle),
                label: 'Laporkan',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history),
                label: 'Riwayat',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
