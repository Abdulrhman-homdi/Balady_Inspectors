import 'package:flutter/material.dart';
import 'main_shell.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Controllers
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  // دالة تسجيل الدخول
  void _handleLogin(BuildContext context) {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // تحقق تجريبي
    if (username == "admin" && password == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("اسم المستخدم أو كلمة المرور غير صحيحة")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leadingWidth: 100,

        leading: Center(
          child: TextButton(
            onPressed: () {},

            child: const Text(
              "العربية",

              style: TextStyle(
                color: Color(0xFF2D9373),
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSansArabic',
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            const SizedBox(height: 10),

            // الشعار
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',

                    height: 120,

                    fit: BoxFit.contain,

                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.account_balance,
                      size: 80,
                      color: Color(0xFF2D9373),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "اسم الأمانة باللغة العربية",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansArabic',
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),

                    width: 40,
                    height: 2.5,

                    decoration: BoxDecoration(
                      color: const Color(0xFF2D9373),

                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const Text(
                    "Name of Municipality in English",

                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontFamily: 'IBMPlexSansArabic',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // العنوان
            const Text(
              "تسجيل الدخول",

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSansArabic',
              ),
            ),

            const Text(
              "يجب عليك تسجيل الدخول في منصة مراقبة البلاغات",

              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'IBMPlexSansArabic',
              ),
            ),

            const SizedBox(height: 32),

            // اسم المستخدم
            _buildLabel("اسم المستخدم"),

            _buildTextField(
              controller: _usernameController,
              hint: "ادخل اسم المستخدم الخاص بك",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 20),

            // كلمة المرور
            _buildLabel("كلمة المرور"),

            _buildTextField(
              controller: _passwordController,
              hint: "ادخل كلمة المرور الخاصة بك",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 40),

            // زر تسجيل الدخول
            SizedBox(
              width: double.infinity,
              height: 56,

              child: ElevatedButton(
                onPressed: () {
                  _handleLogin(context);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D9373),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  elevation: 0,
                ),

                child: const Text(
                  "تسجيل الدخول",

                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBMPlexSansArabic',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                "أو",

                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'IBMPlexSansArabic',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // الدخول كزائر
            Center(
              child: TextButton(
                onPressed: () {},

                child: const Text(
                  "الدخول كزائر",

                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontFamily: 'IBMPlexSansArabic',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Text(
        text,

        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'IBMPlexSansArabic',
        ),
      ),
    );
  }

  // TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,

      obscureText: isPassword,

      textAlign: TextAlign.right,

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),

        suffixIcon: Icon(icon, color: Colors.grey),

        filled: true,

        fillColor: const Color(0xFFF5F5F5),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide.none,
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
      ),
    );
  }
}
