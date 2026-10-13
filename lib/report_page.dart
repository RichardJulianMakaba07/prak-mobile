import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:posttest2/providers/navigation_provider.dart';
import 'package:posttest2/providers/report_provider.dart';
import 'package:posttest2/utils/date_format.dart';
import 'package:posttest2/utils/input_style.dart';
import 'package:posttest2/utils/map_launcher.dart';
import 'package:posttest2/utils/place_name.dart';
import 'package:posttest2/widgets/page_app_bar.dart';

/// Halaman Laporkan: form membuat laporan barang hilang / ditemukan.
/// StatefulWidget DIPAKAI karena butuh: TextEditingController (+ dispose),
/// GlobalKey<FormState>, serta draft lokal (foto, koordinat, status loading GPS)
/// yang baru dikirim ke ReportProvider saat tombol "Kirim Laporan" ditekan.
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _colorC = TextEditingController();
  final _locationC = TextEditingController();
  final _descC = TextEditingController();
  final _picker = ImagePicker();

  // ---------- Draft form ----------
  String _status = 'Hilang';
  String? _category;
  DateTime _date = DateTime.now();
  Uint8List? _imageBytes;
  double? _lat;
  double? _lng;
  bool _locating = false; // true saat mengambil GPS
  bool _categoryError = false;
  bool _imageError = false;

  @override
  void dispose() {
    _titleC.dispose();
    _colorC.dispose();
    _locationC.dispose();
    _descC.dispose();
    super.dispose();
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===================== FOTO =====================
  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Ambil dari kamera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Pilih dari galeri'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1280, // perkecil agar hemat memori
        imageQuality: 80,
      );
      if (file == null) return; // user membatalkan
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _imageBytes = bytes;
        _imageError = false;
      });
    } catch (_) {
      if (mounted) _toast('Gagal mengambil foto');
    }
  }

  // ===================== LOKASI =====================
  Future<void> _useMyLocation() async {
    setState(() => _locating = true);
    try {
      // 1. GPS harus menyala
      if (!await Geolocator.isLocationServiceEnabled()) {
        _toast('Aktifkan GPS / layanan lokasi dulu');
        return;
      }
      // 2. Izin lokasi
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        _toast('Izin lokasi ditolak. Aktifkan lewat pengaturan aplikasi.');
        return;
      }
      // 3. Ambil koordinat
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      // 4. Koordinat -> nama tempat (boleh gagal, tidak masalah)
      final placeName = await getPlaceName(pos.latitude, pos.longitude);

      if (!mounted) return;
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        // Jangan menimpa teks yang sudah diketik user (mis. "Gedung F lt. 2")
        if (_locationC.text.trim().isEmpty) {
          _locationC.text = (placeName != null && placeName.isNotEmpty)
              ? placeName
              : '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
        }
      });
      _toast('Titik lokasi tersimpan');
    } catch (_) {
      if (mounted) _toast('Gagal mengambil lokasi');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  // ===================== TANGGAL =====================
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  // ===================== SUBMIT =====================
  void _resetForm() {
    _formKey.currentState?.reset();
    _titleC.clear();
    _colorC.clear();
    _locationC.clear();
    _descC.clear();
    setState(() {
      _status = 'Hilang';
      _category = null;
      _date = DateTime.now();
      _imageBytes = null;
      _lat = null;
      _lng = null;
      _categoryError = false;
      _imageError = false;
    });
  }

  void _submit() {
    final valid = _formKey.currentState!.validate();
    setState(() {
      _categoryError = _category == null;
      _imageError = _imageBytes == null;
    });
    if (!valid || _category == null || _imageBytes == null) {
      _toast('Lengkapi data laporan dulu');
      return;
    }

    context.read<ReportProvider>().addReport(
          title: _titleC.text.trim(),
          category: _category!,
          color: _colorC.text.trim(),
          location: _locationC.text.trim(),
          description: _descC.text.trim(),
          status: _status,
          date: _date,
          imageBytes: _imageBytes,
          latitude: _lat,
          longitude: _lng,
        );

    _toast('Laporan berhasil dikirim');
    _resetForm();
    context.read<NavigationProvider>().setIndex(2); // ke tab Riwayat
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    final isLost = _status == 'Hilang';

    return Scaffold(
      appBar: const PageAppBar(title: 'Laporkan Barang'),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- JENIS LAPORAN ----
                Row(
                  children: [
                    Expanded(
                      child: _TypeTile(
                        icon: Icons.search_off_rounded,
                        title: 'Barang Hilang',
                        subtitle: 'Aku kehilangan barang',
                        selected: isLost,
                        onTap: () => setState(() => _status = 'Hilang'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TypeTile(
                        icon: Icons.volunteer_activism_outlined,
                        title: 'Menemukan',
                        subtitle: 'Aku menemukan barang',
                        selected: !isLost,
                        onTap: () => setState(() => _status = 'Ditemukan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ---- FOTO ----
                _FormSection(
                  icon: Icons.photo_camera_outlined,
                  title: 'Foto Barang',
                  child: _buildPhotoPicker(),
                ),

                // ---- DETAIL ----
                _FormSection(
                  icon: Icons.inventory_2_outlined,
                  title: 'Detail Barang',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleC,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: appInputDecoration(
                          context,
                          label: 'Nama Barang',
                          hint: 'Contoh: Dompet Kulit Hitam',
                          icon: Icons.label_outline,
                        ),
                        validator: (v) => _required(v, 'Nama barang'),
                      ),
                      const SizedBox(height: 16),
                      const Text('Kategori',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ReportProvider.categories.map((c) {
                          final selected = _category == c.title;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _category = c.title;
                              _categoryError = false;
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.deepOrange
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? Colors.deepOrange
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(c.icon,
                                      size: 16,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black54),
                                  const SizedBox(width: 6),
                                  Text(
                                    c.title,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (_categoryError)
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 4),
                          child: Text('Pilih salah satu kategori',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _colorC,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: appInputDecoration(
                          context,
                          label: 'Warna',
                          hint: 'Contoh: Hitam',
                          icon: Icons.palette_outlined,
                        ),
                        validator: (v) => _required(v, 'Warna'),
                      ),
                    ],
                  ),
                ),

                // ---- LOKASI & WAKTU ----
                _FormSection(
                  icon: Icons.place_outlined,
                  title: 'Lokasi & Waktu',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _locationC,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: appInputDecoration(
                          context,
                          label: isLost
                              ? 'Lokasi Terakhir Terlihat'
                              : 'Lokasi Ditemukan',
                          hint: 'Contoh: Gedung F, lantai 2',
                          icon: Icons.location_on_outlined,
                        ),
                        validator: (v) => _required(v, 'Lokasi'),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _locating ? null : _useMyLocation,
                          icon: _locating
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : const Icon(Icons.my_location, size: 18),
                          label: Text(_locating
                              ? 'Mencari lokasi...'
                              : 'Gunakan lokasi saya'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepOrange,
                            side: BorderSide(color: Colors.deepOrange.shade200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      if (_lat != null && _lng != null)
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  size: 18, color: Colors.green.shade600),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'GPS: ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    openInMaps(context, _lat!, _lng!),
                                child: const Text('Peta'),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => setState(() {
                                  _lat = null;
                                  _lng = null;
                                }),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Tanggal (membuka date picker)
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 20, color: Colors.grey.shade500),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isLost
                                          ? 'Tanggal Kehilangan'
                                          : 'Tanggal Ditemukan',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(formatDate(_date),
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.edit_calendar_outlined,
                                  size: 20, color: Colors.deepOrange),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---- DESKRIPSI ----
                _FormSection(
                  icon: Icons.notes_rounded,
                  title: 'Deskripsi',
                  child: TextFormField(
                    controller: _descC,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: appInputDecoration(
                      context,
                      label: 'Ciri-ciri barang',
                      hint: 'Merk, stiker, isi, goresan, dll.',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Deskripsi wajib diisi';
                      }
                      if (v.trim().length < 10) {
                        return 'Deskripsi minimal 10 karakter';
                      }
                      return null;
                    },
                  ),
                ),

                // ---- TOMBOL KIRIM ----
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Kirim Laporan',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Area pilih foto: tampilan kosong (tombol Kamera/Galeri) atau preview
  Widget _buildPhotoPicker() {
    if (_imageBytes == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _imageError ? Colors.red : Colors.deepOrange.shade200,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_a_photo_outlined,
                    size: 38, color: Colors.deepOrange),
                const SizedBox(height: 8),
                const Text('Belum ada foto',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Foto membantu pemilik mengenali barang',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: const Text('Kamera'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: const Text('Galeri'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepOrange,
                    side: BorderSide(color: Colors.deepOrange.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
          if (_imageError)
            const Padding(
              padding: EdgeInsets.only(top: 6, left: 4),
              child: Text('Foto barang wajib ditambahkan',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ],
      );
    }

    // Sudah ada foto -> preview + tombol ganti / hapus
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.memory(
            _imageBytes!,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Row(
            children: [
              _RoundIconButton(icon: Icons.edit_outlined, onTap: _showSourceSheet),
              const SizedBox(width: 8),
              _RoundIconButton(
                icon: Icons.close,
                onTap: () => setState(() => _imageBytes = null),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------- widget kecil khusus halaman Laporkan ----------

/// Kartu putih berisi satu bagian form, dengan ikon + judul.
class _FormSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _FormSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: Colors.deepOrange),
              ),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

/// Pilihan jenis laporan (Hilang / Menemukan).
class _TypeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _TypeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Colors.deepOrange : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? Colors.deepOrange : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: selected ? Colors.black26 : Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                size: 26, color: selected ? Colors.white : Colors.deepOrange),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : Colors.black87)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 11,
                    color: selected ? Colors.white : Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

/// Tombol bulat kecil di atas preview foto.
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}
