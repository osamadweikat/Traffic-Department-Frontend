import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' as ui;
import '/theme/app_theme.dart';
import 'package:traffic_department/screens/citizen/services/lost_documents/lost_documents_screen.dart';
import 'package:traffic_department/screens/citizen/services/ownership_transfer/ownership_transfer_screen.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_conversion/vehicle_conversion_screen.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_deregistration/vehicle_deregistration_screen.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_modification/vehicle_modification_screen.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_mortgage_release/vehicle_mortgage_release_screen.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_renewal/vehicle_renewal_form.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  String? expandedService;

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;
    final bool hasViolations = vehicle['violations'].isNotEmpty;
    final bool isExpired = DateTime.tryParse(vehicle['expiry'] ?? '')?.isBefore(DateTime.now()) ?? false;
    final bool isPublic = vehicle['type'] == 'عمومي';
    final bool insuranceExpired = vehicle['insurance'] == 'منتهية';

    final List<_ServiceItem> serviceList = [
      if (!hasViolations && isExpired)
        _ServiceItem(
          id: 'renew',
          title: 'service_renew_license'.tr(),
          icon: Icons.car_repair,
          highlight: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VehicleLicenseRenewalScreen(prefilledData: vehicle)),
          ),
        ),
      if (!hasViolations)
        ...[
          _ServiceItem(
            id: 'transfer',
            title: 'service_transfer_ownership'.tr(),
            icon: Icons.swap_horiz,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OwnershipTransferScreen(prefilledData: vehicle)),
            ),
          ),
          _ServiceItem(
            id: 'modification',
            title: 'service_technical_modification'.tr(),
            icon: Icons.engineering,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VehicleModificationScreen(prefilledData: {'plateNumber': vehicle['plateNumber']})),
            ),
          ),
          _ServiceItem(
            id: 'lost',
            title: 'service_replace_damaged_or_lost'.tr(),
            icon: Icons.credit_card_off,
            highlight: insuranceExpired,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LostDocumentsScreen(prefilledData: {
                'ownerId': '1234567890',
                'ownerName': 'محمد أحمد خالد علي',
                'plateNumber': vehicle['plateNumber'],
              })),
            ),
          ),
          _ServiceItem(
            id: 'deregister',
            title: 'service_deregister_vehicle'.tr(),
            icon: Icons.car_crash,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VehicleDeregistrationScreen(prefilledData: {
                'ownerId': '1234567890',
                'ownerName': 'محمد أحمد خالد علي',
                'plateNumber': vehicle['plateNumber'],
              })),
            ),
          ),
          _ServiceItem(
            id: 'mortgage',
            title: 'service_mortgage_release'.tr(),
            icon: Icons.lock_open,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VehicleMortgageReleaseScreen(prefilledData: {
                'ownerId': '1234567890',
                'ownerName': 'محمد أحمد خالد علي',
                'plateNumber': vehicle['plateNumber'],
              })),
            ),
          ),
          if (isPublic)
            _ServiceItem(
              id: 'convert',
              title: 'service_vehicle_type_conversion'.tr(),
              icon: Icons.cached,
              highlight: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VehicleConversionScreen(prefilledData: {
                  'ownerId': '1234567890',
                  'ownerName': 'محمد أحمد خالد علي',
                  'plateNumber': vehicle['plateNumber'],
                })),
              ),
            ),
        ]
    ];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_car, color: AppTheme.navy),
                          const SizedBox(width: 8),
                          Text("${"plate_number".tr()}: ${vehicle["plateNumber"]}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                              children: vehicle["violations"]
                                  .map<Widget>((v) => Text("• $v"))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text("available_services".tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              if (hasViolations)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'cannot_perform_services_due_to_violations'.tr(),
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: serviceList.map((service) {
                    final isExpanded = expandedService == service.id;
                    return GestureDetector(
                      onTap: () {
                        if (isExpanded) {
                          service.onTap();
                        } else {
                          setState(() => expandedService = service.id);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isExpanded ? MediaQuery.of(context).size.width / 2 - 20 : 70,
                        height: isExpanded ? 130 : 70,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: service.highlight
                              ? Colors.yellow.shade100
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              service.icon,
                              size: isExpanded ? 36 : 28,
                              color: AppTheme.navy,
                            ),
                            if (isExpanded)
                              const SizedBox(height: 8),
                            if (isExpanded)
                              Flexible(
                                child: Text(
                                  service.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
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
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}

class _ServiceItem {
  final String id;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlight;

  _ServiceItem({required this.id, required this.title, required this.icon, required this.onTap, this.highlight = false});
}
