import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../service/booking_service.dart';
import 'cari_tiket.dart';
import 'login.dart';

class DashboardPage extends StatefulWidget {
  final bool isGuest;
  const DashboardPage({super.key, this.isGuest = false});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  // --- LOGIKA LOGOUT ---
  void _handleLogout() async {
    if (!widget.isGuest) {
      await FirebaseAuth.instance.signOut();
    }
    if (mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const LoginPage())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Warna Background Utama Gelap
    final Color bgColor = const Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: bgColor,
      // --- APP BAR CUSTOM SESUAI GAMBAR ---
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          "APTKA", 
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 1.5,
            fontSize: 22
          )
        ),
        actions: [
          // Ikon Keranjang
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
          // Tombol AKUN (Pill Shape)
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: OutlinedButton(
              onPressed: _handleLogout, // Klik Akun untuk Logout/Login
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                widget.isGuest ? "LOGIN" : "AKUN", 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. BANNER PROMO ---
            Container(
              margin: const EdgeInsets.all(16),
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    "PETA JARINGAN KERETA / BANNER PROMO",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  )
                ],
              ),
            ),

            // --- 2. MENU IKON WARNA-WARNI (Horizontal Scroll) ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu 1: Tiket KA (Merah) -> Navigasi ke Cari Tiket
                  _buildMenuItem(
                    icon: Icons.train, 
                    color: Colors.red, 
                    label: "Tiket KA\nAntarkota",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CariTiketPage())),
                  ),
                  // Menu 2: Kargo (Oranye)
                  _buildMenuItem(icon: Icons.inventory_2, color: Colors.orange, label: "Kargo &\nEkspedisi"),
                  // Menu 3: Peta (Biru)
                  _buildMenuItem(icon: Icons.map, color: Colors.blue, label: "Peta\nLintas"),
                  // Menu 4: Jadwal (Abu)
                  _buildMenuItem(icon: Icons.schedule, color: Colors.grey, label: "Jadwal\nKereta"),
                  // Menu 5: Jelajah (Kuning)
                  _buildMenuItem(icon: Icons.place, color: Colors.amber, label: "Jelajah\nKota"),
                  // Menu 6: Tiket Saya (Hijau)
                  _buildMenuItem(icon: Icons.confirmation_number, color: Colors.green, label: "Tiket\nSaya"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- 3. JUDUL TIKET AKTIF ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Tiket Aktif:",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // --- 4. LOGIKA TIKET (STREAM BUILDER) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: widget.isGuest 
                ? _buildGuestMessage() 
                : StreamBuilder<QuerySnapshot>(
                    stream: BookingService().getTiketAktif(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return _buildEmptyState();
                      }

                      // Tampilan List Tiket (Vertikal agar muat banyak info)
                      return ListView.builder(
                        shrinkWrap: true, // Agar bisa di dalam SingleChildScrollView
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                          return _buildTicketCard(data);
                        },
                      );
                    },
                  ),
            ),
            
            // Tambahan ruang di bawah agar tidak mentok
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PENDUKUNG ---

  // 1. Item Menu Ikon
  Widget _buildMenuItem({
    required IconData icon, 
    required Color color, 
    required String label,
    VoidCallback? onTap
  }) {
    return GestureDetector(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fitur ini sedang dalam pengembangan"))
        );
      },
      child: Container(
        width: 70, // Lebar item
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              height: 50, width: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 11),
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }

  // 2. Kartu Tiket (Desain disesuaikan agar compact di dashboard)
  Widget _buildTicketCard(Map<String, dynamic> data) {
    final detail = data['detail_tiket'];
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Nama Kereta & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                detail['nama_kereta'], 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4)
                ),
                child: const Text("AKTIF", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const Divider(color: Colors.white10, height: 20),
          
          // Body: Jam & Rute
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Berangkat
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(detail['kode_asal'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(detail['jam_berangkat'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              // Panah
              const Icon(Icons.arrow_forward, color: Colors.grey, size: 16),
              // Tiba
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(detail['kode_tujuan'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(detail['jam_tiba'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Footer: Kursi & Harga
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.chair, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${data['penumpang']['kursi_otomatis']}", 
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
                Text(
                  currency.format(detail['harga']), 
                  style: const TextStyle(color: Colors.white70, fontSize: 12)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 3. State Kosong
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.confirmation_number_outlined, size: 48, color: Colors.white24),
          SizedBox(height: 12),
          Text("Belum ada tiket aktif", style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  // 4. Pesan Guest
  Widget _buildGuestMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3))
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, color: Colors.orange),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Login untuk melihat tiket aktif Anda.", 
              style: TextStyle(color: Colors.white70)
            ),
          ),
        ],
      ),
    );
  }
}