import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../theme/app_theme.dart';

class RequestSummaryStep extends StatefulWidget {
  final Map<String, dynamic> vehicleInfoData;
  final void Function(double amount, bool isShekel) onAmountCalculated; 

  const RequestSummaryStep({
    Key? key,
    required this.vehicleInfoData,
    required this.onAmountCalculated,
  }) : super(key: key);

  @override
  State<RequestSummaryStep> createState() => _RequestSummaryStepState();
}

class _RequestSummaryStepState extends State<RequestSummaryStep> {
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
    final vehicleType = widget.vehicleInfoData['vehicleType'];
    final fuelType = widget.vehicleInfoData['fuelType'];
    final engineCapacity = widget.vehicleInfoData['engineCapacity'] as int;
    final productionYear = widget.vehicleInfoData['productionYear'] as int;
    final weight = widget.vehicleInfoData['weight'] as int?;
    final passengerCount = widget.vehicleInfoData['passengerCount'] as int?;

    final currentYear = DateTime.now().year;
    final vehicleAge = currentYear - productionYear;

    double fee = 0;

    if (vehicleType == 'خصوصي' && fuelType != 'ديزل') {
      if (engineCapacity <= 1000) {
        fee = vehicleAge <= 3 ? 80 : (vehicleAge <= 8 ? 75 : 60);
      } else if (engineCapacity <= 2000) {
        fee = vehicleAge <= 3 ? 120 : (vehicleAge <= 8 ? 115 : 110);
      } else if (engineCapacity <= 3000) {
        fee = vehicleAge <= 3 ? 240 : (vehicleAge <= 8 ? 220 : 200);
      } else {
        fee = vehicleAge <= 3 ? 300 : (vehicleAge <= 8 ? 270 : 220);
      }
    } else if (vehicleType == 'خصوصي' && fuelType == 'ديزل') {
      fee = 500;
    } else if (vehicleType == 'عمومي') {
      fee = fuelType == 'ديزل' ? 100 : 50;
    } else if (vehicleType == 'شحن خفيف' || vehicleType == 'شحن ثقيل') {
      if (weight != null) {
        if (weight <= 16000) {
          fee = 180;
        } else if (weight <= 20000) {
          fee = 230;
        } else {
          fee = 330;
        }
      } else {
        fee = 180;
      }
    } else if (vehicleType == 'مركبة تأجير') {
      if (passengerCount != null) {
        if (passengerCount <= 4) {
          fee = fuelType == 'ديزل' ? 60 : 15;
        } else {
          fee = fuelType == 'ديزل' ? 100 : 20;
        }
      } else {
        fee = 100;
      }
    } else if (vehicleType == 'مقطورة') {
      if (weight != null) {
        if (weight <= 4000) {
          fee = 8;
        } else if (weight <= 8000) {
          fee = 15;
        } else {
          fee = 30;
        }
      } else {
        fee = 8;
      }
    } else if (vehicleType == 'جرار') {
      fee = fuelType == 'ديزل' ? 50 : 20;
    } else if (vehicleType == 'دراجة نارية') {
      if (engineCapacity <= 50) {
        fee = 5;
      } else if (engineCapacity <= 150) {
        fee = 15;
      } else {
        fee = 30;
      }
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
                _buildInfoRow('vehicle_number'.tr(), widget.vehicleInfoData['vehicleNumber']),
                _buildInfoRow('vehicle_type'.tr(), widget.vehicleInfoData['vehicleType']),
                _buildInfoRow('fuel_type'.tr(), widget.vehicleInfoData['fuelType']),
                _buildInfoRow('engine_capacity'.tr(), '${widget.vehicleInfoData['engineCapacity']} cc'),
                _buildInfoRow('production_year'.tr(), widget.vehicleInfoData['productionYear'].toString()),
                if (widget.vehicleInfoData['weight'] != null)
                  _buildInfoRow('vehicle_weight'.tr(), '${widget.vehicleInfoData['weight']} كغ'),
                if (widget.vehicleInfoData['passengerCount'] != null)
                  _buildInfoRow('passenger_count'.tr(), widget.vehicleInfoData['passengerCount'].toString()),
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
