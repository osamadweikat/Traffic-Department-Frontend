import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traffic_department/screens/web_portal/news_data.dart';

class MainWebsiteHome extends StatefulWidget {
  const MainWebsiteHome({super.key});

  @override
  State<MainWebsiteHome> createState() => _MainWebsiteHomeState();
}

class _MainWebsiteHomeState extends State<MainWebsiteHome> {
  late String currentTime;
  late String currentDate;

  final List<Map<String, dynamic>> testimonials = [
    {'name': 'أحمد يوسف', 'rating': 5, 'comment': 'خدمة ممتازة وسريعة جدًا'},
    {
      'name': 'نسرين صالح',
      'rating': 4,
      'comment': 'سهولة استخدام البوابة شيء رائع',
    },
    {
      'name': 'خالد عمرو',
      'rating': 5,
      'comment': 'واجهة أنيقة وسرعة في الأداء',
    },
    {'name': 'ميساء ناصر', 'rating': 4, 'comment': 'الدعم الفني استجاب بسرعة'},
    {
      'name': 'فادي الزين',
      'rating': 5,
      'comment': 'شكراً لتسهيل المعاملات إلكترونيًا',
    },
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentDate = DateFormat('EEEE، d MMMM yyyy', 'ar').format(now);
    currentTime = DateFormat('hh:mm a', 'ar').format(now);
  }

  @override
  Widget build(BuildContext context) {
    final latestNews = newsList.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Column(
        children: [
          // 🔵 Header Bar
          Container(
            color: const Color(0xFF1E3A5F),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/traffic_logo.png',
                    height: 48,
                    width: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'دولة فلسطين - وزارة النقل والمواصلات',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  '$currentDate | $currentTime',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            child: Row(
              children: [
                _buildNavButton(context, 'الرئيسية', '/'),
                _buildNavButton(context, 'بوابة المواطنين', '/citizen/login'),
                _buildNavButton(context, 'بوابة الموظفين', '/staff-portal'),
                _buildNavButton(context, 'الأخبار', '/news'),
                _buildNavButton(context, 'تقديم شكوى', '/complaints'),
                _buildNavButton(context, 'الاقتراحات', '/suggestions'),
                _buildNavButton(context, 'تقييم البوابة', '/rating'),
                _buildNavButton(context, 'تواصل معنا', '/contact'),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'بوابتكم للخدمات الإلكترونية',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'مرحبًا بكم في المنصة الرسمية لدائرة السير الفلسطينية حيث نوفر لكم خدمات ومعاملات إلكترونية سهلة وسريعة.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    '🔢 الإحصائيات التالية محدثة منذ بداية عام 2025',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    children: [
                      _buildStatCard('🚗 المركبات المسجلة', '120,000'),
                      _buildStatCard('👤 المستخدمين النشطين', '80,000'),
                      _buildStatCard('💼 موظفين في الخدمة', '215'),
                      _buildStatCard('📄 المعاملات اليومية', '6,000'),
                      _buildStatCard('📅 المواعيد المحجوزة', '1,250'),
                      _buildStatCard('📬 الشكاوى هذا الشهر', '1,540'),
                    ],
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    '📰 آخر الأخبار',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children:
                        latestNews.map((news) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/news-details',
                                arguments: news,
                              );
                            },
                            child: Container(
                              width: 320,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    news['title']!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${news['date']} - ${news['time']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    '📊 تقارير رسمية',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 20,
                    children: [
                      _buildReportItem('🔍 تقرير أداء شهر أبريل'),
                      _buildReportItem('💼 تقرير حملات التفتيش 2025'),
                      _buildReportItem('📝 ملخص شكاوى المواطنين'),
                    ],
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    '💬 آراء المستخدمين',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children:
                        testimonials.map((t) {
                          return Container(
                            width: 250,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      t['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => Icon(
                                          Icons.star,
                                          size: 16,
                                          color:
                                              i < t['rating']
                                                  ? Colors.amber
                                                  : Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  t['comment'],
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // 🔵 Footer
          Container(
            color: const Color(0xFF1E3A5F),
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '© 2025 دائرة السير - وزارة النقل والمواصلات الفلسطينية | ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.phone, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    '1800-123-456 | ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.email, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'info@mot.gov.ps',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String label, String route) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildReportItem(String text) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
