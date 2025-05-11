import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:traffic_department/data/complaint_types.dart';

class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  String? selectedType;
  PlatformFile? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Transform.scale(
                scale: 0.7,
                child: Lottie.asset(
                  'assets/animations/complaint.json', 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/complaint_icon.json',
                            height: 60,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'تقديم شكوى',
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
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.verified_user_rounded,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'نؤمن في دائرة السير بأن خدمة المواطن مسؤولية وواجب. ملاحظاتك وشكواك تصنع فرقًا حقيقيًا في تحسين الأداء. نحن هنا لسماعك ومعالجة شكواك بكل اهتمام وشفافية.',
                                style: TextStyle(
                                  fontSize: 13.2,
                                  color: Colors.black87,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('نوع الشكوى:', style: _labelStyle()),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _showComplaintTypeDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedType ?? 'اختر نوع الشكوى',
                                style: TextStyle(
                                  color:
                                      selectedType == null
                                          ? Colors.grey
                                          : Colors.black87,
                                  fontSize: 13.5,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        'تفاصيل الشكوى',
                        detailsController,
                        'يرجى توضيح تفاصيل الشكوى...',
                        maxLines: 4,
                      ),
                      _buildTextField(
                        'الاسم الكامل',
                        nameController,
                        'الاسم الرباعي',
                      ),
                      _buildTextField('رقم الهوية', idController, 'رقم الهوية'),
                      _buildTextField(
                        'رقم الهاتف',
                        phoneController,
                        '05xXXXXXXX',
                      ),
                      _buildTextField(
                        'البريد الإلكتروني (اختياري)',
                        emailController,
                        'example@gmail.com',
                        isRequired: false,
                      ),
                      _buildFilePicker(),

                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.send, size: 18),
                          label: const Text('تقديم الشكوى'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A5F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComplaintTypeDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('اختر نوع الشكوى'),
            content: SizedBox(
              width: 400,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: complaintTypes.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final type = complaintTypes[index];
                  return ListTile(
                    title: Text(type),
                    trailing:
                        selectedType == type
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                    onTap: () {
                      setState(() => selectedType = type);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isRequired = true,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 13.5),
            validator: (value) {
              if (!isRequired) return null;
              return (value == null || value.trim().isEmpty)
                  ? 'هذا الحقل مطلوب'
                  : null;
            },
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

  Widget _buildFilePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('إرفاق صورة أو مستند (اختياري)', style: _labelStyle()),
          const SizedBox(height: 6),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file, size: 18),
                label: const Text('اختيار ملف'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
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
      ),
    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() => selectedFile = result.files.first);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && selectedType != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال الشكوى بنجاح')));
    } else if (selectedType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى اختيار نوع الشكوى')));
    }
  }

  TextStyle _labelStyle() {
    return const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5);
  }
}
