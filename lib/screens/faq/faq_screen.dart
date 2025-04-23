import 'package:flutter/material.dart';
import '/theme/app_theme.dart';
import 'package:traffic_department/screens/contact/contact_us_screen.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, String>> faqs = [
    {
      "category": "المعاملات",
      "question": "كيف يمكنني حجز موعد لتجديد رخصة القيادة؟",
      "answer": "يمكنك حجز الموعد من خلال قسم 'معاملاتي'، ثم اختيار 'حجز موعد جديد' واتباع الخطوات المعروضة."
    },
    {
      "category": "المركبات",
      "question": "هل يمكن تجديد ترخيص المركبة من خلال التطبيق؟",
      "answer": "نعم، يمكنك الدخول إلى صفحة 'مركباتي'، ثم اختيار المركبة والضغط على 'تجديد الترخيص'."
    },
    {
      "category": "المركبات",
      "question": "ما هي الوثائق المطلوبة لتسجيل مركبة جديدة؟",
      "answer": "الوثائق تشمل إثبات الملكية، بطاقة الهوية، وفحص فني ساري المفعول."
    },
    {
      "category": "الشكاوى",
      "question": "كيف يمكنني تقديم شكوى ضد موظف؟",
      "answer": "توجه إلى صفحة 'الشكاوى والاقتراحات'، واختر 'مشكلة مع الموظف'، ثم املأ النموذج بالمعلومات اللازمة."
    },
    {
      "category": "المعاملات",
      "question": "هل أستطيع متابعة حالة معاملتي؟",
      "answer": "نعم، من خلال 'معاملاتي'، يمكنك الاطلاع على حالة الطلب: قيد المراجعة، مكتملة، أو مرفوضة."
    },
    {
      "category": "التطبيق",
      "question": "لماذا لا تصلني إشعارات المعاملات؟",
      "answer": "تأكد من تفعيل الإشعارات من الإعدادات العامة، وتحقق من إعدادات الهاتف أيضًا."
    },
    {
      "category": "الحساب",
      "question": "كيف يمكنني تغيير رقم الهاتف أو البريد الإلكتروني؟",
      "answer": "من خلال 'الملف الشخصي'، يمكنك تعديل معلومات الاتصال وحفظها."
    },
    {
      "category": "عام",
      "question": "ما هي ساعات عمل دائرة السير؟",
      "answer": "من الأحد إلى الخميس، من الساعة 8 صباحًا حتى الساعة 3 مساءً."
    },
    {
      "category": "التطبيق",
      "question": "هل يمكن استخدام التطبيق دون اتصال بالإنترنت؟",
      "answer": "يمكنك استعراض بعض البيانات مثل المركبات، لكن المعاملات والشكاوى تتطلب اتصالًا بالإنترنت."
    },
    {
      "category": "التطبيق",
      "question": "ماذا أفعل إذا واجهت مشكلة في التطبيق؟",
      "answer": "انتقل إلى صفحة 'تواصل مع دائرة السير' أو قدم شكوى عبر 'الشكاوى والاقتراحات' تحت 'مشكلة في الخدمات أو التطبيق'."
    },
  ];

  String _searchQuery = '';
  String _selectedCategory = 'الكل';

  List<String> get categories => ["الكل", ...{
        ...faqs.map((f) => f['category']!).toSet()
      }];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = faqs.where((faq) {
      final matchesCategory = _selectedCategory == "الكل" || faq['category'] == _selectedCategory;
      final matchesSearch = faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الأسئلة الشائعة"),
          backgroundColor: AppTheme.navy,
          centerTitle: true,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "ابحث عن سؤال...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      selectedColor: AppTheme.navy,
                      backgroundColor: Colors.grey[300],
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: filteredFaqs.isEmpty
                  ? const Center(child: Text("لا توجد نتائج مطابقة"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredFaqs.length,
                      itemBuilder: (context, index) {
                        final item = filteredFaqs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              leading: const Icon(Icons.question_answer_outlined, color: AppTheme.navy),
                              title: Text(
                                item['question']!,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['answer']!,
                                        style: const TextStyle(height: 1.6),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Text("هل كانت هذه الإجابة مفيدة؟"),
                                          const Spacer(),
                                          IconButton(icon: const Icon(Icons.thumb_up_alt_outlined), onPressed: () {}),
                                          IconButton(icon: const Icon(Icons.thumb_down_alt_outlined), onPressed: () {}),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
                },
                icon: const Icon(Icons.support_agent, color: AppTheme.navy),
                label: const Text("لم تجد ما تبحث عنه؟ تواصل معنا"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
