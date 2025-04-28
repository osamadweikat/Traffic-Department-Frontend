import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../theme/app_theme.dart';

class VehicleInfoDisplayStep extends StatefulWidget {
  final Map<String, dynamic> vehicleInfoData;
  final void Function(bool confirmed) onStepCompleted;

  const VehicleInfoDisplayStep({super.key, required this.vehicleInfoData, required this.onStepCompleted});

  @override
  State<VehicleInfoDisplayStep> createState() => _VehicleInfoDisplayStepState();
}

class _VehicleInfoDisplayStepState extends State<VehicleInfoDisplayStep> {
  bool isConfirmed = false;

  void _confirmInfo(bool? value) {
    setState(() {
      isConfirmed = value ?? false;
    });

    widget.onStepCompleted(isConfirmed);
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
                _buildInfoRow('vehicle_number'.tr(), widget.vehicleInfoData['plateNumber']),
                _buildInfoRow('vehicle_type'.tr(), widget.vehicleInfoData['type']),
                _buildInfoRow('brand_model'.tr(), widget.vehicleInfoData['brand']),
                _buildInfoRow('manufacture_year'.tr(), widget.vehicleInfoData['year'].toString()),
                _buildInfoRow('color'.tr(), widget.vehicleInfoData['color']),
                _buildInfoRow('chassis_number'.tr(), widget.vehicleInfoData['chassis']),
                _buildInfoRow('engine_number'.tr(), widget.vehicleInfoData['engine']),
                _buildInfoRow('fuel_type'.tr(), widget.vehicleInfoData['fuel']),
                _buildInfoRow('passenger_capacity'.tr(), widget.vehicleInfoData['capacity'].toString()),
                _buildInfoRow('license_expiry'.tr(), widget.vehicleInfoData['expiry']),
                _buildInfoRow('insurance_status'.tr(), widget.vehicleInfoData['insurance']),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: isConfirmed,
              activeColor: AppTheme.navy,
              onChanged: _confirmInfo,
            ),
            Expanded(
              child: Text(
                "confirm_vehicle_info".tr(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
