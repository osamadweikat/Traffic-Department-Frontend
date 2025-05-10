import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/citizen/services/ownership_transfer/ownership_fees_helper.dart';
import '../../../../theme/app_theme.dart';

class OwnershipSummaryStep extends StatefulWidget {
  final Map<String, dynamic> ownershipData;
  final Function(double, bool) onFeesCalculated;

  const OwnershipSummaryStep({
    super.key,
    required this.ownershipData,
    required this.onFeesCalculated,
  });

  @override
  State<OwnershipSummaryStep> createState() => _OwnershipSummaryStepState();
}

class _OwnershipSummaryStepState extends State<OwnershipSummaryStep> {
  late Map<String, dynamic> originalFees;
  late Map<String, dynamic> displayFees;
  bool isShekel = true;
  final double rate = 5.0;

  @override
  void initState() {
    super.initState();
    originalFees = OwnershipFeesHelper.calculateOwnershipFees(widget.ownershipData['fuelType']);
    displayFees = Map<String, dynamic>.from(originalFees); 
    widget.onFeesCalculated(displayFees['total'], isShekel);
  }

  void toggleCurrency() {
    setState(() {
      isShekel = !isShekel;
      if (isShekel) {
        displayFees = Map<String, dynamic>.from(originalFees);
      } else {
        displayFees = {
          'baseFee': (originalFees['baseFee'] / rate).toStringAsFixed(2),
          'bankFee': (originalFees['bankFee'] / rate).toStringAsFixed(2),
          'total': (originalFees['total'] / rate).toStringAsFixed(2),
        };
      }

      final total = double.tryParse(displayFees['total'].toString()) ?? 0;
      widget.onFeesCalculated(total, isShekel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = isShekel ? '₪' : 'JD';

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
                Text('transfer_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                _buildInfoRow('current_owner_name'.tr(), widget.ownershipData['currentOwnerName'] ?? '-'),
                _buildInfoRow('buyer_name'.tr(), widget.ownershipData['buyerName'] ?? '-'),
                _buildInfoRow('vehicle_type'.tr(), widget.ownershipData['vehicleType'] ?? '-'),
                _buildInfoRow('fuel_type'.tr(), widget.ownershipData['fuelType'] ?? '-'),
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
                _buildInfoRow('ownership_base_fee'.tr(), '${displayFees['baseFee']} $currencySymbol'),
                _buildInfoRow('ownership_bank_fee'.tr(), '${displayFees['bankFee']} $currencySymbol'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ownership_total_fee'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      '${displayFees['total']} $currencySymbol',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
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
