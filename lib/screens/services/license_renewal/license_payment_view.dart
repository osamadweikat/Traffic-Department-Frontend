import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/payment/payment_methods/visa_payment_bottom_sheet.dart';
import 'package:traffic_department/screens/payment/payment_methods/paypal_payment_screen.dart';
import 'package:traffic_department/screens/payment/payment_methods/jawwal_pay_payment_screen.dart';
import 'package:traffic_department/widgets/payment_form_sheet.dart';
import 'package:traffic_department/widgets/payment_summary_card.dart';
import 'package:traffic_department/screens/payment/payment_methods/cod_confirmation_dialog.dart'; 
import '../../../../theme/app_theme.dart';

class LicensePaymentView extends StatefulWidget {
  const LicensePaymentView({super.key});

  @override
  State<LicensePaymentView> createState() => _LicensePaymentViewState();
}

class _LicensePaymentViewState extends State<LicensePaymentView> {
  String? selectedLicenseType;
  int? selectedDuration;
  String? selectedPaymentMethod;

  final Map<int, int> durationPrices = {
    2: 80,
    5: 200,
  };

  final List<String> topLicenseTypes = ['خصوصي', 'عمومي'];
  final List<String> bottomLicenseTypes = ['شحن خفيف', 'شحن ثقيل'];
  final List<String> paymentMethods = ['card', 'palpay', 'jawwalpay', 'cod'];

  int get basePrice => selectedDuration != null ? durationPrices[selectedDuration!]! : 0;
  int get total => basePrice + 2;

  void _onPay() {
    if (selectedLicenseType == null || selectedDuration == null || selectedPaymentMethod == null) {
      _showErrorDialog('please_complete_fields'.tr());
      return;
    }

    if (selectedPaymentMethod == 'cod') {
      _showCashOnDeliveryDialog();
    } else if (selectedPaymentMethod == 'card') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => VisaPaymentBottomSheet(
          onSubmit: (selectedCard) {},
        ),
      );
    } else if (selectedPaymentMethod == 'palpay') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaypalPaymentScreen(
            totalAmount: total, currencySymbol: '₪',
          ),
        ),
      );
    } else if (selectedPaymentMethod == 'jawwalpay') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => JawwalPayPaymentScreen(
            totalAmount: total, currencySymbol: '₪',
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => const PaymentFormSheet(),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('خطأ', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق', style: TextStyle(color: AppTheme.navy)),
          )
        ],
      ),
    );
  }

  void _showCashOnDeliveryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CODConfirmationDialog(
        onConfirmed: () {
          _showSuccessDialog('request_received_cod'.tr());
        },
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('نجاح', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق', style: TextStyle(color: AppTheme.navy)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('select_license_type'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: topLicenseTypes.map((type) => _buildLicenseOption(type)).toList(),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: bottomLicenseTypes.map((type) => _buildLicenseOption(type)).toList(),
                ),
                const SizedBox(height: 20),
                Text('select_duration'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: durationPrices.entries.map((entry) {
                    final isSelected = selectedDuration == entry.key;
                    return GestureDetector(
                      onTap: () => setState(() => selectedDuration = entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.navy.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppTheme.navy : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow: isSelected ? [BoxShadow(color: AppTheme.navy.withOpacity(0.15), blurRadius: 6)] : [],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${entry.key} ${'years'.tr()}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppTheme.navy : Colors.black)),
                            const SizedBox(height: 4),
                            Text('${entry.value} ₪', style: TextStyle(color: isSelected ? AppTheme.navy : Colors.grey.shade700)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Text('choose_payment_method'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...paymentMethods.map((method) {
                  IconData icon = Icons.credit_card;
                  String labelKey = '';
                  switch (method) {
                    case 'card':
                      icon = Icons.credit_card;
                      labelKey = 'payment_method_card';
                      break;
                    case 'palpay':
                      icon = Icons.account_balance_wallet_outlined;
                      labelKey = 'payment_method_palpay';
                      break;
                    case 'jawwalpay':
                      icon = Icons.phone_android;
                      labelKey = 'payment_method_jawwalpay';
                      break;
                    case 'cod':
                      icon = Icons.local_shipping;
                      labelKey = 'payment_method_cod';
                      break;
                  }
                  return Card(
                    elevation: selectedPaymentMethod == method ? 6 : 1,
                    color: selectedPaymentMethod == method ? AppTheme.navy.withOpacity(0.1) : null,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(icon, color: AppTheme.navy),
                      title: Text(labelKey.tr()),
                      trailing: Radio<String>(
                        value: method,
                        groupValue: selectedPaymentMethod,
                        onChanged: (val) => setState(() => selectedPaymentMethod = val),
                      ),
                      onTap: () => setState(() => selectedPaymentMethod = method),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                if (selectedLicenseType != null && selectedDuration != null)
                  PaymentSummaryCard(
                    transactionTitle: 'renew_driver_license'.tr(),
                    licenseType: selectedLicenseType!,
                    duration: selectedDuration!,
                    basePrice: basePrice,
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navy,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    selectedPaymentMethod == 'cod' ? 'submit_order'.tr() : 'pay_now'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLicenseOption(String type) {
    final isSelected = selectedLicenseType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedLicenseType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.navy.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.navy : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected ? [BoxShadow(color: AppTheme.navy.withOpacity(0.15), blurRadius: 6)] : [],
        ),
        child: Text(type, style: TextStyle(color: isSelected ? AppTheme.navy : Colors.black87)),
      ),
    );
  }
}
