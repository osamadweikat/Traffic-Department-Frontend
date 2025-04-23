import 'package:flutter/material.dart';
import '/theme/app_theme.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تفاصيل المركبة"),
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
                      Text("رقم اللوحة: ${vehicle["plateNumber"]}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  buildRow("نوع المركبة:", vehicle["type"]),
                  buildRow("الشركة والطراز:", vehicle["brand"]),
                  buildRow("سنة الصنع:", vehicle["year"]),
                  buildRow("اللون:", vehicle["color"]),
                  buildRow("رقم الشاسيه:", vehicle["chassis"]),
                  buildRow("رقم المحرك:", vehicle["engine"]),
                  buildRow("نوع الوقود:", vehicle["fuel"]),
                  buildRow("عدد الركاب:", vehicle["capacity"].toString()),
                  buildRow("تاريخ انتهاء الترخيص:", vehicle["expiry"]),
                  buildRow("حالة التأمين:", vehicle["insurance"]),

                  const SizedBox(height: 15),
                  const Text("المخالفات:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),

                  vehicle["violations"].isEmpty
                      ? const Text("لا توجد مخالفات")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: vehicle["violations"].map<Widget>((v) => Text("• $v")).toList(),
                        ),

                  const SizedBox(height: 30),

                  const Text("الخدمات المتاحة", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  buildServiceButton(context, "تجديد رخصة المركبة", Icons.update, () {
                    
                  }),

                  buildServiceButton(context, "نقل ملكية المركبة", Icons.transfer_within_a_station, () {
                  
                  }),

                  buildServiceButton(context, "تغيير لون المركبة", Icons.color_lens, () {
                    
                  }),

                  buildServiceButton(context, "إصدار بدل فاقد لوحة أو ملكية", Icons.report_problem, () {

                  }),

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
