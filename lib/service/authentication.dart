import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- 1. FUNGSI REGISTER ---
  Future<User?> signUp({
    required String email,
    required String password,
    required String nama,
    required String telepon,
  }) async {
    try {
      // A. Buat Akun di Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // B. Simpan Biodata Tambahan ke Firestore (Database)
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'nama': nama,
          'email': email,
          'telepon': telepon,
          'created_at': DateTime.now().toIso8601String(),
          'role': 'member',
        }).catchError((error) {
            print("Gagal simpan database: $error");
            throw Exception("Gagal menyimpan biodata: $error"); 
        });
      }
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // --- 2. FUNGSI LOGIN ---
  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // --- 3. FUNGSI LOGOUT ---
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- 4. CEK USER SEDANG LOGIN ---
  User? getCurrentUser() {
    return _auth.currentUser;
  }
} 