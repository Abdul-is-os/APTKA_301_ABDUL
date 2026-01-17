import 'package:flutter/material.dart';
import 'cari_tiket.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("APTKA"),
        actions: [
          // 1. Keranjang
          _buildAppBarButton(
            icon: Icons.shopping_cart_outlined,
            onTap: () {},
          ),
          // 2. Akun
          _buildAppBarButton(
            icon: Icons.person,
            onTap: () {},
          ),
          // 3. Pengaturan
          _buildAppBarButton(
            icon: Icons.settings,
            onTap: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HERO BANNER
            Container(
              height: 180,
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/600x300/333333/FFFFFF?text=PETA+JARINGAN+KERETA"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text("PETA JARINGAN KERETA / BANNER PROMO", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

            // MENU GRID (HORIZONTAL SCROLL)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuButton(
                    context, 
                    title: "Tiket KA\nAntarkota", 
                    icon: Icons.train, 
                    color: const Color(0xFFD32F2F), 
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CariTiketPage()));
                    }
                  ),
                  const SizedBox(width: 20),
                  _buildMenuButton(context, title: "Kargo &\nEkspedisi", icon: Icons.inventory_2, color: Colors.orange),
                  const SizedBox(width: 20),
                  _buildMenuButton(context, title: "Peta\nLintas", icon: Icons.map, color: Colors.blue),
                  const SizedBox(width: 20),
                  _buildMenuButton(context, title: "Jadwal\nKereta", icon: Icons.schedule, color: Colors.grey),
                  const SizedBox(width: 20),
                  _buildMenuButton(context, title: "Jelajah\nKota", icon: Icons.location_on, color: Colors.amber),
                  const SizedBox(width: 20),
                  _buildMenuButton(context, title: "Tiket\nSaya", icon: Icons.confirmation_number, color: Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // TIKET AKTIF
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Tiket Aktif:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            
            _buildActiveTicketCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Widget Tombol Bulat AppBar
  Widget _buildAppBarButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20, color: Colors.white),
        onPressed: onTap,
        splashRadius: 20,
      ),
    );
  }

  // Widget Menu Kotak
  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required Color color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.white70))
        ],
      ),
    );
  }

  // Widget Kartu Tiket
  Widget _buildActiveTicketCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF383838),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SEL, 14 OKT 2026", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("KODE: BOOK-12345", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.train, color: Color(0xFFFF6D00), size: 20),
                    SizedBox(width: 8),
                    Text("ARGO PARAHYANGAN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("08:30", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text("BANDUNG (BD)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("3j 15m", style: TextStyle(color: Color(0xFFFF6D00), fontSize: 12)),
                        Icon(Icons.arrow_forward, color: Colors.grey.shade600),
                      ],
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("11:45", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text("GAMBIR (GMR)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.qr_code_2, color: Colors.black, size: 40),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}