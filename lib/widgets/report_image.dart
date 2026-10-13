import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Menampilkan foto laporan: pakai foto upload (bytes) jika ada,
/// kalau tidak ada pakai gambar asset sebagai cadangan.
class ReportImage extends StatelessWidget {
  final Uint8List? bytes;
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ReportImage({
    super.key,
    required this.bytes,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (bytes != null) {
      return Image.memory(bytes!,
          width: width, height: height, fit: fit, gaplessPlayback: true);
    }
    return Image.asset(assetPath, width: width, height: height, fit: fit);
  }
}
