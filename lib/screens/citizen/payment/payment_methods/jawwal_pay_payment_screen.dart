import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/widgets/loading_overlay.dart';
import 'package:traffic_department/widgets/success_dialog.dart';

class JawwalPayPaymentScreen extends StatefulWidget {
  final int totalAmount;
  final String currencySymbol; 

  const JawwalPayPaymentScreen({super.key, required this.totalAmount, required this.currencySymbol});

  @override
  State<JawwalPayPaymentScreen> createState() => _JawwalPayPaymentScreenState();
}

class _JawwalPayPaymentScreenState extends State<JawwalPayPaymentScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _onPayNow() async {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showErrorDialog("please_complete_fields".tr());
      return;
    }

    if (!phone.startsWith('059') || phone.length != 10) {
      _showErrorDialog("invalid_phone_number".tr());
      return;
    }

    showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const LoadingOverlay();
      },
    );

    await Future.delayed(const Duration(seconds: 10));

    Navigator.of(context, rootNavigator: true).pop(); 

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => SuccessDialog(
        onConfirm: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (route) => false);
        },
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (_) => AlertDialog(
        title: Text("error".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text("ok".tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("jawwal_pay_payment".tr()),
        backgroundColor: Colors.green.shade700,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/jawwalpay_logo.png",
              height: 200,
            ),
            const SizedBox(height: 30),
            Text(
              "pay_easy_with_jawwal".tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: phoneController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10), 
              ],
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                labelText: "phone_number".tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: "password".tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    "amount_to_pay".tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${widget.currencySymbol} ${widget.totalAmount}", 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onPayNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "pay_now".tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "phone_must_be_registered".tr(),
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
