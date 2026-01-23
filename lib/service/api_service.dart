import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/stasiun.dart';
import 'package:intl/intl.dart'; // Pastikan package intl sudah diinstall

class ApiService {
  // GANTI URL INI nanti jika sudah deploy ke GitHub/My JSON Server
  // Untuk sekarang (lokal), gunakan IP laptop kamu jika run di HP Android asli
  // Atau 'http://localhost:3000' jika run di Emulator/Chrome
  final String baseUrl = 'https://my-json-server.typicode.com/Abdul-is-os/APTKA_301_ABDUL/tree/main/assets';

  // --- 1. AMBIL DATA STASIUN ---
  Future<List<Stasiun>> getStasiun() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/stasiun'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => Stasiun.fromJson(data)).toList();
      } else {
        throw Exception('Gagal memuat stasiun');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // --- 2. CARI TIKET (Logika Baru) ---
  Future<List<Map<String, dynamic>>> cariTiket(
      String asal, String tujuan, DateTime tanggal) async {
    try {
      // Ubah format tanggal dari UI (DateTime) menjadi String "YYYY-MM-DD"
      // agar cocok dengan format di db.json (hasil generate)
      String formattedDate = DateFormat('yyyy-MM-dd').format(tanggal);

      // Filter query params sesuai struktur JSON baru
      final uri = Uri.parse('$baseUrl/jadwal').replace(queryParameters: {
        'kode_asal': asal,
        'kode_tujuan': tujuan,
        'tanggal': formattedDate,
      });

      // Debugging: Print URL untuk memastikan request benar
      print("Requesting: $uri");

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        
        // Kita cast ke List<Map> agar bisa dibaca UI
        // Karena struktur JSON sudah nested (ada gerbong di dalamnya),
        // kita tidak perlu join manual lagi. Langsung return saja.
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }
    } catch (e) {
      print("Error cari tiket: $e");
      return []; // Return list kosong jika error agar aplikasi tidak crash
    }
  }
  // 3. Ambil Daftar Semua Kereta
  Future<List<Map<String, dynamic>>> getDaftarKereta() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/kereta'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // 4. Ambil Jadwal Lengkap (Perhentian)
  Future<List<Map<String, dynamic>>> getJadwalLengkap() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jadwal'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
