import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest2/models/report_data.dart';
import 'package:posttest2/providers/navigation_provider.dart';
import 'package:posttest2/providers/report_provider.dart';
import 'package:posttest2/providers/user_provider.dart';
import 'package:posttest2/widgets/category_item.dart';
import 'package:posttest2/widgets/filter_chip_button.dart';
import 'package:posttest2/widgets/report_card.dart';

/// Beranda.
/// StatefulWidget TETAP dipakai, tapi hanya untuk menyimpan
/// TextEditingController search bar (butuh initState/dispose).
/// Semua state lain (filter, kategori, data) sudah dipindah ke ReportProvider.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller untuk TextField pencarian (harus di-dispose)
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan controller agar tidak terjadi memory leak
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // watch -> Beranda rebuild otomatis saat filter / data berubah
    final reports = context.watch<ReportProvider>();
    final userName = context.watch<UserProvider>().name;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Text(
                  'Campus Lost & Found',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 18, 18),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 70,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(userName),
                    const SizedBox(height: 20),
                    _buildSearchBar(context, reports),
                    const SizedBox(height: 15),
                    _buildCategories(context, reports),
                    const SizedBox(height: 40),
                    _buildStatusFilter(context, reports),
                    const SizedBox(height: 20),
                    _buildReportTitle(context, reports),
                    const SizedBox(height: 12),
                    _buildReportList(reports.visibleReports),
                    const SizedBox(height: 8),
                    _buildReportButton(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER (nama diambil dari UserProvider)
  Widget _buildHeader(String userName) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hai, $userName',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 19, 18, 18),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Temukan & laporkan barangmu di sini',
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 19, 18, 18),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            size: 22,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // SEARCH BAR (setiap ketikan dikirim ke provider)
  Widget _buildSearchBar(BuildContext context, ReportProvider reports) {
    return TextField(
      controller: searchController,
      onChanged: (value) => context.read<ReportProvider>().setSearchQuery(value),
      decoration: InputDecoration(
        hintText: 'Cari barang hilang / ditemukan...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        // Tombol hapus hanya muncul jika ada teks
        suffixIcon: reports.searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  searchController.clear();
                  context.read<ReportProvider>().setSearchQuery('');
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }

  // KATEGORI (tap untuk memilih, tap lagi untuk membatalkan)
  Widget _buildCategories(BuildContext context, ReportProvider reports) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            // null = kategori "Semua" (hanya ada di Beranda)
            children: <ReportCategory?>[null, ...ReportProvider.categories]
                .map((c) {
              final isSelected = reports.selectedCategory == c?.title;
              return GestureDetector(
                onTap: () =>
                    context.read<ReportProvider>().setCategory(c?.title),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.deepOrange : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CategoryItem(
                    title: c?.title ?? 'Semua',
                    icon: c?.icon ?? Icons.apps_rounded,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // FILTER STATUS (Semua / Hilang / Ditemukan)
  Widget _buildStatusFilter(BuildContext context, ReportProvider reports) {
    return Row(
      children: ReportProvider.statuses.map((status) {
        return FilterChipButton(
          label: status,
          isActive: reports.selectedStatus == status,
          onTap: () => context.read<ReportProvider>().setStatus(status),
        );
      }).toList(),
    );
  }

  // JUDUL LAPORAN + "Lihat Semua" (toggle showAll)
  Widget _buildReportTitle(BuildContext context, ReportProvider reports) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Laporan Terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () => context.read<ReportProvider>().toggleShowAll(),
          child: Text(
            reports.showAll ? 'Sembunyikan' : 'Lihat Semua',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  // DAFTAR LAPORAN (hasil filter, ditampilkan 2 kolom)
  Widget _buildReportList(List<ReportData> data) {
    // Jika tidak ada hasil, tampilkan pesan kosong
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                'Laporan tidak ditemukan',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    // Bagi data menjadi baris berisi 2 kartu
    final rows = <Widget>[];
    for (int i = 0; i < data.length; i += 2) {
      final first = data[i];
      final second = i + 1 < data.length ? data[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCard(first)),
              const SizedBox(width: 12),
              Expanded(
                child: second != null ? _buildCard(second) : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildCard(ReportData r) {
    return ReportCard(
      image: r.image,
      imageBytes: r.imageBytes,
      title: r.title,
      color: r.color,
      location: r.location,
      latitude: r.latitude,
      longitude: r.longitude,
      date: r.date,
      description: r.description,
      status: r.status,
    );
  }

  // TOMBOL LAPORKAN -> pindah ke tab Laporkan lewat NavigationProvider
  Widget _buildReportButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => context.read<NavigationProvider>().setIndex(1),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Laporkan Barang',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
