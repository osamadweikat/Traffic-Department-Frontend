import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '/theme/app_theme.dart';
import 'package:flutter/services.dart' as ui;
import 'vehicle_details_screen.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  final List<Map<String, dynamic>> vehicles = const [
    {
      "plateNumber": "1111-أ-111",
      "type": "خصوصي",
      "brand": "تويوتا - يارس",
      "year": "2019",
      "color": "أبيض",
      "status": "مرخصة",
      "chassis": "CHS000000111",
      "engine": "ENG000001111",
      "fuel": "بنزين",
      "capacity": 5,
      "weight": 1200,
      "engineCapacity": 1500,
      "expiry": "2026-06-30",
      "violations": [],
      "insurance": "سارية"
    },
    {
      "plateNumber": "2222-ب-222",
      "type": "خصوصي",
      "brand": "هونداي - أكسنت",
      "year": "2020",
      "color": "فضي",
      "status": "بحاجة لتجديد",
      "chassis": "CHS000000222",
      "engine": "ENG000002222",
      "fuel": "هايبرد",
      "capacity": 5,
      "weight": 1300,
      "engineCapacity": 1600,
      "expiry": "2023-12-01",
      "violations": [],
      "insurance": "منتهية"
    },
    {
      "plateNumber": "3333-ج-333",
      "type": "عمومي",
      "brand": "فورد - ترانزيت",
      "year": "2018",
      "color": "أزرق",
      "status": "مرخصة",
      "chassis": "CHS000000333",
      "engine": "ENG000003333",
      "fuel": "ديزل",
      "capacity": 10,
      "weight": 2000,
      "engineCapacity": 2500,
      "expiry": "2025-08-15",
      "violations": [],
      "insurance": "سارية"
    },
    {
      "plateNumber": "4444-د-444",
      "type": "خصوصي",
      "brand": "كيا - ريو",
      "year": "2017",
      "color": "أسود",
      "status": "مرخصة",
      "chassis": "CHS000000444",
      "engine": "ENG000004444",
      "fuel": "بنزين",
      "capacity": 5,
      "weight": 1250,
      "engineCapacity": 1400,
      "expiry": "2024-11-10",
      "violations": ["مخالفة سرعة", "تجاوز إشارة مرور"],
      "insurance": "منتهية"
    },
    {
      "plateNumber": "5555-هـ-555",
      "type": "عمومي",
      "brand": "مرسيدس - فان",
      "year": "2022",
      "color": "رمادي",
      "status": "مرخصة",
      "chassis": "CHS000000555",
      "engine": "ENG000005555",
      "fuel": "ديزل",
      "capacity": 14,
      "weight": 2300,
      "engineCapacity": 2800,
      "expiry": "2024-05-10",
      "violations": [],
      "insurance": "سارية"
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "مرخصة":
        return Colors.green;
      case "بحاجة لتجديد":
        return Colors.orange;
      case "غير مرخصة":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("my_vehicles").tr(),
          centerTitle: true,
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.directions_car, size: 30, color: AppTheme.navy),
                title: Text(
                  "${"plate_number".tr()}: ${vehicle["plateNumber"]}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${"vehicle_type".tr()}: ${vehicle["type"]}"),
                    Text("${"brand_model".tr()}: ${vehicle["brand"]}"),
                    Text("${"manufacture_year".tr()}: ${vehicle["year"]}"),
                    Text("${"color".tr()}: ${vehicle["color"]}"),
                    Text("${"status".tr()}: ${vehicle["status"]}",
                        style: TextStyle(color: getStatusColor(vehicle["status"]))),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VehicleDetailsScreen(vehicle: vehicle),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
