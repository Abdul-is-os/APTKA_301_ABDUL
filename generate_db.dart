import 'dart:convert';
import 'dart:io';

void main() {
  print("🚀 Memulai Smart Generator untuk Kembang Express...");

  // --- 1. DATA STASIUN (Master Data) ---
  final stasiun = [
    { "kode_stasiun": "AND", "nama_stasiun": "ANDIR", "kota": "ANDIR" },
    { "kode_stasiun": "BBK", "nama_stasiun": "BABAKAN", "kota": "BABAKAN" },
    { "kode_stasiun": "BD", "nama_stasiun": "BANDUNG", "kota": "BANDUNG" },
    { "kode_stasiun": "DWP", "nama_stasiun": "DWIPURA", "kota": "DWIPURA" },
    { "kode_stasiun": "GRB", "nama_stasiun": "GERBANG", "kota": "GERBANG" },
    { "kode_stasiun": "GRG", "nama_stasiun": "GARUNG KOTA", "kota": "GARUNG" },
    { "kode_stasiun": "IBK", "nama_stasiun": "IBUKOTA PUSAT", "kota": "IBUKOTA" },
    { "kode_stasiun": "JTG", "nama_stasiun": "JATIROGO", "kota": "JATIROGO" },
    { "kode_stasiun": "KLM", "nama_stasiun": "KALIMAS", "kota": "KALIMAS" },
    { "kode_stasiun": "KLS", "nama_stasiun": "KALISETAIL", "kota": "KALISETAIL" },
    { "kode_stasiun": "KMB", "nama_stasiun": "KEMBANG", "kota": "KEMBANG" },
    { "kode_stasiun": "KYH", "nama_stasiun": "KAYUHITAM BARAT", "kota": "KAYUHITAM" },
    { "kode_stasiun": "MKS", "nama_stasiun": "MARAKAS", "kota": "MARAKAS" },
    { "kode_stasiun": "PGS", "nama_stasiun": "PAGARSIH", "kota": "IBUKOTA" },
    { "kode_stasiun": "PLB", "nama_stasiun": "PLABUAN KOTA", "kota": "PLABUAN" },
    { "kode_stasiun": "PRK", "nama_stasiun": "PARAKAN", "kota": "PARAKAN" },
    { "kode_stasiun": "PWN", "nama_stasiun": "PURWANEGARA", "kota": "IBUKOTA" },
    { "kode_stasiun": "RMB", "nama_stasiun": "REMBANG", "kota": "REMBANG" },
    { "kode_stasiun": "SM", "nama_stasiun": "SUMBER", "kota": "SUMBER" },
    { "kode_stasiun": "TJB", "nama_stasiun": "TANJUNG BARAT", "kota": "TANJUNG BARAT" },
    { "kode_stasiun": "TNB", "nama_stasiun": "TANAH BARU", "kota": "DWIPURA" },
    { "kode_stasiun": "TY", "nama_stasiun": "TAYU KOTA", "kota": "TAYU" },
    { "kode_stasiun": "UDJ", "nama_stasiun": "UDJUNG", "kota": "UJUNG" },
    { "kode_stasiun": "GMR", "nama_stasiun": "GAMBIR", "kota": "JAKARTA" }, 
    { "kode_stasiun": "SBY", "nama_stasiun": "SURABAYA GUBENG", "kota": "SURABAYA" }
  ];

  // --- 2. DEFINISI "SMART ROUTE" ---
  // Kita hanya mendefinisikan rute utama. Script akan memecahnya sendiri.
  final smartRoutes = [
    // RUTE 1: Kembang Express (Arah Pergi)
    {
      "id_kereta": "1",
      "nama": "Kembang Express 1",
      "harga_full": 150000,
      // Daftar stasiun singgah & waktu berangkatnya
      "rute": [
        {"kode": "IBK", "jam": "06:15", "posisi": 0.0}, // Posisi 0% (Awal)
        {"kode": "DWP", "jam": "06:40", "posisi": 0.4}, // Posisi 40% perjalanan
        {"kode": "KMB", "jam": "08:20", "posisi": 1.0}, // Posisi 100% (Akhir)
      ]
    },
    // RUTE 2: Kembang Express (Arah Pulang)
    {
      "id_kereta": "1",
      "nama": "Kembang Express 1",
      "harga_full": 150000,
      "rute": [
        {"kode": "KMB", "jam": "10:00", "posisi": 0.0},
        {"kode": "DWP", "jam": "11:45", "posisi": 0.4},
        {"kode": "IBK", "jam": "12:10", "posisi": 1.0},
      ]
    },
    
    // --- Kereta Lain (Opsional, Point-to-Point Sederhana) ---
    {
      "id_kereta": "3",
      "nama": "Tayu Express",
      "harga_full": 95000,
      "rute": [
        {"kode": "TY", "jam": "08:00", "posisi": 0.0},
        {"kode": "GRG", "jam": "12:00", "posisi": 1.0},
      ]
    },
  ];

  // --- 3. FUNGSI GENERATE GERBONG (Logika ID 1) ---
  List<Map<String, dynamic>> generateGerbong(String idKereta) {
    List<Map<String, dynamic>> listGerbong = [];
    int jumlahGerbong = (idKereta == "1") ? 4 : 3; // Kembang Express 4 Gerbong

    for (int g = 1; g <= jumlahGerbong; g++) {
      String namaKelas = "Kelas 3";
      int kapasitas = 12;

      // Aturan Khusus Kembang Express
      if (idKereta == "1") {
        if (g <= 2) {
          namaKelas = "Kelas 1";
          kapasitas = 8;
        } else {
          namaKelas = "Kelas 2";
          kapasitas = 10;
        }
      }

      // Generate Kursi
      List<Map<String, String>> kursi = [];
      int jumlahBaris = (kapasitas / 2).ceil();
      for (int baris = 1; baris <= jumlahBaris; baris++) {
        kursi.add({"kode": "${baris}a", "status": "available"});
        kursi.add({"kode": "${baris}b", "status": "available"});
      }

      listGerbong.add({
        "nomor_gerbong": g,
        "kelas": namaKelas,
        "kursi": kursi
      });
    }
    return listGerbong;
  }

  // --- 4. ENGINE: GENERATOR UTAMA ---
  List<Map<String, dynamic>> generatedJadwal = [];
  DateTime today = DateTime.now();

  // Loop 30 Hari
  for (int i = 0; i < 30; i++) {
    DateTime currentDate = today.add(Duration(days: i));
    String dateStr = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    // Loop Setiap "Smart Route"
    for (var route in smartRoutes) {
      String idKereta = route['id_kereta'] as String;
      String namaKereta = route['nama'] as String;
      int hargaFull = route['harga_full'] as int;
      List<Map<String, dynamic>> stops = route['rute'] as List<Map<String, dynamic>>;

      // --- LOGIKA PEMECAH SEGMEN ---
      // Kita loop stasiun A ke B, A ke C, B ke C, dst.
      for (int startIdx = 0; startIdx < stops.length - 1; startIdx++) {
        for (int endIdx = startIdx + 1; endIdx < stops.length; endIdx++) {
          
          var asal = stops[startIdx];
          var tujuan = stops[endIdx];

          // Hitung Harga Parsial berdasarkan selisih posisi
          double jarak = (tujuan['posisi'] as double) - (asal['posisi'] as double);
          // Harga = Jarak * Harga Full (Pembulatan ke ribuan terdekat)
          int hargaTiket = ((jarak * hargaFull) / 1000).round() * 1000;
          if (hargaTiket <= 0) hargaTiket = 20000; // Harga minimum

          // Buat ID Unik
          String uniqueId = "${dateStr.replaceAll('-', '')}-$idKereta-${asal['kode']}-${tujuan['kode']}";

          generatedJadwal.add({
            "id": uniqueId,
            "tanggal": dateStr,
            "id_kereta": idKereta,
            "nama_kereta": namaKereta,
            "kode_asal": asal['kode'],
            "kode_tujuan": tujuan['kode'],
            "jam_berangkat": asal['jam'],
            "jam_tiba": tujuan['jam'],
            "harga": hargaTiket,
            "gerbong": generateGerbong(idKereta)
          });
        }
      }
    }
  }

  // --- 5. SAVING FILE ---
  final db = {
    "stasiun": stasiun,
    "kereta": [
       { "id_kereta": "1", "nama_kereta": "Kembang Express 1" },
       { "id_kereta": "3", "nama_kereta": "Tayu Express" }
    ],
    "jadwal": generatedJadwal
  };

  Directory('assets').createSync(recursive: true);
  File('assets/db.json').writeAsStringSync(jsonEncode(db));
  
  print("✅ BERHASIL! Database telah di-generate.");
  print("Total Tiket Tergenerate: ${generatedJadwal.length}");
  print("Cek 'assets/db.json' untuk melihat hasilnya.");
}