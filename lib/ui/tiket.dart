import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dashboard.dart';

class TiketPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const TiketPage({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    // Ambil data dari map agar kode lebih rapi
    final detail = bookingData['detail_tiket'];
    final penumpang = bookingData['penumpang'];
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text("E-Tiket"),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: true,
        automaticallyImplyLeading: false, // Hilangkan tombol back default
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text("Pemesanan Berhasil!", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            // --- KARTU TIKET (BOARDING PASS STYLE) ---
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  // HEADER: Kode Booking & Status
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("KODE BOOKING", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            Text(
                              bookingData['id_booking'] ?? "-", // Menampilkan ID
                              style: const TextStyle(color: Color(0xFFFF6D00), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Text("LUNAS", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                  
                  const Divider(color: Colors.white10, height: 1),

                  // BODY: Detail Perjalanan (Sama seperti Dashboard)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Kereta
                        Text(detail['nama_kereta'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 20),
                        
                        // Rute & Jam
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(detail['kode_asal'], style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                Text(detail['jam_berangkat'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                Text(detail['tanggal'] ?? "2026-01-22", style: const TextStyle(color: Colors.grey, fontSize: 12)), // Tgl dummy/statis dulu
                              ],
                            ),
                            const Icon(Icons.arrow_forward, color: Colors.grey, size: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(detail['kode_tujuan'], style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                Text(detail['jam_tiba'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                Text(detail['tanggal'] ?? "2026-01-22", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // FOOTER: Penumpang & Kursi
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF222222),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.grey, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(penumpang['nama'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                Text(penumpang['tipe'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        // Kursi & Harga
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             Row(
                               children: [
                                 const Icon(Icons.chair, color: Colors.orange, size: 16),
                                 const SizedBox(width: 4),
                                 Text(penumpang['kursi_otomatis'], style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
                               ],
                             ),
                             const SizedBox(height: 4),
                             Text(currency.format(detail['harga']), style: const TextStyle(color: Colors.white70)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // --- END KARTU ---

            const SizedBox(height: 40),
            
            // Tombol Selesai
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Kembali ke Dashboard dan hapus semua history
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => const DashboardPage(isGuest: false)), 
                    (route) => false
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D00),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Kembali ke Beranda", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}