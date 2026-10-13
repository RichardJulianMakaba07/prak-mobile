import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest2/models/report_data.dart';
import 'package:posttest2/providers/navigation_provider.dart';
import 'package:posttest2/providers/report_provider.dart';
import 'package:posttest2/widgets/filter_chip_button.dart';
import 'package:posttest2/widgets/history_tile.dart';
import 'package:posttest2/widgets/page_app_bar.dart';

/// Halaman Riwayat: daftar laporan milik user.
/// StatelessWidget -> semua state (data & filter) ada di ReportProvider.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<void> _confirmDelete(BuildContext context, ReportData r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus laporan?'),
        content: Text('Laporan "${r.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<ReportProvider>().deleteReport(r.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReportProvider>();
    final items = p.historyReports;

    return Scaffold(
      appBar: const PageAppBar(title: 'Riwayat'),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          children: [
            // RINGKASAN
            Row(
              children: [
                _SummaryBox(label: 'Total', value: p.totalMine),
                const SizedBox(width: 10),
                _SummaryBox(label: 'Aktif', value: p.activeMine),
                const SizedBox(width: 10),
                _SummaryBox(label: 'Selesai', value: p.resolvedMine),
              ],
            ),
            const SizedBox(height: 20),

            // FILTER
            Row(
              children: ReportProvider.historyFilters.map((f) {
                return FilterChipButton(
                  label: f,
                  isActive: p.historyFilter == f,
                  onTap: () => context.read<ReportProvider>().setHistoryFilter(f),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // DAFTAR / KOSONG
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.history, size: 56, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text('Belum ada laporan',
                        style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<NavigationProvider>().setIndex(1),
                      child: const Text('Buat Laporan'),
                    ),
                  ],
                ),
              )
            else
              ...items.map(
                (r) => HistoryTile(
                  report: r,
                  onResolve: () {
                    context.read<ReportProvider>().markResolved(r.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Laporan ditandai selesai')),
                    );
                  },
                  onDelete: () => _confirmDelete(context, r),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label;
  final int value;
  const _SummaryBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            Text('$value',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
