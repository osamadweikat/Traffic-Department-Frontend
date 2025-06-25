import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InspectionPortalScreen extends StatefulWidget {
  const InspectionPortalScreen({super.key});

  @override
  State<InspectionPortalScreen> createState() => _InspectionPortalScreenState();
}

class _InspectionPortalScreenState extends State<InspectionPortalScreen> {
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
              'رقم الموظف أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.',
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

    if (enteredId == '123456' && enteredPassword == 'inspection123') {
      Navigator.pushReplacementNamed(context, '/inspection_results');
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Transform.scale(
                scale: 0.88, 
                child: Image.asset(
                  'assets/images/inspection_background.png',
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
                          'assets/images/traffic_logo.png',
                          height: 80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'بوابة موظفي دائرة الفحص',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'تمكن هذه البوابة موظفي دائرة الفحص من تسجيل الدخول وإدارة نتائج الفحص النظري والعملي للمواطنين.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الموظف',
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
                            backgroundColor: const Color(0xFF1E3A5F),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'تسجيل الدخول',
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
                      'assets/animations/inspection_portal.json', 
                      height: 440,
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
