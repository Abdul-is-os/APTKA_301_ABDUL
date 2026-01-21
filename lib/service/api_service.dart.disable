import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; 
import '../model/stasiun.dart';
import '../model/jadwal.dart';
import '../model/kereta.dart';

class ApiService {
  // Getter pintar untuk menentukan alamat IP
  String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:3000";
    } else {
      // Untuk Android Emulator gunakan 10.0.2.2, untuk Windows Desktop gunakan localhost
      return "http://10.0.2.2:3000"; 
      // Jika error di emulator, ganti return di atas jadi ip laptop: "http://192.168.1.XX:3000";
    }
  }

  // Ambil Data Stasiun
  Future<List<Stasiun>> getStasiun() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/stasiun'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Stasiun.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data stasiun');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }

  // Logika Pencarian Tiket (Gabungan 3 Endpoint)
  Future<List<Map<String, dynamic>>> cariTiket(String asal, String tujuan) async {
    try {
      final respAsal = await http.get(Uri.parse('$baseUrl/jadwal?kode_stasiun=$asal'));
      final respTujuan = await http.get(Uri.parse('$baseUrl/jadwal?kode_stasiun=$tujuan'));
      final respKereta = await http.get(Uri.parse('$baseUrl/kereta'));

      if (respAsal.statusCode == 200 && respTujuan.statusCode == 200) {
        List<Jadwal> listAsal = (jsonDecode(respAsal.body) as List).map((e) => Jadwal.fromJson(e)).toList();
        List<Jadwal> listTujuan = (jsonDecode(respTujuan.body) as List).map((e) => Jadwal.fromJson(e)).toList();
        List<Kereta> listNamaKereta = (jsonDecode(respKereta.body) as List).map((e) => Kereta.fromJson(e)).toList();

        List<Map<String, dynamic>> hasilPencarian = [];

        for (var jAsal in listAsal) {
          var match = listTujuan.where((jTujuan) => 
              jTujuan.idKereta == jAsal.idKereta && 
              jTujuan.urutanSinggah > jAsal.urutanSinggah
          );

          for (var jTujuan in match) {
            var namaKereta = listNamaKereta.firstWhere(
              (k) => k.idKereta == jAsal.idKereta, 
              orElse: () => Kereta(idKereta: '0', namaKereta: 'Unknown')
            ).namaKereta;

            hasilPencarian.add({
              'nama_kereta': namaKereta,
              'jam_berangkat': jAsal.jamBerangkat,
              'jam_tiba': jTujuan.jamBerangkat,
              'id_kereta': jAsal.idKereta
            });
          }
        }
        return hasilPencarian;
      } else {
        throw Exception('Gagal mengambil data jadwal');
      }
    } catch (e) {
      throw Exception('Error cari tiket: $e');
    }
  }
}