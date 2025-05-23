import 'package:flutter/material.dart';
import 'custom_drawer_web.dart';

class CitizenDashboardWeb extends StatefulWidget {
  const CitizenDashboardWeb({super.key});

  @override
  State<CitizenDashboardWeb> createState() => _CitizenDashboardWebState();
}

class _CitizenDashboardWebState extends State<CitizenDashboardWeb> {
  final List<Map<String, dynamic>> services = const [
    {"title": "تجديد رخصة القيادة", "icon": Icons.credit_card},
    {"title": "تجديد ترخيص مركبة", "icon": Icons.car_repair},
    {"title": "تسجيل مركبة جديدة", "icon": Icons.directions_car},
    {"title": "نقل ملكية مركبة", "icon": Icons.swap_horiz},
    {"title": "وثائق مفقودة أو تالفة", "icon": Icons.credit_card_off},
    {"title": "نتائج الفحص", "icon": Icons.assignment_turned_in},
    {"title": "تعديل فني على المركبة", "icon": Icons.engineering},
    {"title": "تحويل المركبة من/إلى خصوصي أو تجاري", "icon": Icons.cached},
    {"title": "شطب مركبة", "icon": Icons.car_crash},
    {"title": "حجز موعد", "icon": Icons.calendar_month},
    {"title": "فك رهن مركبة", "icon": Icons.lock_open},
    {"title": "المخالفات المرورية", "icon": Icons.warning_amber_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: CustomDrawerWeb(
          toggleTheme: () {},
          onSettingsReturned: (val) {},
        ),
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'بوابة المواطنين',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF002D5B),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return StatefulBuilder(
                    builder: (context, setState) {
                      double scale = 1.0;
                      return Listener(
                        onPointerDown: (_) => setState(() => scale = 0.95),
                        onPointerUp: (_) => setState(() => scale = 1.0),
                        child: AnimatedScale(
                          scale: scale,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeOut,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {},
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    service["icon"],
                                    size: 50,
                                    color: const Color(0xFF002D5B),
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      service["title"],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
