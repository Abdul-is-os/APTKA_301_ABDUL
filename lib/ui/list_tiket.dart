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
  late DateTime _currentDate;
  List<Map<String, dynamic>> _hasilPencarian = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.tanggal;
    _cariJadwal();
  }

  // Fungsi ambil data
  void _cariJadwal() async {
    setState(() => _isLoading = true);
    try {
      // Kita panggil API. 
      // Catatan: Karena mock data kita jadwal harian (tidak ada tanggal spesifik),
      // hasil returnya akan sama setiap hari. Tapi UI tanggalnya akan berubah.
      final hasil = await _apiService.cariTiket(widget.asal, widget.tujuan);
      
      // Simulasi delay sedikit biar berasa loading
      await Future.delayed(const Duration(milliseconds: 500)); 

      if (mounted) {
        setState(() {
          _hasilPencarian = hasil;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  // Fungsi Ganti Tanggal
  void _gantiTanggal(int days) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: days));
    });
    // Refresh data setiap ganti tanggal
    _cariJadwal();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF1E1E1E);
    final Color cardColor = const Color(0xFF2C2C2C);
    final Color orangeColor = const Color(0xFFFF6D00);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Pilih Kereta", style: TextStyle( color: Colors.white, fontSize: 16)),
            Text(
              "${widget.asal} > ${widget.tujuan}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- 1. DATE NAVIGATION BAR ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: bgColor,
            child: Row(
              children: [
                // Tombol Previous (-)
                _buildDateButton("-", () => _gantiTanggal(-1)),
                
                const SizedBox(width: 12),
                
                // Teks Tanggal Tengah
                Expanded(
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(12),
                      color: cardColor,
                    ),
                    child: Text(
                      DateFormat('d MMM').format(_currentDate),
                      style: const TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 16
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Tombol Next (+)
                _buildDateButton("+", () => _gantiTanggal(1)),
              ],
            ),
          ),

          // --- 2. LIST HASIL PENCARIAN ---
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: orangeColor))
                : _hasilPencarian.isEmpty
                    ? const Center(child: Text("Tidak ada jadwal tersedia", style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _hasilPencarian.length,
                        itemBuilder: (context, index) {
                          final tiket = _hasilPencarian[index];
                          return _buildTicketCard(tiket, cardColor, orangeColor);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Widget Tombol Tanggal (+ / -)
  Widget _buildDateButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF2C2C2C),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Widget Kartu Tiket
  Widget _buildTicketCard(Map<String, dynamic> tiket, Color cardColor, Color orangeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // Bagian Kiri: Info Perjalanan
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Kereta & Kelas
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tiket['nama_kereta'],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Text("Ekonomi", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Jam & Rute
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Berangkat
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tiket['jam_berangkat'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(widget.asal, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    
                    // Panah
                    Icon(Icons.arrow_forward, color: orangeColor, size: 18),
                    
                    // Tiba
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(tiket['jam_tiba'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(widget.tujuan, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
          
          // Bagian Kanan: Tombol Pilih
          SizedBox(
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PemesananPage(tiket: tiket),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Pilih\nKereta",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}