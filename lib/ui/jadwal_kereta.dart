import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../model/stasiun.dart';

class JadwalKeretaPage extends StatefulWidget {
  const JadwalKeretaPage({super.key});

  @override
  State<JadwalKeretaPage> createState() => _JadwalKeretaPageState();
}

class _JadwalKeretaPageState extends State<JadwalKeretaPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  // Data Mentah
  List<Map<String, dynamic>> _listKereta = [];
  List<Map<String, dynamic>> _listJadwal = [];
  List<Stasiun> _listStasiun = [];

  // Data yang sudah diolah
  Map<String, Map<String, List<Map<String, dynamic>>>> _groupedJadwal = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final data = await Future.wait([
        _apiService.getDaftarKereta(),
        _apiService.getJadwalLengkap(),
        _apiService.getStasiun(),
      ]);

      _listKereta = List<Map<String, dynamic>>.from(data[0]);
      _listJadwal = List<Map<String, dynamic>>.from(data[1]);
      _listStasiun = data[2] as List<Stasiun>;

      _olahData(); 
    } catch (e) {
      print("Error loading jadwal: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _olahData() {
    _groupedJadwal = {};
    Set<String> uniqueKeys = {};

    for (var jadwal in _listJadwal) {
      String idKereta = jadwal['id_kereta']?.toString() ?? '';
      if (idKereta.isEmpty) continue;

      String arah = jadwal['arah']?.toString() ?? 'Pergi';
      
      // --- PERBAIKAN UTAMA DI SINI ---
      // Jika 'kode_stasiun' tidak ada (null), kita ambil dari 'kode_asal'
      String kodeStasiunRaw = jadwal['kode_stasiun']?.toString() 
                            ?? jadwal['kode_asal']?.toString() 
                            ?? '';
      
      String jam = jadwal['jam_berangkat']?.toString() ?? '';

      // Skip jika kode stasiun masih kosong juga
      if (kodeStasiunRaw.isEmpty) continue;

      // Filter Duplikat
      String uniqueKey = "${idKereta}_${arah}_${kodeStasiunRaw}_${jam}";
      if (uniqueKeys.contains(uniqueKey)) continue; 
      uniqueKeys.add(uniqueKey);

      // Cari Nama Stasiun (Handle Null Safety & Trim Spasi)
      var stasiunInfo = _listStasiun.firstWhere(
        (s) => s.kodeStasiun.trim().toUpperCase() == kodeStasiunRaw.trim().toUpperCase(),
        orElse: () => Stasiun(
          kodeStasiun: kodeStasiunRaw, 
          // Jika nama tidak ketemu di master stasiun, pakai kodenya saja
          namaStasiun: "Stasiun $kodeStasiunRaw",
          kota: '-'
        )
      );

      // Inisialisasi Group
      if (!_groupedJadwal.containsKey(idKereta)) {
        _groupedJadwal[idKereta] = { 'Pergi': [], 'Pulang': [] };
      }

      Map<String, dynamic> jadwalLengkap = {
        ...jadwal,
        'nama_stasiun': stasiunInfo.namaStasiun,
      };

      // Masukkan ke Kelompok
      if (_groupedJadwal[idKereta]!.containsKey(arah)) {
         _groupedJadwal[idKereta]![arah]!.add(jadwalLengkap);
      } else {
         _groupedJadwal[idKereta]!['Pergi']!.add(jadwalLengkap);
      }
    }

    // Sorting Jam
    _groupedJadwal.forEach((key, value) {
      try {
        // Kita sort berdasarkan Jam Berangkat saja agar urut waktunya
        value['Pergi']!.sort((a, b) => (a['jam_berangkat']??'').compareTo(b['jam_berangkat']??''));
        value['Pulang']!.sort((a, b) => (a['jam_berangkat']??'').compareTo(b['jam_berangkat']??''));
      } catch (e) {
        print("Error sorting: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text("Daftar Jadwal Kereta"),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6D00)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _listKereta.length,
              itemBuilder: (context, index) {
                final kereta = _listKereta[index];
                final idKereta = kereta['id_kereta']?.toString() ?? '';
                final namaKereta = kereta['nama_kereta']?.toString() ?? 'Kereta Tanpa Nama';

                final jadwalKereta = _groupedJadwal[idKereta];

                if (jadwalKereta == null) return const SizedBox.shrink();

                return _buildKeretaCard(namaKereta, jadwalKereta);
              },
            ),
    );
  }

  Widget _buildKeretaCard(String namaKereta, Map<String, List<Map<String, dynamic>>> jadwal) {
    bool adaPergi = jadwal['Pergi']!.isNotEmpty;
    bool adaPulang = jadwal['Pulang']!.isNotEmpty;

    if (!adaPergi && !adaPulang) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            namaKereta,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.white24, height: 24),

          if (adaPergi) ...[
            const Text("PERGI", style: TextStyle(color: Color(0xFFFF6D00), fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            ...jadwal['Pergi']!.map((j) => _buildRowJadwal(j)),
          ],

          if (adaPulang) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),
            const Text("PULANG", style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 8),
            ...jadwal['Pulang']!.map((j) => _buildRowJadwal(j)),
          ]
        ],
      ),
    );
  }

  Widget _buildRowJadwal(Map<String, dynamic> jadwal) {
    String jam = jadwal['jam_berangkat']?.toString() ?? '-';
    if (jam.length > 5) jam = jam.substring(0, 5);
    String namaStasiun = jadwal['nama_stasiun'] ?? '?';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(namaStasiun, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(jam, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}