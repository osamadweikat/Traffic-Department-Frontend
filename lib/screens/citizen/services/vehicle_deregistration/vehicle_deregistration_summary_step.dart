import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'vehicle_deregistration_fees_helper.dart';

class VehicleDeregistrationSummaryStep extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(double, bool) onFeesCalculated;

  const VehicleDeregistrationSummaryStep({
    super.key,
    required this.formData,
    required this.onFeesCalculated,
  });

  @override
  Widget build(BuildContext context) {
    final fees = VehicleDeregistrationFeesHelper.calculateFees();
    onFeesCalculated(fees['total'], true);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('deregistration_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildInfoRow('owner_name'.tr(), formData['ownerName'] ?? '-'),
            _buildInfoRow('plate_number'.tr(), formData['plateNumber'] ?? '-'),
            const SizedBox(height: 12),
            Text('fees_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildInfoRow('bank_fee'.tr(), '${fees['bankFee']} ₪'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('total_fee'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${fees['total']} ₪', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'deregistration_notice'.tr(),
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
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