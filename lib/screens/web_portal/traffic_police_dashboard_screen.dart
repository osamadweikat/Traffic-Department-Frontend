import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class TrafficPoliceDashboardScreen extends StatefulWidget {
  const TrafficPoliceDashboardScreen({super.key});

  @override
  State<TrafficPoliceDashboardScreen> createState() => _TrafficPoliceDashboardScreenState();
}

class _TrafficPoliceDashboardScreenState extends State<TrafficPoliceDashboardScreen> {
  late DropzoneViewController controller;
  String droppedFileName = '';
  bool isHighlighted = false;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 64, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'تم رفع المخالفة بنجاح',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'تم إدخال المخالفة إلى النظام.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      setState(() {
        droppedFileName = '';
      });
    });
  }

  Future<void> _pickFileManually() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        droppedFileName = result.files.single.name;
      });

      _showSuccessDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0B3D91),
        centerTitle: true,
        title: const Text(
          '🚔 بوابة شرطة المرور',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 500, // عرض واضح للوسط
          height: 350, // ارتفاع واضح للوسط
          child: Stack(
            children: [
              DropzoneView(
                onCreated: (DropzoneViewController ctrl) => controller = ctrl,
                onDrop: (ev) async {
                  final name = await controller.getFilename(ev);

                  setState(() {
                    droppedFileName = name;
                  });

                  _showSuccessDialog();
                },
                onHover: () {
                  setState(() {
                    isHighlighted = true;
                  });
                },
                onLeave: () {
                  setState(() {
                    isHighlighted = false;
                  });
                },
              ),
              GestureDetector(
                onTap: _pickFileManually,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isHighlighted ? Colors.blue.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isHighlighted ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload, size: 64, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text(
                        'يمكنك سحب الملفات هنا أو الضغط لإضافتها.',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'الحد الأقصى لحجم الملف: 100MB، عدد الملفات: 20',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      if (droppedFileName.isNotEmpty)
                        Text(
                          'الملف المرفوع: $droppedFileName',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
