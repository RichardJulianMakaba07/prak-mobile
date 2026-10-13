import 'package:flutter/material.dart';

/// AppBar seragam untuk halaman Laporkan, Riwayat, dan Profil
/// (gaya diambil dari AppBar ReportPage sebelumnya).
class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const PageAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.deepOrange,
      elevation: 13,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }
}
