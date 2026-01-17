class Stasiun {
  final String kodeStasiun;
  final String namaStasiun;
  final String kota;

  Stasiun({
    required this.kodeStasiun,
    required this.namaStasiun,
    required this.kota,
  });

  factory Stasiun.fromJson(Map<String, dynamic> json) {
    return Stasiun(
      kodeStasiun: json['kode_stasiun'] ?? '',
      namaStasiun: json['nama_stasiun'] ?? '',
      kota: json['kota'] ?? '',
    );
  }
}