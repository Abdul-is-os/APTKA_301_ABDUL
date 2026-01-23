import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- 1. Fungsi Simpan Pesanan (Auto Seat) ---
  Future<void> buatPesanan({
    required String customId,
    required Map<String, dynamic> detailTiket,
    required String namaPenumpang,
    required String noIdentitas,
    required String tipePenumpang,
  }) async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception("User belum login");
    // Generate Kursi Otomatis
    String gerbong = "G${Random().nextInt(4) + 1}";
    String baris = "${Random().nextInt(10) + 1}";
    String posisi = Random().nextBool() ? "A" : "B";
    String kursiOtomatis = "$gerbong-$baris$posisi";

    // Simpan ke Firestore
    await _firestore.collection('bookings').add({
      'id_booking': customId,
      'userId': user.uid,
      'tanggal_pemesanan': FieldValue.serverTimestamp(),
      'status': 'Lunas', 
      'detail_tiket': detailTiket,
      'penumpang': {
        'nama': namaPenumpang,
        'no_identitas': noIdentitas,
        'tipe': tipePenumpang,
        'kursi_otomatis': kursiOtomatis
      },
    });
  }

  // --- 2. Stream Data Tiket (Untuk Dashboard) ---
  Stream<QuerySnapshot> getTiketAktif() {
    User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('tanggal_pemesanan', descending: true)
        .snapshots();
  }
}