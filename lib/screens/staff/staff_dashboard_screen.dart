import 'package:flutter/material.dart';
import 'package:traffic_department/screens/staff/staff_drawer.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  int notificationCount = 3;
  final String currentPage = 'home';
  String _hoveredLabel = ''; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Row(
        children: [
          const StaffDrawer(currentPage: 'home'),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeBanner(), 
                        const SizedBox(height: 16),

                        _buildActionButtons(), 
                        const SizedBox(height: 24),

                        _buildImportantMessagesCard(), 
                        const SizedBox(height: 20),

                        _buildStatsGrid(), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 60,
      color: const Color(0xFFE8EDF3),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/traffic_logo.png',
                  width: 36,
                  height: 36,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'دائرة السير الفلسطينية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'بوابة الموظفين',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Color(0xFF1E3A5F)),
                onPressed: () {
                  setState(() {
                    notificationCount = 0;
                  });
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0ECF8), Color(0xFFD4E1F1)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A5F),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'مرحبًا بك في منصتك الوظيفية. حضورك هو بداية الإنجاز، ودورك محور في خدمة الوطن والمواطن.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E3A5F),
                height: 1.6,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantMessagesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDED),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.mark_email_unread_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'الرسائل الهامة والتوجيهات الإدارية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSingleMessage(
            sender: 'أسامة الخطيب – مدير دائرة السير',
            caseId: '98217364',
            content:
                'يرجى إنجاز المعاملة المشار إليها أعلاه بأسرع وقت ممكن، حيث أن تأخرها يؤثر على سير العمل. نؤكد ضرورة معالجتها فورًا لتجنّب أي تأخير إضافي.',
            date: '16 مايو 2025',
            time: '12:45 مساءً',
          ),
          const SizedBox(height: 16),
          _buildSingleMessage(
            sender: 'موظف رقم 342718 – قسم الترخيص',
            caseId: '70842913',
            content:
                'تم تحويل معاملة ترخيص "مركبة نقل وقود مستعجلة" إليك. نرجو مراجعتها بأقرب وقت كونها من المعاملات ذات الأولوية القصوى.',
            date: '16 مايو 2025',
            time: '09:30 صباحًا',
          ),
        ],
      ),
    );
  }

  Widget _buildSingleMessage({
    required String sender,
    required String caseId,
    required String content,
    required String date,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sender, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            'معاملة رقم: $caseId',
            style: const TextStyle(color: Colors.black87, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(height: 1.5, fontSize: 14)),
          const SizedBox(height: 12),
          Text(
            ' $date - $time',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 20,
      mainAxisSpacing: 16,
      childAspectRatio: 1.9,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          Icons.move_to_inbox_rounded,
          'المعاملات المستلمة اليوم',
          '18',
        ),
        _buildStatCard(Icons.pending_actions, 'المعاملات قيد المعالجة', '9'),
        _buildStatCard(Icons.assignment_late, 'المعاملات المتأخرة', '6'),
        _buildStatCard(Icons.input, 'المعاملات المحولة اليك', '4'),
        _buildStatCard(Icons.campaign_rounded, 'الشكاوى المتابعة', '5'),
        _buildStatCard(Icons.task_alt, 'المعاملات المكتملة هذا الأسبوع', '41'),
        _buildStatCard(
          Icons.schedule_rounded,
          'متوسط مدة إنجاز المعاملة',
          '23 دقيقة',
        ),
        _buildStatCard(Icons.pie_chart, 'نسبة الإنجاز هذا الشهر', '78%'),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Icon(icon, size: 32, color: const Color(0xFF1E3A5F)),
              const SizedBox(width: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        _buildActionButton(
          Icons.verified_user_rounded,
          'تأكيد حساب مستخدم',
          Colors.green.shade700,
        ),
        _buildActionButton(
          Icons.report_gmailerrorred_rounded,
          'متابعة الشكاوى',
          Colors.deepOrange,
        ),
        _buildActionButton(
          Icons.chat_bubble_outline,
          'مراسلة موظف',
          Colors.indigo.shade600,
        ),
        _buildActionButton(
          Icons.report_problem_rounded,
          'مخالفة إدارية',
          Colors.red.shade700,
        ),
        _buildActionButton(
          Icons.history_rounded,
          'سجل النشاطات',
          Colors.teal.shade600,
        ),
        _buildActionButton(
          Icons.insert_chart_outlined,
          'تقريري الشهري',
          Colors.blueGrey.shade700,
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredLabel = label),
      onExit: (_) => setState(() => _hoveredLabel = ''),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow:
              _hoveredLabel == label
                  ? [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
