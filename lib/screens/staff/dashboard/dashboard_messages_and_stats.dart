import 'package:flutter/material.dart';

class DashboardMessagesAndStats extends StatelessWidget {
  const DashboardMessagesAndStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImportantMessagesCard(),
        const SizedBox(height: 24),
        _buildStatsGrid(),
      ],
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
            content:
                'نود إعلامكم بأن تقريركم الشهري قد تم إصداره وهو متاح الآن للاطلاع ضمن النظام. نرجو مراجعة التقرير في أقرب وقت، والتأكد من دقة البيانات الواردة فيه. نشكركم على جهودكم المستمرة.',
            date: '15 مايو 2025',
            time: '09:30 صباحًا',
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
        ],
      ),
    );
  }

  Widget _buildSingleMessage({
    required String sender,
    String? caseId,
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

          if (caseId != null && caseId.isNotEmpty)
            Text(
              'معاملة رقم: $caseId',
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),

          if (caseId != null && caseId.isNotEmpty) const SizedBox(height: 8),

          Text(content, style: const TextStyle(height: 1.5, fontSize: 14)),
          const SizedBox(height: 12),
          Text(
            '$date - $time',
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
}
