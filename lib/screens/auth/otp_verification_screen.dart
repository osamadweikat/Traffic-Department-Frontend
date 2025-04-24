import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' as ui;
import '../../theme/app_theme.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String destination;
  final bool isEmail;

  const OTPVerificationScreen({super.key, required this.destination, this.isEmail = false});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  late Timer _timer;
  int _secondsRemaining = 60;
  bool _showOptions = false;
  String _statusText = '';

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _statusText = 'code_sent_to_phone'.tr();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 60;
      _showOptions = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _showOptions = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String _getCode() => _controllers.map((c) => c.text).join();

  void _verifyCode() {
    final code = _getCode();
    if (code.length == 6) {
      Navigator.pushNamed(context, '/change_password');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_enter_valid_code'.tr())),
      );
    }
  }

  void _resendToPhone() {
    setState(() {
      _statusText = 'code_resent_to_phone'.tr();
    });
    _startCountdown();
  }

  void _resendToEmail() {
    setState(() {
      _statusText = 'code_resent_to_email'.tr();
    });
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('verify_code_title'.tr()),
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _statusText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Text(
                  'otp_expiry_notice'.tr(),
                  style: TextStyle(color: Colors.deepOrange.shade400),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: ui.TextDirection.ltr,
                  children: List.generate(6, (i) {
                    return Container(
                      width: 45,
                      height: 55,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.navy),
                        color: Colors.white,
                      ),
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && i < 5) {
                            _focusNodes[i + 1].requestFocus();
                          } else if (value.isEmpty && i > 0) {
                            _focusNodes[i - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navy,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'confirm'.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                if (!_showOptions)
                  Text(
                    '${'wait'.tr()} $_secondsRemaining ${'seconds'.tr()}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                if (_showOptions) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'didnt_receive_code'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      TextButton.icon(
                        onPressed: _resendToPhone,
                        icon: const Icon(Icons.sms_outlined, size: 18, color: AppTheme.navy),
                        label: Text('resend_code_phone'.tr(), style: const TextStyle(fontSize: 14)),
                      ),
                      TextButton.icon(
                        onPressed: _resendToEmail,
                        icon: const Icon(Icons.email_outlined, size: 18, color: AppTheme.navy),
                        label: Text('resend_code_email'.tr(), style: const TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
