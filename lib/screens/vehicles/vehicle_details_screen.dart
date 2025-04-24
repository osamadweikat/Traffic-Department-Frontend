import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' as ui;
import '/theme/app_theme.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("vehicle_details").tr(),
          centerTitle: true,
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_car, color: AppTheme.navy),
                      const SizedBox(width: 8),
                      Text("${"plate_number".tr()}: ${vehicle["plateNumber"]}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  buildRow("vehicle_type".tr(), vehicle["type"]),
                  buildRow("brand_model".tr(), vehicle["brand"]),
                  buildRow("manufacture_year".tr(), vehicle["year"]),
                  buildRow("color".tr(), vehicle["color"]),
                  buildRow("chassis_number".tr(), vehicle["chassis"]),
                  buildRow("engine_number".tr(), vehicle["engine"]),
                  buildRow("fuel_type".tr(), vehicle["fuel"]),
                  buildRow("passenger_capacity".tr(), vehicle["capacity"].toString()),
                  buildRow("license_expiry".tr(), vehicle["expiry"]),
                  buildRow("insurance_status".tr(), vehicle["insurance"]),

                  const SizedBox(height: 15),
                  Text("violations".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),

                  vehicle["violations"].isEmpty
                      ? Text("no_violations".tr())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: vehicle["violations"].map<Widget>((v) => Text("• $v")).toList(),
                        ),

                  const SizedBox(height: 30),
                  Text("available_services".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  buildServiceButton(context, "service_renew_license".tr(), Icons.update, () {}),
                  buildServiceButton(context, "service_transfer_ownership".tr(), Icons.transfer_within_a_station, () {}),
                  buildServiceButton(context, "service_change_color".tr(), Icons.color_lens, () {}),
                  buildServiceButton(context, "service_replace_plate".tr(), Icons.report_problem, () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget buildServiceButton(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 20),
          label: Text(title),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.yellow,
            foregroundColor: AppTheme.navy,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
