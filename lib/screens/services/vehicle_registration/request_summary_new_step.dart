import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/services/vehicle_registration/vehicle_fees_helper.dart';
import '../../../theme/app_theme.dart';


class RequestSummaryNewStep extends StatefulWidget {
  final Map<String, dynamic> vehicleInfoData;
  final Function(double, bool) onAmountCalculated;

  const RequestSummaryNewStep({Key? key, required this.vehicleInfoData, required this.onAmountCalculated}) : super(key: key);

  @override
  State<RequestSummaryNewStep> createState() => _RequestSummaryNewStepState();
}

class _RequestSummaryNewStepState extends State<RequestSummaryNewStep> {
  bool isShekel = false;
  double totalAmount = 0.0;
  String currencySymbol = 'JD';

  late Map<String, dynamic> feesData;

  @override
  void initState() {
    super.initState();
    feesData = VehicleFeesHelper.calculateVehicleFees(widget.vehicleInfoData);
    totalAmount = feesData['total'] ?? 0.0;
    widget.onAmountCalculated(totalAmount, isShekel);
  }

  void toggleCurrency() {
  setState(() {
    if (isShekel) {
      totalAmount = totalAmount / 5;
      for (var item in feesData['details']) {
        item['amount'] = (item['amount'] / 5);
      }
      currencySymbol = 'JD';
    } else {
      totalAmount = totalAmount * 5;
      for (var item in feesData['details']) {
        item['amount'] = (item['amount'] * 5);
      }
      currencySymbol = '₪';
    }
    isShekel = !isShekel;
    widget.onAmountCalculated(totalAmount, isShekel);
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
                Text('vehicle_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                _buildInfoRow('vehicle_type'.tr(), widget.vehicleInfoData['vehicleType'] ?? '-'),
                _buildInfoRow('brand_model'.tr(), widget.vehicleInfoData['brandModel'] ?? '-'),
                _buildInfoRow('chassis_number'.tr(), widget.vehicleInfoData['chassisNumber'] ?? '-'),
                _buildInfoRow('engine_number'.tr(), widget.vehicleInfoData['engineNumber'] ?? '-'),
                _buildInfoRow('engine_capacity'.tr(), widget.vehicleInfoData['engineCapacity'] != null ? '${widget.vehicleInfoData['engineCapacity']} cc' : '-'),
                _buildInfoRow('fuel_type'.tr(), widget.vehicleInfoData['fuelType'] ?? '-'),
                if (widget.vehicleInfoData['weight'] != null)
                  _buildInfoRow('vehicle_weight'.tr(), '${widget.vehicleInfoData['weight']} kg'),
                if (widget.vehicleInfoData['passengerCapacity'] != null)
                  _buildInfoRow('passenger_count'.tr(), widget.vehicleInfoData['passengerCapacity'].toString()),
                _buildInfoRow('production_year'.tr(), widget.vehicleInfoData['manufactureYear']?.toString() ?? '-'),
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
                Text('fees_summary'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                ...List.generate(
                  feesData['details']?.length ?? 0,
                  (index) {
                    final detail = feesData['details'][index];
                    return _buildInfoRow(
                      detail['title'].toString().tr(),
                      '${detail['amount'].toStringAsFixed(2)} $currencySymbol',
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('total'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${totalAmount.toStringAsFixed(2)} $currencySymbol', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
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
          Flexible(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Flexible(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
