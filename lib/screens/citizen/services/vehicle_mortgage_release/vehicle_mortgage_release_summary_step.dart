import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'vehicle_mortgage_release_fees_helper.dart';

class VehicleMortgageReleaseSummaryStep extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(double, bool) onFeesCalculated;

  const VehicleMortgageReleaseSummaryStep({
    super.key,
    required this.formData,
    required this.onFeesCalculated,
  });

  @override
  Widget build(BuildContext context) {
    final fees = VehicleMortgageReleaseFeesHelper.calculateFees();
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
            Text('mortgage_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildInfoRow('owner_name'.tr(), formData['ownerName'] ?? '-'),
            _buildInfoRow('plate_number'.tr(), formData['plateNumber'] ?? '-'),
            _buildInfoRow('mortgage_action_type'.tr(), (formData['isRelease'] ?? false) ? 'release'.tr() : 'mortgage'.tr()),
            const SizedBox(height: 12),
            Text('fees_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildInfoRow('mortgage_release_fee'.tr(), '${fees['serviceFee']} ₪'),
            _buildInfoRow('bank_fee'.tr(), '${fees['bankFee']} ₪'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('total_fee'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${fees['total']} ₪', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
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
