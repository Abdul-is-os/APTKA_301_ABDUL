import 'package:flutter/material.dart';
import '../service/authentication.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller Input
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _handleRegister() async {
    // 1. Validasi Input
    if (_namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom wajib diisi!")),
      );
      return;
    }

    if (_passwordController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password konfirmasi tidak cocok!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Panggil Service SignUp
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        nama: _namaController.text.trim(),
        telepon: _phoneController.text.trim(),
      );

      if (mounted) {
        // 3. Berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Registrasi Berhasil! Silakan Login."),
          ),
        );
        Navigator.pop(context); // Kembali ke Login Page
      }
    } catch (e) {
      // 4. Gagal
      if (mounted) {
        String msg = "Terjadi Kesalahan: $e";
        if (e.toString().contains("email-already-in-use")) {
          msg = "Email sudah terdaftar!";
        } else if (e.toString().contains("weak-password")) {
          msg = "Password terlalu lemah (min 6 karakter)";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(msg)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF1E1E1E);
    final Color fieldColor = const Color(0xFF2C2C2C);
    final Color orangeColor = const Color(0xFFFF6D00);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Buat Akun Baru",
              style: TextStyle(
                  color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Silakan isi data diri untuk mendaftar",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            _buildTextField(
                controller: _namaController,
                label: "Nama Lengkap",
                icon: Icons.person,
                fieldColor: fieldColor),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email,
                fieldColor: fieldColor),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _phoneController,
                label: "Nomor Telepon",
                icon: Icons.phone,
                fieldColor: fieldColor),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock,
                fieldColor: fieldColor,
                isPassword: true),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _confirmPassController,
                label: "Konfirmasi Password",
                icon: Icons.lock_outline,
                fieldColor: fieldColor,
                isPassword: true),
            
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("DAFTAR",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color fieldColor,
    bool isPassword = false,
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
                      color: Colors.grey),
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