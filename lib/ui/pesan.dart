import 'package:flutter/material.dart';
import 'tiket.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth untuk cek status login
import '../service/booking_service.dart';
import 'dashboard.dart';
import 'login.dart';
import 'dart:math';

class PemesananPage extends StatefulWidget {
  final Map<String, dynamic> tiket;

  const PemesananPage({super.key, required this.tiket});

  @override
  State<PemesananPage> createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller Input Data
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  String _tipePenumpang = 'Dewasa';
  
  bool _isLoading = false;

  void _prosesPesanan() async {
    // 1. CEK APAKAH USER TAMU ATAU MEMBER?
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text("Akses Dibatasi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text(
            "Maaf, Anda harus login terlebih dahulu untuk melakukan pemesanan tiket.", 
            style: TextStyle(color: Colors.white70)
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text("Batal", style: TextStyle(color: Colors.grey))
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup Dialog
                // Arahkan ke Login Page
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => const LoginPage())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6D00),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Login Sekarang", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      return; // Stop proses di sini, jangan lanjut ke booking
    }

    // 2. JIKA MEMBER (SUDAH LOGIN): Lanjut Validasi Form
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {

      String bookingId = "TRX-${Random().nextInt(9000) + 1000}";
      // Panggil Service untuk simpan ke Firebase (Kursi dipilih otomatis oleh sistem)
      await BookingService().buatPesanan(
        customId: bookingId,
        detailTiket: widget.tiket,
        namaPenumpang: _namaController.text,
        noIdentitas: _ktpController.text,
        tipePenumpang: _tipePenumpang,
      );
      Map<String, dynamic> tiketData = {
        'id_booking': bookingId,
        'detail_tiket': widget.tiket,
        'penumpang': {
          'nama': _namaController.text,
          'tipe': _tipePenumpang,
          'kursi_otomatis': 'Auto-Assign' // Di halaman tiket nanti akan terisi/bisa diupdate
        }
      };

      if (!mounted) return;

      // Tampilkan Sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tiket Berhasil Dipesan! Cek di Dashboard."), 
          backgroundColor: Colors.green
        ),
      );
      
      // Kembali ke Dashboard dan hapus history navigasi sebelumnya
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TiketPage(bookingData: tiketData),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memesan: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text("Isi Data Penumpang"),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- KARTU INFO KERETA ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFF6D00).withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.train, color: Color(0xFFFF6D00), size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tiket['nama_kereta'] ?? 'Kereta', 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${widget.tiket['jam_berangkat']} - ${widget.tiket['jam_tiba']}", 
                            style: const TextStyle(color: Colors.grey)
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4)
                            ),
                            child: const Text(
                              "Kursi: Auto-Assign (Sistem)", 
                              style: TextStyle(color: Colors.orange, fontSize: 12)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              const Text("Detail Penumpang", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // --- FORM INPUT ---
              // Input No Identitas
              TextFormField(
                controller: _ktpController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("No. KTP / ID"),
                validator: (val) => val!.isEmpty ? "Nomor identitas wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // Input Nama Lengkap
              TextFormField(
                controller: _namaController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Nama Lengkap"),
                validator: (val) => val!.isEmpty ? "Nama lengkap wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Tipe Penumpang
              DropdownButtonFormField<String>(
                value: _tipePenumpang,
                dropdownColor: const Color(0xFF2C2C2C),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Tipe Penumpang"),
                items: ['Dewasa', 'Anak-anak', 'Lansia'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _tipePenumpang = val!),
              ),

              const SizedBox(height: 40),

              // --- TOMBOL PESAN ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _prosesPesanan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6D00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        "Bayar & Pesan Tiket", 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), 
        borderSide: const BorderSide(color: Color(0xFFFF6D00))
      ),
    );
  }
}