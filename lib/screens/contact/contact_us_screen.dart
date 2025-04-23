import 'package:flutter/material.dart';
import '/theme/app_theme.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تواصل مع دائرة السير"),
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
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("معلومات الاتصال", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 10),
                      Text("📞 هاتف: 06-1234567"),
                      Text("📱 طوارئ: 199"),
                      Text("✉️ البريد الإلكتروني: info@traffic.gov.jo"),
                      Text("📍 العنوان: شارع الأمن العام - عمان - الأردن"),
                      Text("🕒 أوقات الدوام: الأحد - الخميس | 8:00 صباحًا - 2:00 مساءً"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: Text("خريطة دائرة السير (Google Map)", style: TextStyle(color: Colors.grey.shade600)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("نموذج تواصل", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),

                      TextField(
                        decoration: InputDecoration(
                          labelText: "الاسم",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "رقم الهاتف",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "البريد الإلكتروني",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 10),

                      TextField(
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "رسالتك",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("تم إرسال الرسالة بنجاح (نموذج فقط)")),
                            );
                          },
                          icon: const Icon(Icons.send),
                          label: const Text("إرسال"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.yellow,
                            foregroundColor: AppTheme.navy,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
