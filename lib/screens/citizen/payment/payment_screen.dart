import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' as ui;
import '../../../theme/app_theme.dart';
import '../services/license_renewal/license_payment_view.dart';

class PaymentScreen extends StatelessWidget {
  final String transactionType; 

  const PaymentScreen({super.key, required this.transactionType});

  @override
  Widget build(BuildContext context) {
    Widget paymentView;

    switch (transactionType) {
      case 'license_renewal':
        paymentView = const LicensePaymentView();
        break;
      default:
        paymentView = Center(
          child: Text(
            'no_payment_view_found'.tr(),
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        );
    }

    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('payment_title'.tr()),
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: paymentView,
        ),
      ),
    );
  }
}
