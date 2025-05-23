import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenWeb extends StatefulWidget {
  const LoginScreenWeb({super.key});

  @override
  State<LoginScreenWeb> createState() => _LoginScreenWebState();
}

class _LoginScreenWebState extends State<LoginScreenWeb> with SingleTickerProviderStateMixin {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<void> saveLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final formatted =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour}:${now.minute}";
    await prefs.setString('last_login', formatted);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Icon(Icons.person, size: 80, color: Color(0xFF002D5B)),
                    const SizedBox(height: 20),
                    const Text(
                      "تسجيل الدخول",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(_idController, "رقم الهوية", Icons.badge, TextInputType.number),
                    const SizedBox(height: 16),
                    _buildTextField(_passwordController, "كلمة المرور", Icons.lock, null, obscure: true),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await saveLastLogin();
                          Navigator.pushReplacementNamed(context, '/citizen-dashboard');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: const Color(0xFF002D5B),
                        ),
                        child: const Text(
                          'دخول',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('لا تملك حساب؟ سجل الآن'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      TextInputType? keyboardType,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
