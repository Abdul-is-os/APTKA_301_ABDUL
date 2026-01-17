import 'package:flutter/material.dart';
import '../model/stasiun.dart';
import '../service/api_service.dart';

class CariTiketPage extends StatefulWidget {
  const CariTiketPage({super.key});

  @override
  State<CariTiketPage> createState() => _CariTiketPageState();
}

class _CariTiketPageState extends State<CariTiketPage> {
  final ApiService _apiService = ApiService();
  
  List<Stasiun> _stasiunList = [];
  String? _selectedAsal;
  String? _selectedTujuan;
  List<Map<String, dynamic>> _hasilPencarian = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadStasiun();
  }

  void _loadStasiun() async {
    try {
      final list = await _apiService.getStasiun();
      setState(() { _stasiunList = list; });
    } catch (e) { print(e); }
  }

  void _cariJadwal() async {
    if (_selectedAsal == null || _selectedTujuan == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih Asal & Tujuan dulu")));
      return;
    }
    setState(() { _isLoading = true; _hasSearched = true; });
    try {
      final hasil = await _apiService.cariTiket(_selectedAsal!, _selectedTujuan!);
      setState(() { _hasilPencarian = hasil; _isLoading = false; });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = const Color(0xFF2C2C2C);
    final Color orangeColor = const Color(0xFFFF6D00);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text("Pesan Tiket Kereta"),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  _buildDropdown("Stasiun Asal", _selectedAsal, (val) => setState(() => _selectedAsal = val)),
                  const SizedBox(height: 16),
                  Icon(Icons.swap_vert, color: orangeColor),
                  const SizedBox(height: 16),
                  _buildDropdown("Stasiun Tujuan", _selectedTujuan, (val) => setState(() => _selectedTujuan = val)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _cariJadwal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text("Cari Kereta", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildResultList(cardColor, orangeColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF333333),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF6D00)), borderRadius: BorderRadius.all(Radius.circular(8))),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
      ),
      items: _stasiunList.map((s) => DropdownMenuItem(value: s.kodeStasiun, child: Text("${s.namaStasiun} (${s.kodeStasiun})", overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildResultList(Color cardColor, Color orangeColor) {
    if (!_hasSearched) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.train_outlined, size: 80, color: Colors.grey.shade800), const SizedBox(height: 10), const Text("Tentukan tujuan perjalananmu", style: TextStyle(color: Colors.grey))]));
    }
    if (_hasilPencarian.isEmpty && !_isLoading) {
      return const Center(child: Text("Jadwal tidak ditemukan", style: TextStyle(color: Colors.white)));
    }
    return ListView.builder(
      itemCount: _hasilPencarian.length,
      itemBuilder: (context, index) {
        final tiket = _hasilPencarian[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [Icon(Icons.train, color: orangeColor, size: 20), const SizedBox(width: 8), Text(tiket['nama_kereta'] ?? "Kereta", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))]),
                    const Text("Ekonomi", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(color: Colors.white10)),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(tiket['jam_berangkat'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text(_selectedAsal ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12))]),
                    Icon(Icons.arrow_forward, color: Colors.grey.shade600),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(tiket['jam_tiba'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text(_selectedTujuan ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12))]),
                ]),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: orangeColor, side: BorderSide(color: orangeColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text("Pilih"))),
              ],
            ),
          ),
        );
      },
    );
  }
}