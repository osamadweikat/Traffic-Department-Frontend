import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/theme/app_theme.dart';
import 'package:traffic_department/widgets/loading_overlay.dart';
import 'package:traffic_department/widgets/success_dialog.dart';

class PaypalPaymentScreen extends StatefulWidget {
  final int totalAmount;
  final String currencySymbol; 

  const PaypalPaymentScreen({super.key, required this.totalAmount, required this.currencySymbol});

  @override
  State<PaypalPaymentScreen> createState() => _PaypalPaymentScreenState();
}

class _PaypalPaymentScreenState extends State<PaypalPaymentScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _onLoginAndPay() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorDialog("please_complete_fields".tr());
      return;
    }

    showGeneralDialog(
      context: context,
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
            child: Text("ok".tr(), style: TextStyle(color: AppTheme.navy)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("paypal_payment".tr()),
        backgroundColor: AppTheme.navy,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  "assets/images/paypal_logo.png",
                  height: 100,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: "email".tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.emailAddress,
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
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
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
                  onPressed: _onLoginAndPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "login_and_pay".tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
