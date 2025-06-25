import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:traffic_department/data/sample_suggestions.dart';
import 'package:traffic_department/screens/web_portal/success_dialog.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  String? selectedCategory;
  int selectedRating = 0;
  PlatformFile? selectedFile;

  final List<String> suggestionCategories = [
    'تحسين التطبيق',
    'توفير خدمات جديدة',
    'تجربة المستخدم',
    'تطوير الخدمات',
    'أخرى',
  ];

  late List<AnimationController> _starControllers;

  @override
  void initState() {
    super.initState();
    _starControllers = List.generate(5, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  @override
  void dispose() {
    for (final controller in _starControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Transform.scale(
                scale: 0.5,
                child: Lottie.asset(
                  'assets/animations/suggestion_background.json',
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/idea_icon.json',
                          height: 60,
                          repeat: true,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'شاركنا اقتراحك',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.lightbulb_outline, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ' نحن نؤمن أن الأفكار العظيمة تبدأ باقتراح بسيط. إذا كانت لديك فكرة لتحسين خدماتنا أو إضافة شيء جديد، فلا تتردد في مشاركتها معنا وسنكون سعداء بسماعها!',
                              style: TextStyle(
                                fontSize: 13.2,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            'عنوان الاقتراح',
                            titleController,
                            'مثال: تفعيل إشعارات المخالفات',
                          ),
                          _buildTextField(
                            'تفاصيل الاقتراح',
                            detailsController,
                            'اشرح فكرتك بشكل واضح ومختصر',
                            maxLines: 4,
                          ),
                          const SizedBox(height: 10),
                          _buildCategoryDropdown(),
                          const SizedBox(height: 14),
                          _buildAnimatedRating(),
                          const SizedBox(height: 14),
                          _buildFilePicker(),

                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton.icon(
                              onPressed: _submitSuggestion,
                              icon: const Icon(Icons.send),
                              label: const Text('إرسال الاقتراح'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A5F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '🧠 اقتراحات ملهمة من المواطنين:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...previousSuggestions.map(
                      (s) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(
                            Icons.tips_and_updates,
                            color: Colors.amber,
                          ),
                          title: Text(s['title']),
                          subtitle: Text(
                            '🏷️ ${s['category']}  •  ⭐️ ${s['rating']}  •  📅 ${s['date']}',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator:
                (value) =>
                    value == null || value.trim().isEmpty
                        ? 'هذا الحقل مطلوب'
                        : null,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'فئة الاقتراح',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      items:
          suggestionCategories
              .map(
                (category) =>
                    DropdownMenuItem(value: category, child: Text(category)),
              )
              .toList(),
      value: selectedCategory,
      onChanged: (value) => setState(() => selectedCategory = value),
      validator: (value) => value == null ? 'يرجى اختيار الفئة' : null,
    );
  }

  Widget _buildAnimatedRating() {
    return Row(
      children: [
        const Text(
          'مدى أهمية الاقتراح:',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Row(
          children: List.generate(5, (index) {
            final filled = index < selectedRating;
            return GestureDetector(
              onTap: () {
                setState(() => selectedRating = index + 1);
                for (int i = 0; i <= index; i++) {
                  _starControllers[i].forward(from: 0);
                }
              },

              child: RotationTransition(
                turns: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _starControllers[index],
                    curve: Curves.elasticOut,
                  ),
                ),
                child: Icon(
                  filled ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 22,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إرفاق ملف (اختياري):',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('اختيار ملف'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 10),
            if (selectedFile != null)
              Expanded(
                child: Text(
                  selectedFile!.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.5),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() => selectedFile = result.files.first);
    }
  }

  void _submitSuggestion() {
  if (_formKey.currentState!.validate()) {
    showSuccessDialog(
      context: context,
      title: 'تم استلام اقتراحك',
      message: 'نقدّر مساهمتك في تحسين خدمات المنصة، سيتم دراسة اقتراحك بعناية.',
    );
  }
}

}
