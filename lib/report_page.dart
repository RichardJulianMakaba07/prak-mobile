import 'package:flutter/material.dart';
import 'package:posttest2/widgets/category_item.dart';
import 'package:posttest2/widgets/report_card.dart';
import 'package:posttest2/home_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Menyimpan index menu yang sedang dipilih
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        backgroundColor: Colors.white,
        shadowColor: Colors.deepOrange,
        elevation: 13,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
        ),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 45, left: 20, right: 20),
                height: 285,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 60,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      children: [
                        // Bagian kiri
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hai, Richard',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 19, 18, 18),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Temukan & laporkan barangmu di sini',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: const Color.fromARGB(255, 19, 18, 18)
                                ),
                              ),
                            ],
                          ),
                        ),
              
                        // Tombol notifikasi
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            size: 22,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
              
                    const SizedBox(height: 20),
              
                    // SEARCH BAR
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari barang hilang / ditemukan...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
              
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                        ),
              
                        filled: true,
                        fillColor: Colors.white,
              
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
              
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
              
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        
                      ),
                    ),
              
                    const SizedBox(height: 15),
              
                    // KATEGORI
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Dompet
                          CategoryItem(
                            title: 'Dompet',
                            icon: Icons.account_balance_wallet_outlined,
                          ),
                          // HP
                          CategoryItem(title: 'HP', icon: Icons.smartphone_outlined),
                          // Laptop
                          CategoryItem(title: 'Laptop', icon: Icons.laptop_mac_outlined),
                          // Kunci
                          CategoryItem(title: 'Kunci', icon: Icons.vpn_key_outlined),
                          // Tas
                          CategoryItem(title: 'Tas', icon: Icons.backpack_outlined),
                          // Jaket
                          CategoryItem(title: 'Jaket', icon: Icons.checkroom_outlined),
                        ],
                      ),
                    ),
              
                    const SizedBox(height: 40),
              
                    // FILTER STATUS
                    Row(
                      children: [
                        // Semua
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
              
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: const Offset(0, 3)
                              )
                            ]
                          ),
                          
                          child: const Text(
                            'Semua',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
              
                        const SizedBox(width: 10),
              
                        // Hilang
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
              
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: const Offset(0, 3)
                              )
                            ]
                          ),
              
                          child: const Text(
                            'Hilang',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                        ),
              
                        const SizedBox(width: 10),
              
                        // Ditemukan
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
              
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: const Offset(0, 3)
                              )
                            ]
                          ),
              
                          child: const Text(
                            'Ditemukan',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
              
                    const SizedBox(height: 20),
              
                    // JUDUL LAPORAN
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Laporan Terbaru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
              
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                      ],
                    ),
              
                    const SizedBox(height: 12),
              
                    // LAPORAN 
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ReportCard(
                                image: 'assets/gambar.png',
                                title: 'Dompet Kulit Hitam',
                                color: 'Hitam',
                                location: 'Gedung F',
                                date: '22 Sep 2026',
                                description: 'Dompet hitam, ada logo Adidas di bagian depan',
                                status: 'Hilang',
                              ),
                            ),
                        
                            const SizedBox(width: 12),
                        
                            Expanded(
                              child: ReportCard(
                                image: 'assets/gambar.png',
                                title: 'Tas Ranse Hitam',
                                color: 'Hitam',
                                location: 'Perpustakaan',
                                date: '22 Sep 2026',
                                description: 'Tas ransel hitam merk Eiger, ada laptop di dalamnya',
                                status: 'Ditemukan',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ReportCard(
                                image: 'assets/gambar.png',
                                title: 'Dompet Kulit Hitam',
                                color: 'Hitam',
                                location: 'Gedung F',
                                date: '22 Sep 2026',
                                description: 'Dompet hitam, ada logo Adidas di bagian depan',
                                status: 'Hilang',
                              ),
                            ),
                        
                            const SizedBox(width: 12),
                        
                            Expanded(
                              child: ReportCard(
                                image: 'assets/gambar.png',
                                title: 'Tas Ranse Hitam',
                                color: 'Hitam',
                                location: 'Perpustakaan',
                                date: '22 Sep 2026',
                                description: 'Tas ransel hitam merk Eiger, ada laptop di dalamnya',
                                status: 'Ditemukan',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // TOMBOL LAPORKAN
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black, 
                            blurRadius: 4,
                            offset: const Offset(0, 3), 
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Nanti akan digunakan
                          // untuk membuka halaman Laporkan
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            backgroundColor: Colors.transparent, // Transparan agar mengikuti warna Container
            elevation: 0, // Menghilangkan bayangan bawaan NavigationBar
            
            onDestinationSelected: (index) {
              if (index == 0) {
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
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
      )
    );
  }
}
