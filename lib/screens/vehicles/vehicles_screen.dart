import 'package:flutter/material.dart';
import '/theme/app_theme.dart';
import 'vehicle_details_screen.dart'; 

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  final List<Map<String, dynamic>> vehicles = const [
    {
      "plateNumber": "1234-أ-567",
      "type": "خصوصي",
      "brand": "تويوتا - كورولا",
      "year": "2020",
      "color": "أبيض",
      "status": "مرخصة",
      "chassis": "CHS123456789",
      "engine": "ENG987654321",
      "fuel": "بنزين",
      "capacity": 5,
      "expiry": "2025-12-31",
      "violations": ["مخالفة سرعة", "مخالفة اصطفاف"],
      "insurance": "سارية"
    },
    {
      "plateNumber": "9876-ب-123",
      "type": "نقل",
      "brand": "هيونداي - H1",
      "year": "2018",
      "color": "فضي",
      "status": "بحاجة لتجديد",
      "chassis": "CHS654321987",
      "engine": "ENG123456789",
      "fuel": "ديزل",
      "capacity": 9,
      "expiry": "2024-10-15",
      "violations": [],
      "insurance": "منتهية"
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
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("مركباتي"),
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
                leading: Icon(Icons.directions_car, size: 30, color: AppTheme.navy),
                title: Text("رقم اللوحة: ${vehicle["plateNumber"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("نوع المركبة: ${vehicle["type"]}"),
                    Text("الشركة والطراز: ${vehicle["brand"]}"),
                    Text("سنة الصنع: ${vehicle["year"]}"),
                    Text("اللون: ${vehicle["color"]}"),
                    Text("الحالة: ${vehicle["status"]}", style: TextStyle(color: getStatusColor(vehicle["status"]))),
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
