import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../model/stasiun.dart';
import '../service/api_service.dart';
import 'list_tiket.dart';

class CariTiketPage extends StatefulWidget {
  const CariTiketPage({super.key});

  @override
  State<CariTiketPage> createState() => _CariTiketPageState();
}

class _CariTiketPageState extends State<CariTiketPage> {
  final ApiService _apiService = ApiService();
  
  // Data State Form
  List<Stasiun> _stasiunList = [];
  String? _selectedAsal;
  String? _selectedTujuan;
  DateTime _selectedDate = DateTime.now();
  int _jumlahPenumpang = 1;

  @override
  void initState() {
    super.initState();
    _loadStasiun();
  }

  void _loadStasiun() async {
    try {
      final list = await _apiService.getStasiun();
      setState(() {
        _stasiunList = list;
      });
    } catch (e) {
      print(e);
    }
  }

  void _cariJadwal() {
    // 1. Validasi Input
    if (_selectedAsal == null || _selectedTujuan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih Asal & Tujuan dulu"))
      );
      return;
    }

    // 2. Navigasi ke Halaman Hasil (Membawa data inputan)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HasilPencarianPage(
          asal: _selectedAsal!,
          tujuan: _selectedTujuan!,
          tanggal: _selectedDate,
          penumpang: _jumlahPenumpang,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Palet Warna (Konsisten Dashboard)
    final Color bgColor = const Color(0xFF1E1E1E); 
    final Color cardColor = const Color(0xFF2C2C2C); 
    final Color orangeColor = const Color(0xFFFF6D00); 

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Cari Tiket", style: TextStyle(color: Colors.white)),
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- FORM INPUT ---
              
              // 1. ASAL
              _buildLabel("Dari"),
              _buildDropdownField(
                hint: "Pilih Stasiun Asal",
                value: _selectedAsal,
                icon: Icons.train_outlined,
                fieldColor: cardColor,
                onChanged: (val) => setState(() => _selectedAsal = val),
              ),

              const SizedBox(height: 16),

              // 2. TUJUAN
              _buildLabel("Ke"),
              _buildDropdownField(
                hint: "Pilih Stasiun Tujuan",
                value: _selectedTujuan,
                icon: Icons.train, 
                fieldColor: cardColor,
                onChanged: (val) => setState(() => _selectedTujuan = val),
              ),

              const SizedBox(height: 16),

              // 3. TANGGAL (Berangkat & Pulang)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Berangkat"),
                        _buildDatePicker(cardColor, isReturn: false),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Pulang"),
                        _buildDatePicker(cardColor, isReturn: true),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 4. PENUMPANG
              _buildLabel("Penumpang"),
              _buildPassengerField(cardColor),

              const SizedBox(height: 40),

              // 5. TOMBOL CARI (Navigasi)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _cariJadwal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
                    elevation: 2,
                  ),
                  child: const Text(
                    "Cari Kereta", 
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER (Tetap Sama) ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required IconData icon,
    required Color fieldColor,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: Colors.white10), 
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              Text(hint, style: const TextStyle(color: Colors.white70)),
            ],
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          dropdownColor: const Color(0xFF333333),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: _stasiunList.map((s) {
            return DropdownMenuItem(
              value: s.kodeStasiun,
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "${s.namaStasiun} (${s.kodeStasiun})",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDatePicker(Color fieldColor, {bool isReturn = false}) {
    return GestureDetector(
      onTap: () async {
        if (isReturn) return; 
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (picked != null) setState(() => _selectedDate = picked);
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
            const SizedBox(width: 12),
            Text(
              isReturn ? "-" : DateFormat('dd MMM').format(_selectedDate),
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: isReturn ? null : TextDecoration.none
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerField(Color fieldColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.person, color: Colors.white70, size: 20),
              SizedBox(width: 12),
              Text("Penumpang", style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
          Row(
            children: [
              _buildCounterBtn(Icons.remove, () {
                if (_jumlahPenumpang > 1) setState(() => _jumlahPenumpang--);
              }),
              SizedBox(width: 15, child: Center(child: Text("$_jumlahPenumpang", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
              _buildCounterBtn(Icons.add, () {
                setState(() => _jumlahPenumpang++);
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCounterBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white24,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}