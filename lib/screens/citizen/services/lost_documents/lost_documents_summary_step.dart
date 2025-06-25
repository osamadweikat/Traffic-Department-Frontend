import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LostDocumentsSummaryStep extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(double, bool) onFeesCalculated;

  const LostDocumentsSummaryStep({
    super.key,
    required this.formData,
    required this.onFeesCalculated,
  });

  @override
Widget build(BuildContext context) {
  final double baseFee = 30;
  final double bankFee = 2;
  final double total = baseFee + bankFee;
  final bool isShekel = true;

  onFeesCalculated(total, isShekel);

  final String docType = formData['documentType'] ?? '';

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 3,
    margin: const EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('request_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildInfoRow('owner_name'.tr(), formData['ownerName'] ?? '-'),

          if (docType != "رخصة قيادة")
            _buildInfoRow('plate_number'.tr(), formData['plateNumber'] ?? '-'),

          _buildInfoRow('document_type'.tr(), docType),
          _buildInfoRow('replacement_type'.tr(), formData['replacementType'] ?? '-'),

          const SizedBox(height: 12),
          Text('fees_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildInfoRow('replacement_base_fee'.tr(), '$baseFee ₪'),
          _buildInfoRow('replacement_bank_fee'.tr(), '$bankFee ₪'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('replacement_total_fee'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('$total ₪', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
