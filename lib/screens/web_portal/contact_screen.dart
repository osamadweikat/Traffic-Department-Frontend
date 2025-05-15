import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:traffic_department/screens/web_portal/success_dialog.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Transform.scale(
                scale: 0.7,
                child: Lottie.asset(
                  'assets/animations/contact_background.json',
                  controller: _backgroundController,
                  fit: BoxFit.cover,
                  repeat: true,
                  onLoaded: (composition) {
                    _backgroundController.duration =
                        composition.duration * 0.5; 
                    _backgroundController.repeat();
                  },
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
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/contact_icon.json',
                          height: 60,
                          repeat: true,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'تواصل معنا',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.contact_mail,
                            color: Colors.blue,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'يسعدنا تواصلك معنا! نحن في دائرة السير نرحب بجميع استفساراتك وملاحظاتك، وسنقوم بالرد بأسرع وقت ممكن.',
                              style: TextStyle(fontSize: 13.5, height: 1.6),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildField(
                            'الاسم الكامل',
                            nameController,
                            'الاسم الرباعي',
                          ),
                          _buildField(
                            'البريد الإلكتروني',
                            emailController,
                            'example@gmail.com',
                          ),
                          _buildField(
                            'رقم الهاتف',
                            phoneController,
                            '05XXXXXXXX',
                          ),
                          _buildField(
                            'الرسالة',
                            messageController,
                            'اكتب رسالتك هنا...',
                            maxLines: 4,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: const Icon(Icons.send),
                              label: const Text('إرسال'),
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

                    const Divider(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.contact_page,
                          color: Colors.blueGrey,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'معلومات التواصل',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const ContactInfoRow(
                      icon: Icons.location_on,
                      text: 'رام الله – شارع الوزارات – مبنى دائرة السير',
                    ),
                    const ContactInfoRow(icon: Icons.phone, text: '02-1234567'),
                    const ContactInfoRow(
                      icon: Icons.email,
                      text: 'contact@traffic.gov.ps',
                    ),
                    const ContactInfoRow(
                      icon: Icons.access_time,
                      text: 'الأحد – الخميس، 8:00 ص – 2:00 م',
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

  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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

  void _submitForm() {
  if (_formKey.currentState!.validate()) {
    showSuccessDialog(
      context: context,
      title: 'تم إرسال رسالتك',
      message: 'شكرًا لتواصلك معنا. سيتم الرد عليك في أقرب وقت ممكن.',
    );
  }
}

}

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey.shade700, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13.5))),
      ],
    );
  }
}
