import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  final bool isGuest; 
  const SettingsPage({super.key, required this.isGuest});

  // Logika Logout dipindah ke sini
  void _handleLogout(BuildContext context) async {
    // Tampilkan konfirmasi dialog dulu agar tidak kepencet
    bool confirm = await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text("Konfirmasi Keluar", style: TextStyle(color: Colors.white)),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Keluar", style: TextStyle(color: Colors.white)),
          ),
        ],
      )
    ) ?? false;

    if (!confirm) return;

    if (!isGuest) {
      await FirebaseAuth.instance.signOut();
    }
    if (context.mounted) {
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN 1: TAMPILAN ---
            _buildSectionHeader("TAMPILAN & APLIKASI"),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.dark_mode,
                    iconColor: Colors.purpleAccent,
                    title: "Mode Gelap",
                    trailing: Switch(
                      value: true, // Dummy: Selalu aktif karena app kita dark mode
                      onChanged: (val) {}, 
                      activeColor: const Color(0xFFFF6D00),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.white10, indent: 56),
                  _buildListTile(
                    icon: Icons.language,
                    iconColor: Colors.blueAccent,
                    title: "Bahasa",
                    subtitle: "Indonesia",
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- BAGIAN 2: INFORMASI ---
            _buildSectionHeader("INFORMASI"),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.info_outline,
                    iconColor: Colors.orangeAccent,
                    title: "Tentang Aplikasi",
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ),
                  const Divider(height: 1, color: Colors.white10, indent: 56),
                   _buildListTile(
                    icon: Icons.verified_outlined, // Ikon Check
                    iconColor: Colors.greenAccent,
                    title: "Versi Aplikasi",
                    trailing: const Text("v1.0.0", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- TOMBOL LOGOUT ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _handleLogout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1), // Merah transparan
                  foregroundColor: Colors.red, // Teks merah
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  side: BorderSide(color: Colors.red.withOpacity(0.5))
                ),
                child: const Text("Keluar Akun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Judul Bagian (Kecil di atas kotak)
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }

  // Widget Helper untuk Item List
  Widget _buildListTile({required IconData icon, required Color iconColor, required String title, String? subtitle, required Widget trailing}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)) : null,
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () {}, // Efek klik
    );
  }
}