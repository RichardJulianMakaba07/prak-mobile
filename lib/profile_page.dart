import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posttest2/providers/report_provider.dart';
import 'package:posttest2/providers/user_provider.dart';
import 'package:posttest2/widgets/edit_profile_sheet.dart';

/// Halaman Profil. StatelessWidget: data dari UserProvider (profil, switch
/// notifikasi) dan ReportProvider (statistik laporan milik user).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // agar sheet naik mengikuti keyboard
      backgroundColor: const Color(0xFFF5F6FA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => const EditProfileSheet(),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu harus masuk lagi untuk memakai aplikasi.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Keluar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      // Belum ada fitur login, jadi hanya menampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur login belum tersedia')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final reports = context.watch<ReportProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header oranye + kartu statistik yang menimpa tepi bawahnya
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 44),
                  child: _ProfileHeader(
                    user: user,
                    onEdit: () => _openEditSheet(context),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 0,
                  child: _StatsCard(reports: reports),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Informasi Akun'),
                  _Card(
                    children: [
                      _InfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email),
                      const _Divider(),
                      _InfoRow(
                          icon: Icons.phone_outlined,
                          label: 'No. HP',
                          value: user.phone),
                      const _Divider(),
                      _InfoRow(
                          icon: Icons.school_outlined,
                          label: 'Program Studi',
                          value: user.major),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const _SectionTitle('Pengaturan'),
                  _Card(
                    children: [
                      SwitchListTile(
                        secondary: const _IconBox(
                            icon: Icons.notifications_none_rounded),
                        title: const Text('Notifikasi'),
                        subtitle: const Text('Kabar tentang laporanmu'),
                        value: user.notificationOn,
                        onChanged: (v) =>
                            context.read<UserProvider>().toggleNotification(v),
                      ),
                      const _Divider(),
                      ListTile(
                        leading: const _IconBox(icon: Icons.help_outline),
                        title: const Text('Bantuan'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => showAboutDialog(
                          context: context,
                          applicationName: 'Campus Lost & Found',
                          applicationVersion: '1.0.0',
                          children: const [
                            Text(
                                'Laporkan barang hilang atau temuan di lingkungan kampus.'),
                          ],
                        ),
                      ),
                      const _Divider(),
                      ListTile(
                        leading: const _IconBox(
                            icon: Icons.logout, color: Colors.red),
                        title: const Text('Keluar',
                            style: TextStyle(color: Colors.red)),
                        onTap: () => _confirmLogout(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- widget kecil khusus halaman Profil ----------

class _ProfileHeader extends StatelessWidget {
  final UserProvider user;
  final VoidCallback onEdit;
  const _ProfileHeader({required this.user, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          24,
          MediaQuery.of(context).padding.top + 16,
          24,
          64, // ruang agar tidak tertutup kartu statistik
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepOrange.shade400, Colors.deepOrange.shade700],
          ),
        ),
        child: Stack(
          children: [
            // Lingkaran dekoratif
            const Positioned(
              right: -60,
              top: -40,
              child: _Circle(size: 170),
            ),
            const Positioned(
              left: -50,
              bottom: -60,
              child: _Circle(size: 140),
            ),
            Column(
              children: [
                const Text('Profil',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 20),
                // Avatar dengan cincin putih
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.deepOrange.shade50,
                    child: Text(
                      user.initial,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(user.name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0x33FFFFFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${user.nim} • ${user.major}',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit Profil'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    shape: const StadiumBorder(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  const _Circle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0x1AFFFFFF),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final ReportProvider reports;
  const _StatsCard({required this.reports});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          _StatItem(
              icon: Icons.assignment_outlined,
              color: Colors.deepOrange,
              value: reports.totalMine,
              label: 'Laporan'),
          _StatItem(
              icon: Icons.search_off_rounded,
              color: Colors.red,
              value: reports.lostMine,
              label: 'Hilang'),
          _StatItem(
              icon: Icons.check_circle_outline,
              color: Colors.green,
              value: reports.foundMine,
              label: 'Ditemukan'),
          _StatItem(
              icon: Icons.verified_outlined,
              color: Colors.blueGrey,
              value: reports.resolvedMine,
              label: 'Selesai'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final String label;
  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text('$value',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, indent: 72, color: Colors.grey.shade200);
}

/// Ikon di dalam kotak membulat berwarna lembut.
class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconBox({required this.icon, this.color = Colors.deepOrange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: color == Colors.red ? Colors.red.shade50 : Colors.deepOrange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _IconBox(icon: icon),
      title: Text(label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      subtitle: Text(value,
          style: const TextStyle(fontSize: 14, color: Colors.black87)),
    );
  }
}
