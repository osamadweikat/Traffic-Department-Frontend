import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final TextEditingController notesController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  int elapsedSeconds = 0;
  DateTime? startTime;
  late Timer timer;
  Map<String, dynamic> attachmentStatus = {};
  String currentImageName = 'assets/images/P1.png';

  @override
  void initState() {
    super.initState();
    final List<String> attachments = List<String>.from(
      widget.transaction['attachments'] ?? [],
    );
    for (var name in attachments) {
      attachmentStatus[name] = null;
    }
    _initializeTimer();
  }

  Future<void> _initializeTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'startTime_${widget.transaction['id']}';
    final storedTime = prefs.getString(key);

    if (storedTime != null) {
      startTime = DateTime.parse(storedTime);
    } else {
      startTime = DateTime.now();
      await prefs.setString(key, startTime!.toIso8601String());
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsedSeconds = DateTime.now().difference(startTime!).inSeconds;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    notesController.dispose();
    employeeIdController.dispose();
    super.dispose();
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void showImageFullScreen(String imagePath) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'عرض الصورة',
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    maxScale: 5,
                    minScale: 0.5,
                    child: SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset(imagePath),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 30,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'إغلاق',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleAction(String action) {
    if (notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال الملاحظات قبل تنفيذ الإجراء'),
        ),
      );
      return;
    }

    if (action == 'تحويل لموظف آخر') {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: Colors.amber.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'تحويل لموظف آخر',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: TextField(
                controller: employeeIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'أدخل رقم الموظف الجديد',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Color(0xFF102542)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showResultDialog(
                      'تم تحويل المعاملة للموظف رقم ${employeeIdController.text}',
                      Colors.amber,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'تحويل',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
      );
    } else {
      Color color = action == 'تم الإنجاز' ? Colors.green : Colors.red;
      _showResultDialog('تم تنفيذ الإجراء: $action بنجاح', color);
    }
  }

  void _showResultDialog(String message, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
    );
    Future.delayed(const Duration(seconds: 3), () => Navigator.pop(context));
  }

  Color? getAttachmentColor(dynamic status) {
    if (status == true) return Colors.green.shade50;
    if (status == false) return Colors.red.shade50;
    if (status == null) return Colors.yellow.shade50;
    return Colors.white;
  }

  Icon getAttachmentIcon(dynamic status) {
    if (status == true)
      return const Icon(Icons.check_circle, color: Colors.green);
    if (status == false) return const Icon(Icons.cancel, color: Colors.red);
    if (status == null)
      return const Icon(Icons.report_problem, color: Colors.amber);
    return const Icon(Icons.help_outline, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final tx = widget.transaction;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF102542),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'تفاصيل المعاملة ${tx['id']}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.red),
                  const SizedBox(width: 6),
                  Text(
                    'مدة المعالجة: ${formatDuration(elapsedSeconds)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...[
                _buildIconRow(Icons.person, 'الاسم الكامل', tx['citizenName']),
                _buildIconRow(Icons.badge, 'الرقم الوطني', tx['nationalId']),
                _buildIconRow(
                  Icons.confirmation_number,
                  'رقم المعاملة',
                  tx['id'],
                ),
                _buildIconRow(Icons.description, 'نوع المعاملة', tx['type']),
                _buildIconRow(
                  Icons.date_range,
                  'تاريخ الاستلام',
                  tx['receivedDate'],
                ),
                _buildIconRow(
                  Icons.access_time,
                  'وقت الاستلام',
                  tx['receivedTime'],
                ),
                _buildIconRow(
                  Icons.payment,
                  'طريقة الدفع',
                  tx['paymentMethod'],
                ),
                _buildIconRow(
                  Icons.info_outline,
                  'الحالة الحالية',
                  tx['status'] ?? 'قيد الإنجاز',
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'الملفات المرفقة:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...attachmentStatus.entries.toList().asMap().entries.map((
                entryWithIndex,
              ) {
                final index = entryWithIndex.key;
                final entry = entryWithIndex.value;
                final status = entry.value;
                final imagePath = 'assets/images/P${(index % 5) + 1}.png';

                return GestureDetector(
                  onTap: () => showImageFullScreen(imagePath),
                  child: Card(
                    color: getAttachmentColor(status),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          if (entry.key != 'صورة شخصية')
                            IconButton(
                              icon: const Icon(
                                Icons.auto_awesome,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () => analyzeAttachment(entry.key),
                              tooltip: 'تحليل بالذكاء الاصطناعي',
                            ),
                          IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color:
                                  status == true ? Colors.green : Colors.grey,
                            ),
                            onPressed:
                                () => setState(
                                  () => attachmentStatus[entry.key] = true,
                                ),
                            tooltip: 'صالح',
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.report_problem,
                              color:
                                  status == null ? Colors.amber : Colors.grey,
                            ),
                            onPressed:
                                () => setState(
                                  () => attachmentStatus[entry.key] = null,
                                ),
                            tooltip: 'مشكوك فيه',
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: status == false ? Colors.red : Colors.grey,
                            ),
                            onPressed:
                                () => setState(
                                  () => attachmentStatus[entry.key] = false,
                                ),
                            tooltip: 'غير صالح',
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.key,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          getAttachmentIcon(status),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),
              const Text(
                'ملاحظات الموظف:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'أدخل ملاحظاتك هنا...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => handleAction('تم الإنجاز'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('تم الإنجاز'),
                  ),
                  ElevatedButton(
                    onPressed: () => handleAction('تحويل لموظف آخر'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text('تحويل'),
                  ),
                  ElevatedButton(
                    onPressed: () => handleAction('رفض المعاملة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('رفض'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F4471), size: 20),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

void analyzeAttachment(String attachmentName) {
  print('تحليل المرفق: $attachmentName');
}
