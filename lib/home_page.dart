import 'package:flutter/material.dart';

// Enum untuk merepresentasikan status sebuah laporan: barang hilang atau barang yang berhasil ditemukan oleh pelapor
enum ReportStatus { hilang, ditemukan }

// Model data sederhana untuk satu laporan barang hilang/ditemukan
class LostFoundReport {
  final String name; // nama barang, contoh: "Dompet Kulit Hitam"
  final String category; // kategori barang, contoh: "Aksesori"
  final String color; // warna barang, contoh: "Hitam"
  final String location; // lokasi hilang/ditemukan, contoh: "Gedung F"
  final String date; // tanggal laporan dibuat
  final String description; // deskripsi singkat barang
  final ReportStatus status; // status: hilang atau ditemukan
  final IconData icon; // ikon representasi kategori barang

  const LostFoundReport({
    required this.name,
    required this.category,
    required this.color,
    required this.location,
    required this.date,
    required this.description,
    required this.status,
    required this.icon,
  });
}

// HomePage bersifat Stateful karena ada interaksi: mengetik di kolom pencarian, memilih kategori, dan memilih filter status laporan
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller untuk membaca teks yang diketik pengguna pada TextField pencarian
  final TextEditingController _searchController = TextEditingController();

  String _searchKeyword = ''; // kata kunci pencarian saat ini
  int _selectedNavIndex = 0; // index menu yang sedang aktif di bottom navigation
  String _selectedStatusFilter = 'Semua'; // filter status: Semua/Hilang/Ditemukan
  String? _selectedCategory; // kategori quick-access yang sedang dipilih (bisa null)

  // Dummy data laporan barang hilang & ditemukan di lingkungan kampus.
  final List<LostFoundReport> _reports = [
    const LostFoundReport(
      name: 'Dompet Kulit Hitam',
      category: 'Aksesori',
      color: 'Hitam',
      location: 'Gedung F',
      date: '22 Sep 2026',
      description: 'Dompet hitam, ada logo Adidas di bagian depan',
      status: ReportStatus.hilang,
      icon: Icons.account_balance_wallet_outlined,
    ),
    const LostFoundReport(
      name: 'Tas Ransel Hitam',
      category: 'Tas',
      color: 'Hitam',
      location: 'Perpustakaan',
      date: '22 Sep 2026',
      description: 'Tas ransel hitam merk Eiger, ada laptop di dalamnya',
      status: ReportStatus.ditemukan,
      icon: Icons.backpack_outlined,
    ),
    const LostFoundReport(
      name: 'Kunci Motor + Gantungan',
      category: 'Kunci',
      color: 'Silver',
      location: 'Gedung A',
      date: '21 Sep 2026',
      description: 'Kunci motor Honda dengan gantungan boneka kecil',
      status: ReportStatus.hilang,
      icon: Icons.vpn_key_outlined,
    ),
    const LostFoundReport(
      name: 'Earphone Sebelah Putih',
      category: 'Elektronik',
      color: 'Putih',
      location: 'Gedung B',
      date: '20 Sep 2026',
      description: 'Earphone TWS warna putih, ditemukan di ruang kelas',
      status: ReportStatus.ditemukan,
      icon: Icons.headphones_outlined,
    ),
    const LostFoundReport(
      name: 'Kartu Mahasiswa',
      category: 'Dokumen',
      color: 'Biru',
      location: 'Kantin FKTI',
      date: '19 Sep 2026',
      description: 'KTM atas nama mahasiswa Informatika angkatan 2023',
      status: ReportStatus.hilang,
      icon: Icons.badge_outlined,
    ),
    const LostFoundReport(
      name: 'Jaket Almamater',
      category: 'Pakaian',
      color: 'Kuning',
      location: 'Gedung F',
      date: '22 Sep 2026',
      description: 'Jaket almamater ukuran L, tertinggal di ruang kelas',
      status: ReportStatus.ditemukan,
      icon: Icons.checkroom_outlined,
    ),
    const LostFoundReport(
      name: 'Botol Minum Tumbler',
      category: 'Lainnya',
      color: 'Hijau',
      location: 'Lapangan Rektorat',
      date: '18 Sep 2026',
      description: 'Tumbler hijau merk Tupperware, ada stiker anime',
      status: ReportStatus.hilang,
      icon: Icons.local_drink_outlined,
    ),
  ];

  // Daftar kategori cepat (quick access) yang ditampilkan di bawah kolom pencarian
  final List<Map<String, dynamic>> _categories = const [
    {'label': 'Dompet', 'icon': Icons.account_balance_wallet_outlined},
    {'label': 'HP', 'icon': Icons.smartphone_outlined},
    {'label': 'Laptop', 'icon': Icons.laptop_mac_outlined},
    {'label': 'Kunci', 'icon': Icons.vpn_key_outlined},
    {'label': 'Tas', 'icon': Icons.backpack_outlined},
    {'label': 'Jaket', 'icon': Icons.checkroom_outlined},
  ];

  // Getter yang menghasilkan daftar laporan setelah difilter berdasarkan
  // kata kunci pencarian, filter status, dan kategori yang dipilih.
  List<LostFoundReport> get _filteredReports {
    return _reports.where((report) {
      final keyword = _searchKeyword.toLowerCase();
      final matchKeyword = keyword.isEmpty ||
          report.name.toLowerCase().contains(keyword) ||
          report.location.toLowerCase().contains(keyword) ||
          report.category.toLowerCase().contains(keyword);

      final matchStatus = _selectedStatusFilter == 'Semua' ||
          (_selectedStatusFilter == 'Hilang' &&
              report.status == ReportStatus.hilang) ||
          (_selectedStatusFilter == 'Ditemukan' &&
              report.status == ReportStatus.ditemukan);

      final matchCategory = _selectedCategory == null ||
          report.name.toLowerCase().contains(_selectedCategory!.toLowerCase());

      return matchKeyword && matchStatus && matchCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold -> struktur dasar halaman aplikasi mobile
    return Scaffold(
      // backgroundColor, mengikuti warna tema aplikasi
      backgroundColor: const Color(0xFFF5F6FA),

      // body, berisi seluruh konten halaman utama 
      body: SafeArea(
        // SafeArea -> memastikan konten tidak tertutup area yang tertutup perangkat, seperti notch atau status bar
        child: SingleChildScrollView(
          // SingleChildScrollView -> agar seluruh isi halaman dapat di-scroll vertikal ketika kontennya lebih panjang dari layar
          child: Padding(
            // Padding -> memberi jarak antara konten dengan tepi layar
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              // Column -> menyusun setiap section halaman secara vertikal
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20), // SizedBox: jarak vertikal antar section
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildCategoryQuickAccess(),
                const SizedBox(height: 20),
                _buildStatusFilterChips(),
                const SizedBox(height: 16),
                _buildSectionTitle(),
                const SizedBox(height: 12),
                _buildReportList(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),

      // bottomNavigationBar, widget di bawah yang berfungsi sebagai navigasi utama
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ---------------------------------------------
  // Header: sapaan pengguna + tombol notifikasi
  // ---------------------------------------------
  Widget _buildHeader() {
    return Row(
      // Row -> menyusun sapaan (kiri) dan ikon notifikasi (kanan)
      // secara horizontal dalam satu baris
      children: [
        Expanded(
          // Expanded -> memaksa kolom sapaan mengisi sisa ruang yang tersedia, sehingga ikon notifikasi terdorong ke kanan
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // Text -> menampilkan nama aplikasi
                'Campus Lost & Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4), // SizedBox: jarak antara judul dan subjudul
              Text(
                'Temukan & laporkan barangmu di sini',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Container(
          // Container -> membungkus ikon notifikasi, mengatur padding, warna latar, dan bentuk lingkaran (BoxDecoration)
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(
            // Icon -> ikon lonceng notifikasi
            Icons.notifications_none_rounded,
            size: 22,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // -------------------------------------------
  // Kolom pencarian barang hilang / ditemukan
  // -------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      // Container -> membungkus TextField agar punya latar putih, sudut membulat (borderRadius), dan garis tepi (border)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        // TextField -> widget input teks untuk mencari laporan
        controller: _searchController,
        onChanged: (value) => setState(() => _searchKeyword = value),
        decoration: InputDecoration(
          // hintText, menampilkan placeholder sebelum pengguna mengetik
          hintText: 'Cari barang hilang / ditemukan...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          // suffixIcon, menampilkan ikon di ujung kanan TextField
          suffixIcon: Padding(
            // Padding -> memberi jarak antara ikon dan tepi kanan TextField
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              // Icon -> ikon kaca pembesar penanda kolom pencarian
              Icons.search,
              size: 22,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Akses cepat kategori barang (Dompet, HP, Laptop, dst) bisa digeser
  // ---------------------------------------------------------------------
  Widget _buildCategoryQuickAccess() {
    return SizedBox(
      // SizedBox -> membatasi tinggi area kategori agar layout rapi
      height: 82,
      child: SingleChildScrollView(
        // SingleChildScrollView -> versi horizontal, agar daftar kategori bisa digeser ke samping jika jumlahnya banyak
        scrollDirection: Axis.horizontal,
        child: Row(
          // Row -> menyusun setiap ikon kategori secara horizontal
          children: _categories.map((cat) {
            final label = cat['label'] as String;
            final bool isSelected = _selectedCategory == label;
            return Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                // GestureDetector dipakai hanya agar kategori bisa ditekan
                onTap: () {
                  setState(() => _selectedCategory = isSelected ? null : label);
                },
                child: Column(
                  // Column -> menyusun ikon (atas) dan label (bawah)
                  children: [
                    Container(
                      // Container -> latar bulat untuk ikon kategori
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(
                        // Icon -> ikon representasi kategori barang
                        cat['icon'] as IconData,
                        size: 22,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6), // SizedBox: jarak ikon ke label
                    Text(
                      // Text -> label nama kategori
                      label,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // --------------------------------------------
  // Filter status: Semua / Hilang / Ditemukan
  // --------------------------------------------
  Widget _buildStatusFilterChips() {
    final filters = ['Semua', 'Hilang', 'Ditemukan'];
    return Row(
      // Row -> menyusun ketiga chip filter status secara horizontal
      children: filters.map((filter) {
        final bool isSelected = _selectedStatusFilter == filter;
        return Padding(
          // Padding -> memberi jarak antar chip filter
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => setState(() => _selectedStatusFilter = filter),
            child: Container(
              // Container -> bentuk chip filter, warnanya berubah
              // sesuai status yang sedang aktif dipilih
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Text(
                // Text -> label nama filter (Semua/Hilang/Ditemukan)
                filter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ----------------------------------------------------------
  // Judul section "Laporan Terbaru" + tautan "Lihat Semua"
  // ----------------------------------------------------------
  Widget _buildSectionTitle() {
    return Row(
      // Row -> menyusun judul (kiri) dan tautan "Lihat Semua" (kanan)
      children: [
        const Expanded(
          // Expanded -> judul mengisi sisa ruang agar tautan "Lihat Semua" selalu berada di ujung kanan
          child: Text(
            // Text -> judul section
            'Laporan Terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          'Lihat Semua',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Daftar kartu laporan (hasil filter pencarian/kategori/status)
  // ---------------------------------------------------------------------
  Widget _buildReportList() {
    final reports = _filteredReports;

    if (reports.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            // Text -> pesan ketika tidak ada laporan yang cocok
            'Belum ada laporan yang cocok dengan pencarianmu',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      );
    }

    return Column(
      // Column -> menyusun seluruh kartu laporan secara vertikal
      children: reports.map((report) => _buildReportCard(report)).toList(),
    );
  }

  // Satu kartu laporan barang (hilang/ditemukan)
  Widget _buildReportCard(LostFoundReport report) {
    final bool isHilang = report.status == ReportStatus.hilang;
    final Color statusColor = isHilang ? Colors.red : Colors.green;

    return Container(
      // Container -> kartu (card) pembungkus setiap laporan, mengatur margin, padding, warna latar, dan borderRadius
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        // Row -> menyusun foto barang (kiri) dan detail laporan (kanan)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // Container -> placeholder foto barang (nantinya bisa diganti Image.network/Image.file berisi foto asli dari pelapor)
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              // Icon -> ikon representasi kategori barang
              report.icon,
              color: Colors.grey.shade500,
              size: 28,
            ),
          ),
          const SizedBox(width: 12), // SizedBox: jarak horizontal foto ke teks
          Expanded(
            // Expanded -> kolom detail laporan mengisi sisa lebar kartu
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // Row -> nama barang (kiri) dan badge status (kanan)
                  children: [
                    Expanded(
                      // Expanded -> nama barang bisa mengisi ruang yang tersedia dan terpotong (ellipsis) jika terlalu panjang
                      child: Text(
                        report.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      // Container -> badge kecil penanda status laporan
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isHilang ? 'Hilang' : 'Ditemukan',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4), // SizedBox: jarak nama ke deskripsi
                Text(
                  // Text -> deskripsi singkat barang
                  report.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6), // SizedBox: jarak deskripsi ke info lokasi
                Row(
                  // Row -> menyusun ikon lokasi, warna+lokasi, dan tanggal
                  children: [
                    Icon(
                      // Icon -> ikon lokasi
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '${report.color} • ${report.location}',
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      report.date,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
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

  // -----------------------------------------------------
  // Navigasi bawah: Beranda, Laporkan, Riwayat, Profil
  // -----------------------------------------------------
  Widget _buildBottomNavigationBar() {
    final navItems = [
      {'icon': Icons.home_rounded, 'label': 'Beranda'},
      {'icon': Icons.add_circle_outline_rounded, 'label': 'Laporkan'},
      {'icon': Icons.history_rounded, 'label': 'Riwayat'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profil'},
    ];

    return Container(
      // Container -> membungkus seluruh bar navigasi bawah, memberi warna latar putih dan garis pemisah di bagian atas
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        // SafeArea -> memastikan menu navigasi tidak tertutup gesture bar di bagian bawah perangkat (top: false karena hanya area bawah yang perlu diamankan di sini)
        top: false,
        child: Row(
          // Row -> menyusun setiap menu navigasi secara horizontal
          children: List.generate(navItems.length, (index) {
            final bool isSelected = _selectedNavIndex == index;
            final item = navItems[index];
            return Expanded(
              // Expanded -> setiap menu mendapat lebar yang sama rata
              child: GestureDetector(
                onTap: () => setState(() => _selectedNavIndex = index),
                child: Column(
                  // Column -> menyusun ikon (atas) dan label (bawah)
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      // Icon -> ikon menu navigasi
                      item['icon'] as IconData,
                      size: 24,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    const SizedBox(height: 2), // SizedBox: jarak ikon ke label
                    Text(
                      // Text -> label nama menu
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}