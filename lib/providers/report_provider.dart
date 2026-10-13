import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:posttest2/models/report_data.dart';
import 'package:posttest2/utils/date_format.dart';

/// ReportProvider (ChangeNotifier) = satu sumber data untuk semua halaman:
///  - Beranda  : filter kategori / status / pencarian / "Lihat Semua"
///  - Laporkan : addReport()
///  - Riwayat  : myReports, filter riwayat, markResolved(), deleteReport()
///  - Profil   : statistik laporan milik user
/// Setiap perubahan memanggil notifyListeners() sehingga semua halaman sinkron.
class ReportProvider extends ChangeNotifier {
  // ===================== DATA STATIS =====================
  static const List<ReportCategory> categories = [
    ReportCategory('Dompet', Icons.account_balance_wallet_outlined),
    ReportCategory('HP', Icons.smartphone_outlined),
    ReportCategory('Laptop', Icons.laptop_mac_outlined),
    ReportCategory('Kunci', Icons.vpn_key_outlined),
    ReportCategory('Tas', Icons.backpack_outlined),
    ReportCategory('Jaket', Icons.checkroom_outlined),
    ReportCategory('Lainnya', Icons.more_horiz_rounded),
  ];

  static const List<String> statuses = ['Semua', 'Hilang', 'Ditemukan'];
  static const List<String> historyFilters = ['Semua', 'Aktif', 'Selesai'];

  // ===================== STATE =====================
  final List<ReportData> _reports = [
    const ReportData(
      id: 'r1',
      image: 'assets/gambar.png',
      title: 'Dompet Kulit Hitam',
      category: 'Dompet',
      color: 'Hitam',
      location: 'Gedung F',
      date: '22 Sep 2026',
      description: 'Dompet hitam, ada logo Adidas di bagian depan',
      status: 'Hilang',
      isOwn: true,
    ),
    const ReportData(
      id: 'r2',
      image: 'assets/gambar.png',
      title: 'Tas Ransel Hitam',
      category: 'Tas',
      color: 'Hitam',
      location: 'Perpustakaan',
      date: '22 Sep 2026',
      description: 'Tas ransel hitam merk Eiger, ada laptop di dalamnya',
      status: 'Ditemukan',
    ),
    const ReportData(
      id: 'r3',
      image: 'assets/gambar.png',
      title: 'Kunci Motor Honda',
      category: 'Kunci',
      color: 'Hitam',
      location: 'Parkiran Barat',
      date: '21 Sep 2026',
      description: 'Kunci motor Honda dengan gantungan kunci biru',
      status: 'Ditemukan',
      isOwn: true,
    ),
    const ReportData(
      id: 'r4',
      image: 'assets/gambar.png',
      title: 'iPhone 13',
      category: 'HP',
      color: 'Putih',
      location: 'Kantin Pusat',
      date: '20 Sep 2026',
      description: 'HP putih, casing bening, wallpaper pantai',
      status: 'Hilang',
      isOwn: true,
    ),
    const ReportData(
      id: 'r5',
      image: 'assets/gambar.png',
      title: 'Jaket Almamater',
      category: 'Jaket',
      color: 'Biru',
      location: 'Gedung A',
      date: '19 Sep 2026',
      description: 'Jaket almamater biru dongker ukuran L',
      status: 'Hilang',
      isOwn: true,
      isResolved: true,
    ),
    const ReportData(
      id: 'r6',
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

  // Filter Beranda
  String? _selectedCategory; // null = semua kategori
  String _selectedStatus = 'Semua';
  String _searchQuery = '';
  bool _showAll = false;

  // Filter Riwayat
  String _historyFilter = 'Semua';

  // ===================== GETTER =====================
  String? get selectedCategory => _selectedCategory;
  String get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;
  bool get showAll => _showAll;
  String get historyFilter => _historyFilter;

  /// Hasil filter Beranda (kategori + status + kata kunci).
  /// Laporan yang sudah selesai tidak ditampilkan lagi di Beranda.
  List<ReportData> get filteredReports {
    final query = _searchQuery.toLowerCase();
    return _reports.where((r) {
      final matchCategory =
          _selectedCategory == null || r.category == _selectedCategory;
      final matchStatus =
          _selectedStatus == 'Semua' || r.status == _selectedStatus;
      final matchSearch = query.isEmpty ||
          r.title.toLowerCase().contains(query) ||
          r.description.toLowerCase().contains(query) ||
          r.location.toLowerCase().contains(query);
      return !r.isResolved && matchCategory && matchStatus && matchSearch;
    }).toList();
  }

  /// Dibatasi 4 item kecuali "Lihat Semua" ditekan.
  List<ReportData> get visibleReports {
    final result = filteredReports;
    if (!_showAll && result.length > 4) return result.sublist(0, 4);
    return result;
  }

  /// Semua laporan milik user (untuk Riwayat & Profil).
  List<ReportData> get myReports => _reports.where((r) => r.isOwn).toList();

  /// Laporan milik user setelah difilter Semua / Aktif / Selesai.
  List<ReportData> get historyReports {
    return myReports.where((r) {
      switch (_historyFilter) {
        case 'Aktif':
          return !r.isResolved;
        case 'Selesai':
          return r.isResolved;
        default:
          return true;
      }
    }).toList();
  }

  // Statistik untuk Riwayat & Profil
  int get totalMine => myReports.length;
  int get activeMine => myReports.where((r) => !r.isResolved).length;
  int get resolvedMine => myReports.where((r) => r.isResolved).length;
  int get lostMine => myReports.where((r) => r.status == 'Hilang').length;
  int get foundMine => myReports.where((r) => r.status == 'Ditemukan').length;

  // ===================== ACTION: BERANDA =====================
  /// Memilih kategori. Kirim null untuk kembali ke "Semua".
  void setCategory(String? title) {
    _selectedCategory = title;
    notifyListeners();
  }

  void setStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void toggleShowAll() {
    _showAll = !_showAll;
    notifyListeners();
  }

  // ===================== ACTION: RIWAYAT =====================
  void setHistoryFilter(String value) {
    _historyFilter = value;
    notifyListeners();
  }

  /// Menandai laporan selesai (barang ketemu / sudah dikembalikan).
  void markResolved(String id) {
    final i = _reports.indexWhere((r) => r.id == id);
    if (i == -1) return;
    _reports[i] = _reports[i].copyWith(isResolved: true);
    notifyListeners();
  }

  void deleteReport(String id) {
    _reports.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  // ===================== ACTION: LAPORKAN =====================
  void addReport({
    required String title,
    required String category,
    required String color,
    required String location,
    required String description,
    required String status,
    required DateTime date,
    Uint8List? imageBytes,
    double? latitude,
    double? longitude,
  }) {
    _reports.insert(
      0, // laporan terbaru di paling atas
      ReportData(
        id: 'r${DateTime.now().microsecondsSinceEpoch}',
        image: 'assets/gambar.png', // cadangan jika tidak ada foto
        imageBytes: imageBytes,
        title: title,
        category: category,
        color: color,
        location: location,
        latitude: latitude,
        longitude: longitude,
        date: formatDate(date),
        description: description,
        status: status,
        isOwn: true,
      ),
    );
    notifyListeners();
  }
}
