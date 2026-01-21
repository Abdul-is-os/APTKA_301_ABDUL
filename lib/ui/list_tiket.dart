import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../service/api_service.dart';
import 'pesan.dart';

class HasilPencarianPage extends StatefulWidget {
  final String asal;
  final String tujuan;
  final DateTime tanggal;
  final int penumpang;

  const HasilPencarianPage({
    super.key,
    required this.asal,
    required this.tujuan,
    required this.tanggal,
    required this.penumpang,
  });

  @override
  State<HasilPencarianPage> createState() => _HasilPencarianPageState();
}

class _HasilPencarianPageState extends State<HasilPencarianPage> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _listJadwal = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cariJadwal();
  }

  void _cariJadwal() async {
    setState(() => _isLoading = true);
    try {
      // --- PERBAIKAN UTAMA DI SINI ---
      // Mengirim 3 parameter wajib: asal, tujuan, DAN tanggal
      final hasil = await _apiService.cariTiket(
        widget.asal,
        widget.tujuan,
        widget.tanggal,
      );

      setState(() {
        _listJadwal = hasil;
        _isLoading = false;
      });
    } catch (e) {
      print("Error pencarian jadwal: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Warna latar belakang gelap
    final Color bgColor = const Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.asal} → ${widget.tujuan}",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              DateFormat('dd MMMM yyyy').format(widget.tanggal),
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6D00)))
          : _listJadwal.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _listJadwal.length,
                  itemBuilder: (context, index) {
                    final tiket = _listJadwal[index];
                    return _buildTicketCard(tiket);
                  },
                ),
    );
  }

  // Tampilan jika tidak ada tiket ditemukan
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            "Tidak ada jadwal kereta tersedia\nuntuk rute dan tanggal ini.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // Widget Kartu Tiket
  Widget _buildTicketCard(Map<String, dynamic> tiket) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          // Baris Atas: Nama Kereta & Harga
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tiket['nama_kereta'] ?? 'Kereta',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                currency.format(tiket['harga'] ?? 0),
                style: const TextStyle(
                  color: Color(0xFFFF6D00), // Warna Oranye Khas
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 24),

          // Baris Tengah: Jam & Stasiun
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kolom Berangkat
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tiket['jam_berangkat'] ?? '-',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    tiket['kode_asal'] ?? '-',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              // Ikon Panah / Durasi
              const Icon(Icons.arrow_forward, color: Colors.grey, size: 16),

              // Kolom Tiba
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tiket['jam_tiba'] ?? '-',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    tiket['kode_tujuan'] ?? '-',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tombol Pilih
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigasi ke Halaman Pemesanan dengan membawa data tiket
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PemesananPage(tiket: tiket),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6D00),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Pilih",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}