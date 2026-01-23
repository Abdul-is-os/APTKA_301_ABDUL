import 'package:flutter/material.dart';

class PetaLintasPage extends StatefulWidget {
  const PetaLintasPage({super.key});

  @override
  State<PetaLintasPage> createState() => _PetaLintasPageState();
}

class _PetaLintasPageState extends State<PetaLintasPage> {
  // --- DATA JALUR (Disimpan Langsung di Sini) ---
  final List<Map<String, dynamic>> _dataLintas = [
    {
      "id": 1,
      "nama": "Jalur Raya Kembang",
      "kereta": ["Kembang Express 1", "Kembang Express 2"]
    },
    {
      "id": 2,
      "nama": "Jalur Raya Tayu",
      "kereta": ["Tayu Express"]
    },
    {
      "id": 3,
      "nama": "Jalur Raya Bandung",
      "kereta": ["Bandung Express"]
    },
    {
      "id": 4,
      "nama": "Jalur Raya Parakan",
      "kereta": ["Parakan Express"]
    },
    {
      "id": 5,
      "nama": "Jalur Raya Ibukota 1",
      "kereta": ["Kembang Express 1", "Kembang Express 2", "Tayu Express", "Parakan Express"]
    },
    {
      "id": 51,
      "nama": "Jalur Raya Ibukota 2",
      "kereta": ["Bandung Express"]
    },
  ];

  // Variabel untuk menyimpan pilihan user (Default null / belum pilih)
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    // Default pilih jalur pertama (Opsional, hapus jika ingin kosong di awal)
    _selectedId = 1; 
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data kereta berdasarkan ID yang dipilih
    List<String> keretaAktif = [];
    if (_selectedId != null) {
      final selectedData = _dataLintas.firstWhere((e) => e['id'] == _selectedId);
      keretaAktif = List<String>.from(selectedData['kereta']);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text("Peta Lintas"),
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
            // --- 1. KOTAK GAMBAR PETA ---
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
                image: const DecorationImage(
                  image: AssetImage('assets/metromapmaker.png'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- 2. DROPDOWN LINTAS JALUR ---
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
                  hint: const Text("Pilih Lintas Jalur", style: TextStyle(color: Colors.grey)),
                  dropdownColor: const Color(0xFF2C2C2C),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  isExpanded: true,
                  items: _dataLintas.map((item) {
                    return DropdownMenuItem<int>(
                      value: item['id'],
                      child: Text(item['nama']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedId = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. DAFTAR KERETA (HASIL FILTER) ---
            const Text(
              "Daftar Kereta yang beroperasi:",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: keretaAktif.isEmpty
                  ? const Center(
                      child: Text("- Silakan pilih jalur -", style: TextStyle(color: Colors.grey)),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: keretaAktif.map((namaKereta) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.train, color: Color(0xFFFF6D00), size: 20),
                              const SizedBox(width: 12),
                              Text(
                                namaKereta,
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}