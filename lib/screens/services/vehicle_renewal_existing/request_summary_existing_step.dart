import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../theme/app_theme.dart';

class RequestSummaryExistingStep extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  final void Function(double amount, bool isShekel) onAmountCalculated;

  const RequestSummaryExistingStep({
    Key? key,
    required this.vehicle,
    required this.onAmountCalculated,
  }) : super(key: key);

  @override
  State<RequestSummaryExistingStep> createState() => _RequestSummaryExistingStepState();
}

class _RequestSummaryExistingStepState extends State<RequestSummaryExistingStep> {
  bool isShekel = false;
  double baseFee = 0.0;
  String currencySymbol = 'JD';

  @override
  void initState() {
    super.initState();
    baseFee = calculateFees();
    widget.onAmountCalculated(baseFee, isShekel);
  }

  double calculateFees() {
    final vehicleType = widget.vehicle['type'];
    final fuelType = widget.vehicle['fuel'];
    final capacity = widget.vehicle['capacity'] as int?;
    final year = int.tryParse(widget.vehicle['year'].toString()) ?? DateTime.now().year;

    final currentYear = DateTime.now().year;
    final vehicleAge = currentYear - year;

    double fee = 0;

    if (vehicleType == 'خصوصي' && fuelType != 'ديزل') {
      if (capacity != null && capacity <= 1000) {
        fee = vehicleAge <= 3 ? 80 : (vehicleAge <= 8 ? 75 : 60);
      } else if (capacity != null && capacity <= 2000) {
        fee = vehicleAge <= 3 ? 120 : (vehicleAge <= 8 ? 115 : 110);
      } else {
        fee = vehicleAge <= 3 ? 240 : (vehicleAge <= 8 ? 220 : 200);
      }
    } else if (vehicleType == 'خصوصي' && fuelType == 'ديزل') {
      fee = 500;
    } else if (vehicleType == 'عمومي') {
      fee = fuelType == 'ديزل' ? 100 : 50;
    } else if (vehicleType == 'شحن خفيف' || vehicleType == 'شحن ثقيل') {
      fee = 180;
    } else if (vehicleType == 'مركبة تأجير') {
      fee = fuelType == 'ديزل' ? 60 : 15;
    } else if (vehicleType == 'مقطورة') {
      fee = 8;
    } else if (vehicleType == 'جرار') {
      fee = fuelType == 'ديزل' ? 50 : 20;
    } else if (vehicleType == 'دراجة نارية') {
      fee = 30;
    } else {
      fee = 40;
    }

    return fee;
  }

  void toggleCurrency() {
    setState(() {
      if (isShekel) {
        baseFee = baseFee / 5;
        currencySymbol = 'JD';
      } else {
        baseFee = baseFee * 5;
        currencySymbol = '₪';
      }
      isShekel = !isShekel;
      widget.onAmountCalculated(baseFee, isShekel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('vehicle_info'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                _buildInfoRow('plate_number'.tr(), widget.vehicle['plateNumber']),
                _buildInfoRow('vehicle_type'.tr(), widget.vehicle['type']),
                _buildInfoRow('brand_model'.tr(), widget.vehicle['brand']),
                _buildInfoRow('fuel_type'.tr(), widget.vehicle['fuel']),
                _buildInfoRow('manufacture_year'.tr(), widget.vehicle['year'].toString()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('fees_details'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                _buildInfoRow('basic_license_fee'.tr(), '${baseFee.toStringAsFixed(2)} $currencySymbol'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('total'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${baseFee.toStringAsFixed(2)} $currencySymbol', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
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
            label: Text(isShekel ? 'عرض بالدينار' : 'تحويل إلى شيكل'),
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
