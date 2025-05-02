import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' as ui;
import 'package:traffic_department/screens/services/lost_documents/lost_documents_screen.dart';
import 'package:traffic_department/screens/services/ownership_transfer/ownership_transfer_screen.dart';
import 'package:traffic_department/screens/services/vehicle_conversion/vehicle_conversion_screen.dart';
import 'package:traffic_department/screens/services/vehicle_deregistration/vehicle_deregistration_screen.dart';
import 'package:traffic_department/screens/services/vehicle_modification/vehicle_modification_screen.dart';
import 'package:traffic_department/screens/services/vehicle_mortgage_release/vehicle_mortgage_release_screen.dart';
import 'package:traffic_department/screens/services/vehicle_renewal/vehicle_renewal_form.dart';
import '/theme/app_theme.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          context.locale.languageCode == 'ar'
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("vehicle_details").tr(),
          centerTitle: true,
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.directions_car,
                            color: AppTheme.navy,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${"plate_number".tr()}: ${vehicle["plateNumber"]}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                      buildRow(
                        "passenger_capacity".tr(),
                        vehicle["capacity"].toString(),
                      ),
                      buildRow("license_expiry".tr(), vehicle["expiry"]),
                      buildRow("insurance_status".tr(), vehicle["insurance"]),
                      const SizedBox(height: 15),
                      Text(
                        "violations".tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      vehicle["violations"].isEmpty
                          ? Text("no_violations".tr())
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                vehicle["violations"]
                                    .map<Widget>((v) => Text("• $v"))
                                    .toList(),
                          ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "available_services".tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  buildServiceTile(
                    context,
                    "service_renew_license".tr(),
                    Icons.update,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => VehicleLicenseRenewalScreen(
                                prefilledData: vehicle,
                              ),
                        ),
                      );
                    },
                  ),
                  buildServiceTile(
                    context,
                    "service_transfer_ownership".tr(),
                    Icons.transfer_within_a_station,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => OwnershipTransferScreen(
                                prefilledData: vehicle,
                              ),
                        ),
                      );
                    },
                  ),

                  buildServiceTile(
                    context,
                    "service_technical_modification".tr(),
                    Icons.build,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => VehicleModificationScreen(
                                prefilledData: {
                                  'plateNumber':
                                      vehicle['plateNumber'], 
                                },
                              ),
                        ),
                      );
                    },
                  ),

                  buildServiceTile(
                    context,
                    "service_replace_damaged_or_lost".tr(),
                    Icons.report_problem,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => LostDocumentsScreen(
                                prefilledData: {
                                  'ownerId': '1234567890',
                                  'ownerName': 'محمد أحمد خالد علي',
                                  'plateNumber': vehicle['plateNumber'],
                                },
                              ),
                        ),
                      );
                    },
                  ),

                  buildServiceTile(
                    context,
                    "service_deregister_vehicle".tr(),
                    Icons.car_crash,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => VehicleDeregistrationScreen(
                                prefilledData: {
                                  'ownerId': '1234567890',
                                  'ownerName': 'محمد أحمد خالد علي',
                                  'plateNumber': vehicle['plateNumber'],
                                },
                              ),
                        ),
                      );
                    },
                  ),

                  buildServiceTile(
                    context,
                    "service_mortgage_release".tr(),
                    Icons.lock,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => VehicleMortgageReleaseScreen(
                                prefilledData: {
                                  'ownerId': '1234567890',
                                  'ownerName': 'محمد أحمد خالد علي',
                                  'plateNumber': vehicle['plateNumber'],
                                },
                              ),
                        ),
                      );
                    },
                  ),

                  buildServiceTile(
                    context,
                    "service_vehicle_type_conversion".tr(),
                    Icons.sync_alt,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => VehicleConversionScreen(
                                prefilledData: {
                                  'ownerId': '1234567890',
                                  'ownerName': 'محمد أحمد خالد علي',
                                  'plateNumber': vehicle['plateNumber'],
                                },
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
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
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget buildServiceTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: AppTheme.navy),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
