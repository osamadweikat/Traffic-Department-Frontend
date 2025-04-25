import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' as ui;
import '../../../theme/app_theme.dart';
import '../../payment/payment_screen.dart';

class LicenseRenewalScreen extends StatefulWidget {
  const LicenseRenewalScreen({super.key});

  @override
  State<LicenseRenewalScreen> createState() => _LicenseRenewalScreenState();
}

class _LicenseRenewalScreenState extends State<LicenseRenewalScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, XFile?> uploadedFiles = {
    'original_license': null,
    'personal_photo_1': null,
    'personal_photo_2': null,
    'medical_check': null,
    'fines_clearance': null,
  };

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickImage(String key) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        uploadedFiles[key] = image;
      });
    }
  }

  void removeImage(String key) {
    setState(() {
      uploadedFiles[key] = null;
    });
  }

  Widget buildUploadTile(String label, String key) {
    final isSelected = uploadedFiles[key] != null;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isSelected ? Colors.green.shade50 : null,
      child: Column(
        children: [
          ListTile(
            title: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle:
                isSelected ? Text('تم اختيار صورة') : Text('اضغط لاختيار صورة'),
            leading: Icon(Icons.image_outlined, color: AppTheme.navy),
            trailing:
                isSelected
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.orange),
                          tooltip: 'تغيير',
                          onPressed: () => pickImage(key),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          tooltip: 'حذف',
                          onPressed: () => removeImage(key),
                        ),
                        const Icon(Icons.check_circle, color: Colors.green),
                      ],
                    )
                    : IconButton(
                      icon: const Icon(Icons.upload, color: AppTheme.navy),
                      onPressed: () => pickImage(key),
                    ),
            onTap: () => pickImage(key),
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(uploadedFiles[key]!.path),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection:
          context.locale.languageCode == 'ar'
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('renew_license_title'.tr()),
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppTheme.lightGrey,
        body: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                buildUploadTile('original_license'.tr(), 'original_license'),
                buildUploadTile('personal_photo_1'.tr(), 'personal_photo_1'),
                buildUploadTile('personal_photo_2'.tr(), 'personal_photo_2'),
                buildUploadTile('medical_check'.tr(), 'medical_check'),
                buildUploadTile('fines_clearance'.tr(), 'fines_clearance'),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'instructions_title'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'instructions_content'.tr(),
                        style: TextStyle(
                          height: 1.6,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PaymentScreen(transactionType: 'license_renewal'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navy,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'proceed_to_payment'.tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
