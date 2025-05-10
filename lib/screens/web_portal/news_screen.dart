import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NewsScreen extends StatelessWidget {
  final List<Map<String, String>> newsList = [
    {
      'title': 'إطلاق الحملة الوطنية لفحص المركبات',
      'date': '10 مايو 2025',
      'summary':
          'بدأت دائرة السير تنفيذ حملة وطنية لفحص المركبات العمومية والخاصة...',
    },
    {
      'title': 'تمديد فترة الترخيص حتى نهاية الشهر',
      'date': '8 مايو 2025',
      'summary':
          'أعلنت الوزارة عن تمديد مهلة تجديد رخص المركبات حتى نهاية الشهر...',
    },
    {
      'title': 'إتاحة رخص القيادة الإلكترونية',
      'date': '6 مايو 2025',
      'summary':
          'يمكن الآن استخراج رخص القيادة الرقمية من خلال التطبيق الإلكتروني المعتمد.',
    },
    {
      'title': 'تقرير أداء شهر أبريل متاح الآن',
      'date': '4 مايو 2025',
      'summary':
          'نشر تقرير مفصل حول أداء المعاملات وعدد الطلبات المنجزة في شهر أبريل.',
    },
    {
      'title': 'حوادث السير اليوم: 5 حوادث طفيفة',
      'date': '3 مايو 2025',
      'summary': 'سجلت الإدارة العامة للمرور 5 حوادث سير دون إصابات خطرة.',
    },
    {
      'title': 'افتتاح فرع جديد لدائرة السير في الوسطى',
      'date': '2 مايو 2025',
      'summary': 'تم افتتاح مركز جديد لخدمة المواطنين في المنطقة الوسطى.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.07,
              child: Transform.scale(
                scale:
                    1.2, 
                child: Image.asset(
                  'assets/images/news_background_bw.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Lottie.asset(
                      'assets/animations/news_icon.json',
                      repeat: true,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'آخر الأخبار',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A5F),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 320,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: newsList.length,
                    itemBuilder:
                        (context, index) =>
                            _buildNewsCard(context, newsList[index]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, Map<String, String> news) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            news['title']!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            news['date']!,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              news['summary']!,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: TextButton(
              onPressed: () {
              },
              child: const Text(
                'عرض التفاصيل',
                style: TextStyle(
                  color: Color(0xFF1E3A5F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
