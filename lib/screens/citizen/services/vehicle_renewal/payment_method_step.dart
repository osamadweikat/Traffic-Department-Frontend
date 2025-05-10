import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/citizen/payment/payment_methods/cod_confirmation_dialog.dart';
import 'package:traffic_department/screens/citizen/payment/payment_methods/jawwal_pay_payment_screen.dart';
import 'package:traffic_department/screens/citizen/payment/payment_methods/paypal_payment_screen.dart';
import 'package:traffic_department/screens/citizen/payment/payment_methods/visa_payment_bottom_sheet.dart';
import '../../../../theme/app_theme.dart';

class PaymentMethodStep extends StatefulWidget {
  final double totalAmount;
  final bool isShekel; 

  const PaymentMethodStep({Key? key, required this.totalAmount, required this.isShekel}) : super(key: key);

  @override
  State<PaymentMethodStep> createState() => PaymentMethodStepState();
}

class PaymentMethodStepState extends State<PaymentMethodStep> {
  String? selectedPaymentMethod;

  final List<Map<String, dynamic>> paymentMethods = [
    {"title": "visa_mastercard", "value": "visa", "icon": Icons.credit_card},
    {"title": "palpay", "value": "palpay", "icon": Icons.account_balance_wallet},
    {"title": "jawwalpay", "value": "jawwalpay", "icon": Icons.phone_android},
    {"title": "cash_on_delivery", "value": "cod", "icon": Icons.money},
  ];

  Future<void> continueToSelectedPayment() async {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("please_select_payment_method".tr())),
      );
      return;
    }

    String currencySymbol = widget.isShekel ? "₪" : "JD"; 

    if (selectedPaymentMethod == "visa") {
      await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true,
        builder: (_) => VisaPaymentBottomSheet(
          onSubmit: (selectedCard) {},
        ),
      );
    } else if (selectedPaymentMethod == "palpay") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaypalPaymentScreen(
            totalAmount: widget.totalAmount.toInt(),
            currencySymbol: currencySymbol,
          ),
        ),
      );
    } else if (selectedPaymentMethod == "jawwalpay") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JawwalPayPaymentScreen(
            totalAmount: widget.totalAmount.toInt(),
            currencySymbol: currencySymbol,
          ),
        ),
      );
    } else if (selectedPaymentMethod == "cod") {
      showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (context) => CODConfirmationDialog(
          onConfirmed: () {},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('select_payment_method'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paymentMethods.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final method = paymentMethods[index];
            final isSelected = selectedPaymentMethod == method['value'];

            return GestureDetector(
              onTap: () => setState(() => selectedPaymentMethod = method['value']),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.navy : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  color: isSelected ? AppTheme.navy.withOpacity(0.05) : Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(method['icon'], color: isSelected ? AppTheme.navy : Colors.grey),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        tr(method['title']),
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? AppTheme.navy : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
