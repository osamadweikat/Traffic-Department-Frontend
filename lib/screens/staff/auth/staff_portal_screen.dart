import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:traffic_department/data/admin_login_data.dart';
import 'package:traffic_department/screens/admin/admin_dashboard_screen.dart';
import 'package:traffic_department/screens/staff/dashboard/staff_dashboard_screen.dart';
import 'package:traffic_department/screens/staff/dashboard/staff_dashboard_simple_screen.dart';
import 'change_password_screen.dart';

class StaffPortalScreen extends StatefulWidget {
  const StaffPortalScreen({super.key});

  @override
  State<StaffPortalScreen> createState() => _StaffPortalScreenState();
}

class _StaffPortalScreenState extends State<StaffPortalScreen> {
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

  void _handleLogin() async {
    String enteredId = idController.text.trim();
    String enteredPassword = passwordController.text.trim();

    final matchedEmployee = adminLoginData.firstWhere(
      (emp) =>
          emp['employeeId'] == enteredId && emp['password'] == enteredPassword,
      orElse: () => {},
    );

    if (matchedEmployee.isEmpty) {
      _showErrorDialog();
      return;
    }

    String role = matchedEmployee['role'];
    bool isPasswordChanged = matchedEmployee['isPasswordChanged'] ?? false;

    if (role == 'قديم') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StaffDashboardScreen()),
      );
    } else if (role == 'جديد') {
      if (!isPasswordChanged) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangePasswordScreen(employeeId: enteredId),
          ),
        );
        idController.clear();
        passwordController.clear();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StaffDashboardSimpleScreen()),
        );
      }
    } else if (role == 'أدمن') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
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
            child: Image.asset(
              'assets/images/staff_background2.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.05),
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
                        'بوابة الموظفين',
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
                          'تمكن هذه البوابة موظفي دائرة السير من الدخول إلى النظام ومتابعة الطلبات وتنفيذ المهام اليومية.',
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
                      'assets/animations/staff_portal.json',
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
