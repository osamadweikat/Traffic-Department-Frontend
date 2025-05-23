import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traffic_department/screens/citizen/payment/payment_screen.dart';
import '../../../../theme/app_theme.dart';

class LicenseRenewalWeb extends StatefulWidget {
  const LicenseRenewalWeb({super.key});

  @override
  State<LicenseRenewalWeb> createState() => _LicenseRenewalWebState();
}

class _LicenseRenewalWebState extends State<LicenseRenewalWeb>
    with SingleTickerProviderStateMixin {
  final Map<String, XFile?> uploadedFiles = {
    'original_license': null,
    'personal_id_card': null,
    'personal_photo': null,
    'medical_check': null,
    'fines_clearance': null,
  };

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
            title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: isSelected ? const Text('تم اختيار صورة') : const Text('اضغط لاختيار صورة'),
            leading: const Icon(Icons.image_outlined, color: AppTheme.navy),
            trailing: isSelected
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.orange),
                        tooltip: 'تغيير',
                        onPressed: () => pickImage(key),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.navy,
          title: const Text('تجديد رخصة القيادة', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildUploadTile('صورة الرخصة الأصلية', 'original_license'),
                  buildUploadTile('بطاقة الهوية الشخصية', 'personal_id_card'),
                  buildUploadTile('الصورة الشخصية', 'personal_photo'),
                  buildUploadTile('فحص طبي', 'medical_check'),
                  buildUploadTile('إثبات خلو من المخالفات', 'fines_clearance'),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تعليمات مهمة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 12),
                        Text(
                          'يرجى التأكد من أن جميع الصور واضحة ومطابقة للوثائق الرسمية. لن يتم قبول الطلبات غير المكتملة أو التي تحتوي على صور غير واضحة.',
                          style: TextStyle(height: 1.6),
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
                    child: const Text('المتابعة إلى الدفع', style: TextStyle(color: Colors.white, fontSize: 16)),
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
