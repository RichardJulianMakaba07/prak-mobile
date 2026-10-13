import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:posttest2/utils/map_launcher.dart';
import 'package:posttest2/widgets/report_image.dart';

class ReportCard extends StatelessWidget {
  final String image;
  final Uint8List? imageBytes; // foto upload (opsional)
  final String title;
  final String color;
  final String location;
  final double? latitude; // koordinat GPS (opsional)
  final double? longitude;
  final String date;
  final String description;
  final String status;

  const ReportCard({
    super.key,
    required this.image,
    this.imageBytes,
    required this.title,
    required this.color,
    required this.location,
    this.latitude,
    this.longitude,
    required this.date,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final hasCoords = latitude != null && longitude != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Gambar & Badge
          Stack(
            children: [
              ReportImage(
                bytes: imageBytes,
                assetPath: image,
                width: double.infinity,
                height: 140,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'Ditemukan' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. Area Detail
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),

                // Warna + Lokasi
                Row(
                  children: [
                    Icon(Icons.palette_outlined,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(color,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600)),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on_outlined,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tanggal + tombol peta (jika ada koordinat)
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 13, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        date,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ),
                    if (hasCoords)
                      GestureDetector(
                        onTap: () => openInMaps(context, latitude!, longitude!),
                        child: const Row(
                          children: [
                            Icon(Icons.map_outlined,
                                size: 14, color: Colors.deepOrange),
                            SizedBox(width: 2),
                            Text(
                              'Peta',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
