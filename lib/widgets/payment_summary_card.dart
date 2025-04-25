import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PaymentSummaryCard extends StatelessWidget {
  final String transactionTitle;
  final String licenseType;
  final int duration;
  final int basePrice;
  final int fee;

  const PaymentSummaryCard({
    super.key,
    required this.transactionTitle,
    required this.licenseType,
    required this.duration,
    required this.basePrice,
    this.fee = 2,
  });

  int get total => basePrice + fee;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transactionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            _buildRow('license_type'.tr(), licenseType.tr()),
            _buildRow('renewal_duration'.tr(), '$duration ${'years'.tr()}'),
            _buildRow('base_cost'.tr(), '$basePrice ₪'),
            _buildRow('service_fee'.tr(), '$fee ₪'),
            const Divider(height: 24),
            _buildRow('total_amount'.tr(), '$total ₪', isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
