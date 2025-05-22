import 'package:flutter/material.dart';
import 'package:traffic_department/screens/staff/auth/staff_portal_screen.dart';

class ChangePasswordinScreen extends StatefulWidget {
  const ChangePasswordinScreen({super.key});

  @override
  State<ChangePasswordinScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordinScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showCurrent = false;
  bool showNew = false;
  bool showConfirm = false;

  void _submit() {
    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      _showMessage('يرجى تعبئة جميع الحقول', false);
      return;
    }

    if (newPass != confirm) {
      _showMessage('كلمة المرور الجديدة وتأكيدها غير متطابقين', false);
      return;
    }

    if (newPass == current) {
      _showMessage('كلمة المرور الجديدة يجب أن تختلف عن الحالية', false);
      return;
    }

    _showMessage('تم تغيير كلمة المرور بنجاح', true);

    setState(() {
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    });
  }

  void _showMessage(String message, bool success) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            backgroundColor:
                success ? Colors.green.shade50 : Colors.red.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Row(
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: success ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: success ? Colors.green : Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); 
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StaffPortalScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تغيير كلمة المرور',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF102542),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildPasswordField(
                controller: currentPasswordController,
                label: 'كلمة المرور الحالية',
                show: showCurrent,
                toggle: () => setState(() => showCurrent = !showCurrent),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: newPasswordController,
                label: 'كلمة المرور الجديدة',
                show: showNew,
                toggle: () => setState(() => showNew = !showNew),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: confirmPasswordController,
                label: 'تأكيد كلمة المرور الجديدة',
                show: showConfirm,
                toggle: () => setState(() => showConfirm = !showConfirm),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF102542),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: _submit,
                icon: const Icon(Icons.lock_reset_rounded),
                label: const Text('تغيير كلمة المرور'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool show,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !show,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(show ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
      ),
    );
  }
}
