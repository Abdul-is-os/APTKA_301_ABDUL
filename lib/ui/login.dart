import 'package:flutter/material.dart';
import '../service/authentication.dart';
import 'dashboard.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller Input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password harus diisi!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Panggil Service Login
      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        // 2. Sukses -> Masuk Dashboard (Member)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const DashboardPage(isGuest: false)),
        );
      }
    } catch (e) {
      // 3. Gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Login Gagal! Periksa email dan password Anda."),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _guestLogin() {
    // Masuk Dashboard sebagai Tamu
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const DashboardPage(isGuest: true)),
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
              // Logo
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

              // Form Input
              _buildTextField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                  fieldColor: fieldColor,
                  isPassword: false),
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock_outline,
                  fieldColor: fieldColor,
                  isPassword: true),

              const SizedBox(height: 24),

              // Tombol Login
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "MASUK",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Tamu
              SizedBox(
                height: 55,
                child: OutlinedButton(
                  onPressed: _guestLogin,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Masuk sebagai Tamu"),
                ),
              ),

              const SizedBox(height: 32),

              // Link Daftar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? ",
                      style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: Text(
                      "Daftar Sekarang",
                      style: TextStyle(
                          color: orangeColor, fontWeight: FontWeight.bold),
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
    required TextEditingController controller,
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
        controller: controller,
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
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
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