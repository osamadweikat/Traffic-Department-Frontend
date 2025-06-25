import 'package:flutter/material.dart';

class AdminSystemSettingsScreen extends StatefulWidget {
  const AdminSystemSettingsScreen({super.key});

  @override
  State<AdminSystemSettingsScreen> createState() => _AdminSystemSettingsScreenState();
}

class _AdminSystemSettingsScreenState extends State<AdminSystemSettingsScreen> {
  String portalName = 'بوابة دائرة السير';
  String topBarMessage = 'مرحباً بكم في بوابة دائرة السير';

  bool notificationsEnabled = true;
  String notificationEmail = 'admin@traffic-portal.ps';
  String reminderTime = '09:00 صباحاً';

  bool strongPasswordPolicy = true;
  int sessionTimeout = 30;

  bool backupEnabled = true;
  String backupPath = 'C:/Users/osama/OneDrive/Desktop/traffic_department';
  String lastBackupDate = '2025-06-05 22:00';

  bool logEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A237E),
          centerTitle: true,
          title: const Text(
            'إعدادات النظام',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false, 
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('إعدادات عامة'),
              const SizedBox(height: 12),
              _buildTextField('اسم البوابة', portalName, (value) {
                setState(() {
                  portalName = value;
                });
              }),
              const SizedBox(height: 12),
              _buildTextField('نص الشريط العلوي', topBarMessage, (value) {
                setState(() {
                  topBarMessage = value;
                });
              }),

              const SizedBox(height: 24),
              _buildSectionTitle('إعدادات الإشعارات'),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('تمكين الإشعارات'),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildTextField('البريد الافتراضي للردود', notificationEmail, (value) {
                setState(() {
                  notificationEmail = value;
                });
              }),
              const SizedBox(height: 12),
              _buildTextField('توقيت التذكيرات', reminderTime, (value) {
                setState(() {
                  reminderTime = value;
                });
              }),

              const SizedBox(height: 24),
              _buildSectionTitle('إعدادات الأمان'),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('سياسة كلمة مرور قوية'),
                value: strongPasswordPolicy,
                onChanged: (value) {
                  setState(() {
                    strongPasswordPolicy = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildNumberField('مدة جلسة المستخدم (بالدقائق)', sessionTimeout, (value) {
                setState(() {
                  sessionTimeout = value;
                });
              }),

              const SizedBox(height: 24),
              _buildSectionTitle('إعدادات النسخ الاحتياطي'),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('تفعيل النسخ الاحتياطي التلقائي'),
                value: backupEnabled,
                onChanged: (value) {
                  setState(() {
                    backupEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildTextField('مسار حفظ النسخ الاحتياطية', backupPath, (value) {
                setState(() {
                  backupPath = value;
                });
              }),
              const SizedBox(height: 12),
              Text(
                'آخر نسخ احتياطي: $lastBackupDate',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('إدارة سجلات النظام'),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('تمكين السجلات'),
                value: logEnabled,
                onChanged: (value) {
                  setState(() {
                    logEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم مسح السجلات القديمة بنجاح'),
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
                label: const Text(
                  'مسح السجلات القديمة',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    _showSuccessDialog();
                  },
                  child: const Text(
                    'حفظ التغييرات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A237E),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      controller: TextEditingController(text: initialValue)
        ..selection = TextSelection.collapsed(offset: initialValue.length),
      onChanged: onChanged,
    );
  }

  Widget _buildNumberField(String label, int value, Function(int) onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      controller: TextEditingController(text: value.toString())
        ..selection = TextSelection.collapsed(offset: value.toString().length),
      onChanged: (val) {
        final intValue = int.tryParse(val) ?? 0;
        onChanged(intValue);
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.green.shade700,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 64),
                SizedBox(height: 16),
                Text(
                  'تم حفظ التغييرات بنجاح',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'جاري تطبيق الإعدادات الجديدة...',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
