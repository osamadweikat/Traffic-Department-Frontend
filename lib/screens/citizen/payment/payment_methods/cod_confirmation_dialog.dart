import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/theme/app_theme.dart';
import 'package:traffic_department/widgets/success_dialog.dart';

class CODConfirmationDialog extends StatefulWidget {
  final VoidCallback onConfirmed;

  const CODConfirmationDialog({super.key, required this.onConfirmed});

  @override
  State<CODConfirmationDialog> createState() => _CODConfirmationDialogState();
}

class _CODConfirmationDialogState extends State<CODConfirmationDialog> with SingleTickerProviderStateMixin {
  bool agreed = false;
  late Timer _timer;
  int _remainingSeconds = 30;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _scaleAnimation = CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _timer.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  void _submitOrder() {
    _timer.cancel();
    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => SuccessDialog(
        onConfirm: () {
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil('/dashboard', (route) => false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/warning_animation2.json', width: 120, height: 120),
                const SizedBox(height: 20),
                Text(
                  "cod_warning_title".tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: "cod_warning_message_part1".tr()),
                      TextSpan(
                        text: "\n\u2022 ",
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "cod_warning_list1".tr(),
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "\n\u2022 ",
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "cod_warning_list2".tr(),
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "\n\u2022 ",
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "cod_warning_list3".tr(),
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _remainingSeconds / 30,
                        strokeWidth: 6,
                        color: Colors.red,
                        backgroundColor: Colors.red.withOpacity(0.2),
                      ),
                      Text(
                        "$_remainingSeconds",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: agreed,
                      activeColor: AppTheme.navy,
                      onChanged: (val) {
                        setState(() {
                          agreed = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "i_accept_terms_cod".tr(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.navy),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "cancel".tr(),
                          style: TextStyle(color: AppTheme.navy, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: agreed ? _submitOrder : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.navy,
                          disabledBackgroundColor: Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          "confirm_order".tr(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
