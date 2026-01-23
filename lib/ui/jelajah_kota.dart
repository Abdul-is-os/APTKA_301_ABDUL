import 'package:flutter/material.dart';

class JelajahKotaPage extends StatefulWidget {
  const JelajahKotaPage({super.key});

  @override
  State<JelajahKotaPage> createState() => _JelajahKotaPageState();
}

class _JelajahKotaPageState extends State<JelajahKotaPage> {
  // Data Kota & Deskripsi (Sesuai request)
  final List<Map<String, dynamic>> _dataKota = [
    {
      "id": 1,
      "nama": "Ibukota",
      "deskripsi": "Sesuai namanya, ini adalah ibukota. Memiliki pelabuhan yang besar, pusat pendidikan, ekonomi, dan politik negara."
    },
    {
      "id": 2,
      "nama": "Dwipura",
      "deskripsi": "Namanya berarti 2 istana, sekarang menjadi kota penting karena pertemuan berbagai jalur baik perdagangan dan transportasi, dan juga gerbang masuk ke ibukota."
    },
    {
      "id": 3,
      "nama": "Bandung",
      "deskripsi": "Merupakan kota yang terkelilingi oleh gunung, suhu disini cukup dingin bila dibanding dengan daerah lain. Akses kesini cukup sulit karena gunung yang tinggi menyulitkan pembuatan akses transportasi."
    },
    {
      "id": 4,
      "nama": "Udjung",
      "deskripsi": "Terletak di pinggir danau dan dulu menjadi kota paling ujung pada negeri ini. Tidak jauh dari sini ada reruntuhan kota kuno yang besar. Sekarang menjadi lokasi pariwisata terkenal di daerah selatan."
    },
    {
      "id": 5,
      "nama": "Kayuhitam",
      "deskripsi": "Terkenal karena penghasil kayu dengan warna gelap, sekarang terkenal karena industri energinya."
    },
    {
      "id": 6,
      "nama": "Tayu",
      "deskripsi": "Ini adalah kota perbatasan, sekitar kota ini banyak terdiri benteng-benteng dengan persenjataan yang hingga kini masih aktif. Karena seringnya konflik dengan negara perbatasan, kota ini menjadi pusat pertahanan bagian negeri barat."
    },
    {
      "id": 7,
      "nama": "Parakan",
      "deskripsi": "Kota sisi pantai yang terkenal dengan industri perikanan dan batu-batanya menjadikannya kota yang penting di daerah selatan."
    },
    {
      "id": 8,
      "nama": "Kembang",
      "deskripsi": "Kembang (dahulu Florisia) adalah kota yang cukup muda karena baru bergabung dengan negeri ini 2 dekade lalu. Diluar itu ini adalah kota yang memiliki arsitektur indah dan lokasinya yang disisi pantai menjadikannya pusat pariwisata. Kota ini menjadi tujuan emigrasi demi kepentingan asimilasi sosial."
    },
  ];

  // Default pilih ID 1 (Ibukota)
  int _selectedId = 1;

  @override
  Widget build(BuildContext context) {
    // Ambil data kota yang sedang dipilih
    final activeData = _dataKota.firstWhere((element) => element['id'] == _selectedId);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text("Jelajah Kota"),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. KOTAK GAMBAR KOTA ---
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
                // Jika nanti sudah ada gambar asli, uncomment kode di bawah:
                /*
                image: DecorationImage(
                  image: AssetImage('assets/kota_id_$_selectedId.png'),
                  fit: BoxFit.cover,
                ),
                */
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_city, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    "Gambar Kota ${activeData['nama']}",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- 2. DROPDOWN PILIH KOTA ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedId,
                  dropdownColor: const Color(0xFF2C2C2C),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  isExpanded: true,
                  items: _dataKota.map((item) {
                    return DropdownMenuItem<int>(
                      value: item['id'],
                      child: Text(item['nama']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedId = value;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- 3. DESKRIPSI KOTA ---
            const Text(
              "Deskripsi Kota:",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                activeData['deskripsi'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5, // Jarak antar baris agar nyaman dibaca
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}