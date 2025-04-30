import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'modification_fees_helper.dart';
import '../../../theme/app_theme.dart';

class ModificationSummaryStep extends StatefulWidget {
  final Map<String, dynamic> modificationData;
  final Function(double, bool) onFeesCalculated;

  const ModificationSummaryStep({
    super.key,
    required this.modificationData,
    required this.onFeesCalculated,
  });

  @override
  State<ModificationSummaryStep> createState() => _ModificationSummaryStepState();
}

class _ModificationSummaryStepState extends State<ModificationSummaryStep> {
  late Map<String, dynamic> fees;
  bool isShekel = true;

  @override
  void initState() {
    super.initState();
    fees = ModificationFeesHelper.calculateFees(widget.modificationData['modificationType']);
    widget.onFeesCalculated(fees['total'], isShekel);
  }

  void toggleCurrency() {
    setState(() {
      isShekel = !isShekel;
      final rate = 5.0;
      final total = isShekel ? fees['total'] : (fees['total'] / rate);
      widget.onFeesCalculated(total, isShekel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currency = isShekel ? '₪' : 'JD';
    final total = isShekel ? fees['total'] : (fees['total'] / 5.0).toStringAsFixed(2);
    final base = isShekel ? fees['baseFee'] : (fees['baseFee'] / 5.0).toStringAsFixed(2);
    final bank = isShekel ? fees['bankFee'] : (fees['bankFee'] / 5.0).toStringAsFixed(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('modification_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                _buildInfoRow('modification_type'.tr(), widget.modificationData['modificationType'] ?? '-'),
                _buildInfoRow('vehicle_number'.tr(), widget.modificationData['vehicleNumber'] ?? '-'),
                _buildInfoRow('notes'.tr(), widget.modificationData['notes'] ?? '-'),
              ],
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('fees_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                _buildInfoRow('modification_base_fee'.tr(), '$base $currency'),
                _buildInfoRow('modification_bank_fee'.tr(), '$bank $currency'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('modification_total_fee'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('$total $currency', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            onPressed: toggleCurrency,
            icon: const Icon(Icons.currency_exchange),
            label: Text(isShekel ? 'show_in_jd'.tr() : 'convert_to_shekel'.tr()),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.navy),
              foregroundColor: AppTheme.navy,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      ],
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
