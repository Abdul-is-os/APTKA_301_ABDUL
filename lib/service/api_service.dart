import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/stasiun.dart';
import 'package:intl/intl.dart'; 

class ApiService {
  // 1. URL RAW (Wajib pakai ini agar tidak kena limit 10KB)
  final String rawUrl = 'https://raw.githubusercontent.com/Abdul-is-os/APTKA_301_ABDUL/refs/heads/main/db.json';

  // Cache penyimpanan data agar aplikasi cepat (tidak download berulang)
  Map<String, dynamic>? _localCache;

  // Fungsi internal untuk mengambil seluruh database
  Future<Map<String, dynamic>> _fetchWholeDb() async {
    // Jika data sudah ada di memori, pakai yang ada (hemat kuota)
    if (_localCache != null) return _localCache!;

    try {
      final response = await http.get(Uri.parse(rawUrl));
      if (response.statusCode == 200) {
        _localCache = jsonDecode(response.body);
        return _localCache!;
      } else {
        throw Exception('Gagal mengambil database');
      }
    } catch (e) {
      print("Error fetching Raw DB: $e");
      return {};
    }
  }

  // --- 2. GET STASIUN ---
  Future<List<Stasiun>> getStasiun() async {
    final db = await _fetchWholeDb();
    if (db.containsKey('stasiun')) {
      List data = db['stasiun'];
      // Mapping manual untuk memastikan error handling
      return data.map((json) => Stasiun.fromJson(json)).toList();
    }
    return [];
  }

  // --- 3. CARI TIKET (Logika Diperbaiki) ---
  // Kita kembalikan parameter ke DateTime agar UI tidak Error
  Future<List<Map<String, dynamic>>> cariTiket(String asal, String tujuan, DateTime tanggal) async {
    final db = await _fetchWholeDb();
    
    // Cek apakah ada data jadwal
    if (!db.containsKey('jadwal')) return [];

    List data = db['jadwal'];

    // Ubah DateTime dari UI menjadi String "YYYY-MM-DD" untuk pencocokan
    String cariTanggal = DateFormat('yyyy-MM-dd').format(tanggal);

    // Lakukan Filter Client-Side (Pengganti query parameter)
    var hasilFilter = data.where((j) {
      // Ambil data dari JSON (Handle null safety)
      String jAsal = j['kode_asal'] ?? j['kode_stasiun'] ?? '';
      String jTujuan = j['kode_tujuan'] ?? '';
      String jTanggal = j['tanggal'] ?? '';

      // LOGIKA PENCOCOKAN KETAT (Agar tidak looping/duplikat)
      bool matchAsal = jAsal.trim().toUpperCase() == asal.trim().toUpperCase();
      bool matchTujuan = jTujuan.trim().toUpperCase() == tujuan.trim().toUpperCase();
      bool matchTanggal = jTanggal == cariTanggal;

      // Kembalikan data HANYA JIKA ketiganya cocok
      return matchAsal && matchTujuan && matchTanggal;
    }).toList();

    return hasilFilter.map((e) => e as Map<String, dynamic>).toList();
  }

  // --- 4. GET DAFTAR KERETA ---
  Future<List<Map<String, dynamic>>> getDaftarKereta() async {
    final db = await _fetchWholeDb();
    if (db.containsKey('kereta')) {
      return List<Map<String, dynamic>>.from(db['kereta']);
    }
    return [];
  }

  // --- 5. GET JADWAL LENGKAP ---
  Future<List<Map<String, dynamic>>> getJadwalLengkap() async {
    final db = await _fetchWholeDb();
    if (db.containsKey('jadwal')) {
      return List<Map<String, dynamic>>.from(db['jadwal']);
    }
    return [];
  }
}