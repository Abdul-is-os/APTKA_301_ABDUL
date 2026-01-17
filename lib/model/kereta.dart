class Kereta {
  final String idKereta;
  final String namaKereta;

  Kereta({required this.idKereta, required this.namaKereta});

  factory Kereta.fromJson(Map<String, dynamic> json) {
    return Kereta(
      idKereta: json['id_kereta'],
      namaKereta: json['nama_kereta'],
    );
  }
}