class Jadwal {
  final String idJadwal;
  final String idKereta;
  final String kodeStasiun;
  final String jamBerangkat;
  final int urutanSinggah;

  Jadwal({
    required this.idJadwal,
    required this.idKereta,
    required this.kodeStasiun,
    required this.jamBerangkat,
    required this.urutanSinggah,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      idJadwal: json['id_jadwal'],
      idKereta: json['id_kereta'],
      kodeStasiun: json['kode_stasiun'],
      jamBerangkat: json['jam_berangkat'],
      urutanSinggah: int.tryParse(json['urutan_singgah'].toString()) ?? 0,
    );
  }
}