import 'package:flutter/material.dart';
import 'package:posttest2/models/report_data.dart';
import 'package:posttest2/utils/map_launcher.dart';
import 'package:posttest2/widgets/report_image.dart';

/// Kartu satu baris untuk daftar Riwayat.
/// Aksi (selesai / hapus) dikirim lewat callback supaya widget ini
/// tetap StatelessWidget dan tidak tahu apa-apa soal provider.
class HistoryTile extends StatelessWidget {
  final ReportData report;
  final VoidCallback onResolve;
  final VoidCallback onDelete;

  const HistoryTile({
    super.key,
    required this.report,
    required this.onResolve,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isFound = report.status == 'Ditemukan';
    final badgeColor = isFound ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ReportImage(
              bytes: report.imageBytes,
              assetPath: report.image,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _Badge(text: report.status, color: badgeColor),
                    const SizedBox(width: 6),
                    report.isResolved
                        ? const _Badge(text: 'Selesai', color: Colors.blueGrey)
                        : const _Badge(text: 'Aktif', color: Colors.deepOrange),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 13, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        report.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ),
                    if (report.hasCoordinates)
                      GestureDetector(
                        onTap: () => openInMaps(
                            context, report.latitude!, report.longitude!),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.map_outlined,
                              size: 16, color: Colors.deepOrange),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      report.date,
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Menu titik tiga: tandai selesai / hapus
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'resolve') onResolve();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              if (!report.isResolved)
                PopupMenuItem(
                  value: 'resolve',
                  child: Text(isFound
                      ? 'Sudah dikembalikan ke pemilik'
                      : 'Barang sudah ketemu'),
                ),
              const PopupMenuItem(value: 'delete', child: Text('Hapus laporan')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
