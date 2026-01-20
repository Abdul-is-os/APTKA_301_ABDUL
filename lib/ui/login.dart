import 'package:flutter/material.dart';
import 'register.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  void _login(bool isGuest) {
    // Navigasi ke Dashboard
    // Kita kirim parameter 'isGuest' agar Dashboard tahu status user
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage(isGuest: isGuest)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF1E1E1E);
    final Color fieldColor = const Color(0xFF2C2C2C);
    final Color orangeColor = const Color(0xFFFF6D00);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- LOGO / ICON ---
              Icon(Icons.train, size: 80, color: orangeColor),
              const SizedBox(height: 16),
              const Text(
                "APTKA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                "Aplikasi Pemesanan Tiket Kereta",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 48),

              // --- FORM INPUT ---
              _buildTextField(
                label: "Email / Username",
                icon: Icons.person_outline,
                fieldColor: fieldColor,
                isPassword: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Password",
                icon: Icons.lock_outline,
                fieldColor: fieldColor,
                isPassword: true,
              ),

              const SizedBox(height: 24),

              // --- TOMBOL LOGIN ---
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () => _login(false), // false = User Login Beneran
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: const Text(
                    "MASUK",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- TOMBOL TAMU (GUEST) ---
              SizedBox(
                height: 55,
                child: OutlinedButton(
                  onPressed: () => _login(true), // true = Tamu
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Masuk sebagai Tamu"),
                ),
              ),

              const SizedBox(height: 32),

              // --- LINK REGISTER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                    },
                    child: Text(
                      "Daftar Sekarang",
                      style: TextStyle(color: orangeColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Color fieldColor,
    required bool isPassword,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        obscureText: isPassword ? !_isPasswordVisible : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}