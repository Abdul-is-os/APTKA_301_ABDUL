import 'package:flutter/material.dart';

class PemesananPage extends StatefulWidget {
  final Map<String, dynamic> tiket; // Data tiket yang dipilih dari halaman sebelumnya

  const PemesananPage({super.key, required this.tiket});

  @override
  State<PemesananPage> createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage> {
  // Controller untuk input text
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  String _tipePenumpang = 'Dewasa'; // Default value dropdown

  @override
  Widget build(BuildContext context) {
    // Palet Warna
    final Color bgColor = const Color(0xFF1E1E1E);
    final Color fieldColor = const Color(0xFF2C2C2C);
    final Color orangeColor = const Color(0xFFFF6D00);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Pemesanan"),
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Singkat Tiket (Opsional, agar user tau apa yang dipesan)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: orangeColor.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.train, color: orangeColor),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.tiket['nama_kereta'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("${widget.tiket['jam_berangkat']} - ${widget.tiket['jam_tiba']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),

            // --- FORM INPUT PENUMPANG ---
            
            // 1. ID Penumpang
            _buildLabel("ID Penumpang"),
            _buildTextField(
              controller: _idController,
              hint: "Masukkan No. KTP / ID",
              fieldColor: fieldColor,
            ),
            
            const SizedBox(height: 16),

            // 2. Nama Penumpang
            _buildLabel("Nama Penumpang"),
            _buildTextField(
              controller: _namaController,
              hint: "Masukkan Nama Lengkap",
              fieldColor: fieldColor,
            ),

            const SizedBox(height: 16),

            // 3. Tipe Penumpang (Dropdown)
            _buildLabel("Tipe Penumpang"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _tipePenumpang,
                  dropdownColor: const Color(0xFF333333),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  items: ['Dewasa', 'Anak-anak', 'Lansia'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _tipePenumpang = newValue!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 4. Tombol Pilih Kursi
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Logika lanjut nanti (misal simpan ke database atau pilih kursi)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fitur Denah Kursi akan dibuat selanjutnya"))
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: fieldColor, // Menggunakan warna gelap sesuai referensi
                  side: const BorderSide(color: Colors.white24), // Border tipis
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Pilih Kursi",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }

  // Widget Helper Text Field
  Widget _buildTextField({required TextEditingController controller, required String hint, required Color fieldColor}) {
    return Container(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), fontWeight: FontWeight.normal),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}