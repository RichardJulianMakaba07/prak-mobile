import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Model data laporan.
class ReportData {
  final String id;

  /// Path asset cadangan, dipakai jika laporan tidak punya foto upload (data dummy).
  final String image;

  /// Foto yang diambil dari kamera / galeri (disimpan sebagai bytes di memori).
  final Uint8List? imageBytes;

  final String title;
  final String category;
  final String color;
  final String location;

  /// Koordinat GPS (opsional) dari tombol "Gunakan lokasi saya".
  final double? latitude;
  final double? longitude;

  final String date;
  final String description;
  final String status; // 'Hilang' atau 'Ditemukan'

  /// true jika laporan ini dibuat oleh user yang sedang login (tampil di Riwayat)
  final bool isOwn;

  /// true jika kasus sudah selesai (barang sudah ketemu / dikembalikan)
  final bool isResolved;

  const ReportData({
    required this.id,
    required this.image,
    this.imageBytes,
    required this.title,
    required this.category,
    required this.color,
    required this.location,
    this.latitude,
    this.longitude,
    required this.date,
    required this.description,
    required this.status,
    this.isOwn = false,
    this.isResolved = false,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  /// Model immutable: perubahan = membuat objek baru.
  ReportData copyWith({bool? isResolved}) {
    return ReportData(
      id: id,
      image: image,
      imageBytes: imageBytes,
      title: title,
      category: category,
      color: color,
      location: location,
      latitude: latitude,
      longitude: longitude,
      date: date,
      description: description,
      status: status,
      isOwn: isOwn,
      isResolved: isResolved ?? this.isResolved,
    );
  }
}

/// Model kategori (judul + ikon), dipakai di Beranda dan form Laporkan.
class ReportCategory {
  final String title;
  final IconData icon;
  const ReportCategory(this.title, this.icon);
}
