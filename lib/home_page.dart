import 'package:flutter/material.dart';
import 'package:posttest2/widgets/category_item.dart';
import 'package:posttest2/widgets/report_card.dart';
import 'package:posttest2/report_page.dart';

/// Model sederhana untuk data laporan.
/// Dipakai agar data bisa difilter berdasarkan kategori, status, dan kata kunci.
class ReportData {
  final String image;
  final String title;
  final String category;
  final String color;
  final String location;
  final String date;
  final String description;
  final String status; // 'Hilang' atau 'Ditemukan'

  const ReportData({
    required this.image,
    required this.title,
    required this.category,
    required this.color,
    required this.location,
    required this.date,
    required this.description,
    required this.status,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ===================== STATE =====================

  // Index menu bottom navigation yang sedang aktif
  int selectedIndex = 0;

  // Kategori yang dipilih (null = semua kategori)
  String? selectedCategory;

  // Filter status: 'Semua', 'Hilang', atau 'Ditemukan'
  String selectedStatus = 'Semua';

  // Kata kunci pencarian
  String searchQuery = '';

  // Menampilkan semua laporan atau hanya 4 teratas ("Lihat Semua")
  bool showAll = false;

  // Controller untuk TextField pencarian (harus di-dispose)
  final TextEditingController searchController = TextEditingController();

  // Data dummy laporan (nanti bisa diganti data dari database/API)
  final List<ReportData> reports = const [
    ReportData(
      image: 'assets/gambar.png',
      title: 'Dompet Kulit Hitam',
      category: 'Dompet',
      color: 'Hitam',
      location: 'Gedung F',
      date: '22 Sep 2026',
      description: 'Dompet hitam, ada logo Adidas di bagian depan',
      status: 'Hilang',
    ),
    ReportData(
      image: 'assets/gambar.png',
      title: 'Tas Ransel Hitam',
      category: 'Tas',
      color: 'Hitam',
      location: 'Perpustakaan',
      date: '22 Sep 2026',
      description: 'Tas ransel hitam merk Eiger, ada laptop di dalamnya',
      status: 'Ditemukan',
    ),
    ReportData(
      image: 'assets/gambar.png',
      title: 'Kunci Motor Honda',
      category: 'Kunci',
      color: 'Hitam',
      location: 'Parkiran Barat',
      date: '21 Sep 2026',
      description: 'Kunci motor Honda dengan gantungan kunci biru',
      status: 'Ditemukan',
    ),
    ReportData(
      image: 'assets/gambar.png',
      title: 'iPhone 13',
      category: 'HP',
      color: 'Putih',
      location: 'Kantin Pusat',
      date: '20 Sep 2026',
      description: 'HP putih, casing bening, wallpaper pantai',
      status: 'Hilang',
    ),
    ReportData(
      image: 'assets/gambar.png',
      title: 'Jaket Almamater',
      category: 'Jaket',
      color: 'Biru',
      location: 'Gedung A',
      date: '19 Sep 2026',
      description: 'Jaket almamater biru dongker ukuran L',
      status: 'Hilang',
    ),
    ReportData(
      image: 'assets/gambar.png',
      title: 'Laptop ASUS',
      category: 'Laptop',
      color: 'Abu-abu',
      location: 'Lab Komputer',
      date: '18 Sep 2026',
      description: 'Laptop ASUS abu-abu, ada stiker kucing di cover',
      status: 'Ditemukan',
    ),
  ];

  // Daftar kategori (judul + ikon) agar bisa dibuat dengan perulangan
  final List<Map<String, dynamic>> categories = const [
    {'title': 'Dompet', 'icon': Icons.account_balance_wallet_outlined},
    {'title': 'HP', 'icon': Icons.smartphone_outlined},
    {'title': 'Laptop', 'icon': Icons.laptop_mac_outlined},
    {'title': 'Kunci', 'icon': Icons.vpn_key_outlined},
    {'title': 'Tas', 'icon': Icons.backpack_outlined},
    {'title': 'Jaket', 'icon': Icons.checkroom_outlined},
  ];

  final List<String> statuses = const ['Semua', 'Hilang', 'Ditemukan'];

  // ===================== LOGIC =====================

  /// Daftar laporan setelah difilter oleh kategori, status, dan pencarian.
  /// Dihitung ulang setiap build, sehingga otomatis ikut berubah ketika
  /// state di atas diubah lewat setState().
  List<ReportData> get filteredReports {
    final result = reports.where((r) {
      final matchCategory =
          selectedCategory == null || r.category == selectedCategory;
      final matchStatus =
          selectedStatus == 'Semua' || r.status == selectedStatus;
      final query = searchQuery.toLowerCase();
      final matchSearch = query.isEmpty ||
          r.title.toLowerCase().contains(query) ||
          r.description.toLowerCase().contains(query) ||
          r.location.toLowerCase().contains(query);
      return matchCategory && matchStatus && matchSearch;
    }).toList();

    // Jika "Lihat Semua" belum ditekan, tampilkan maksimal 4 laporan
    if (!showAll && result.length > 4) {
      return result.sublist(0, 4);
    }
    return result;
  }

  @override
  void dispose() {
    // Membersihkan controller agar tidak terjadi memory leak
    searchController.dispose();
    super.dispose();
  }

  // ===================== UI =====================

  @override
  Widget build(BuildContext context) {
    final data = filteredReports;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: const Text(
                  'Campus Lost & Found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 18, 18),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 55, left: 20, right: 20),
                height: 285,
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
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildSearchBar(context),
                    const SizedBox(height: 15),
                    _buildCategories(),
                    const SizedBox(height: 40),
                    _buildStatusFilter(),
                    const SizedBox(height: 20),
                    _buildReportTitle(context),
                    const SizedBox(height: 12),
                    _buildReportList(data),
                    const SizedBox(height: 8),
                    _buildReportButton(),
                    const SizedBox(height: 90), // ruang untuk bottom nav
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hai, Richard',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 19, 18, 18),
                ),
              ),
              SizedBox(height: 6),
              Text(
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

  // SEARCH BAR (stateful: setiap ketikan memperbarui searchQuery)
  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Cari barang hilang / ditemukan...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        // Tombol hapus hanya muncul jika ada teks
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    searchQuery = '';
                  });
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
  Widget _buildCategories() {
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
            children: categories.map((c) {
              final isSelected = selectedCategory == c['title'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle: jika sudah dipilih, kembali ke semua kategori
                    selectedCategory = isSelected ? null : c['title'];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.deepOrange : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CategoryItem(
                    title: c['title'],
                    icon: c['icon'],
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
  Widget _buildStatusFilter() {
    return Row(
      children: statuses.map((status) {
        final isActive = selectedStatus == status;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedStatus = status;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? Colors.deepOrange : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isActive
                    ? null
                    : Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black87,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // JUDUL LAPORAN + "Lihat Semua" (toggle showAll)
  Widget _buildReportTitle(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Laporan Terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              showAll = !showAll;
            });
          },
          child: Text(
            showAll ? 'Sembunyikan' : 'Lihat Semua',
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
      title: r.title,
      color: r.color,
      location: r.location,
      date: r.date,
      description: r.description,
      status: r.status,
    );
  }

  // TOMBOL LAPORKAN
  Widget _buildReportButton() {
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportPage()),
          );
        },
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

  // BOTTOM NAVIGATION
  Widget _buildBottomNav() {
    return Container(
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
          selectedIndex: selectedIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onDestinationSelected: (index) {
            if (index == 1) {
              // "Laporkan" membuka halaman baru, jadi index aktif tidak diubah
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportPage()),
              );
            } else {
              setState(() {
                selectedIndex = index;
              });
            }
          },
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
    );
  }
}