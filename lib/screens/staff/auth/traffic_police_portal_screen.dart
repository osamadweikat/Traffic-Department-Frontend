import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TrafficPolicePortalScreen extends StatefulWidget {
  const TrafficPolicePortalScreen({super.key});

  @override
  State<TrafficPolicePortalScreen> createState() =>
      _TrafficPolicePortalScreenState();
}

class _TrafficPolicePortalScreenState extends State<TrafficPolicePortalScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.red.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red.shade700),
                const SizedBox(width: 8),
                const Text(
                  'خطأ في تسجيل الدخول',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            content: const Text(
              'رقم الشرطي أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حسناً', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _handleLogin() {
    String enteredId = idController.text.trim();
    String enteredPassword = passwordController.text.trim();

    if (enteredId == '999999' && enteredPassword == 'police999') {
      Navigator.pushReplacementNamed(context, '/traffic_police_dashboard');
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFEAEFF7,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Transform.scale(
                scale: 0.9,
                child: Image.asset(
                  'assets/images/traffic_police_background.png', 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/traffic_police_logo.png', 
                          height: 80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '🚔 بوابة شرطة المرور',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B3D91),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'تمكن هذه البوابة عناصر شرطة المرور من تسجيل الدخول للوصول إلى نظام مخالفات السير وإدارة الحالات والبلاغات.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الشرطي',
                          prefixIcon: Icon(Icons.badge),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B3D91),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'دخول إلى بوابة شرطة المرور',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Lottie.asset(
                      'assets/animations/traffic_police_portal.json',
                      height: 600, 
                      fit:
                          BoxFit
                              .contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
