import 'package:flutter/material.dart';
import 'package:traffic_department/data/users_data.dart';

class ConfirmUserScreen extends StatefulWidget {
  const ConfirmUserScreen({super.key});

  @override
  State<ConfirmUserScreen> createState() => _ConfirmUserScreenState();
}

class _ConfirmUserScreenState extends State<ConfirmUserScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? selectedUser;
  bool searched = false;
  bool isHovered = false;

  void searchUser() {
    final query = _controller.text.trim();
    setState(() {
      searched = true;
      selectedUser = users.firstWhere(
        (user) => user['fullName'] == query || user['nationalId'] == query,
        orElse: () => {},
      );
      if (selectedUser!.isEmpty) selectedUser = null;
    });
  }

  void showDialogMessage(bool isConfirmed) {
    final icon = isConfirmed ? Icons.check_circle_outline : Icons.cancel_outlined;
    final color = isConfirmed ? Colors.green : Colors.red;
    final text = isConfirmed ? 'تم تأكيد المستخدم بنجاح' : 'تم رفض المستخدم';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      setState(() {
        selectedUser = null;
        searched = false;
        _controller.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF1E3A5F),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            alignment: Alignment.center,
            child: const Text(
              'تأكيد حساب مستخدم',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'ادخل الاسم الرباعي أو رقم الهوية...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: searchUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('بحث'),
                ),
              ],
            ),
          ),

          if (searched)
            Expanded(
              child: selectedUser == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(' لا يوجد مستخدم مطابق للاسم الرباعي أو رقم الهوية', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    )
                  : Center(
                      child: MouseRegion(
                        onEnter: (_) => setState(() => isHovered = true),
                        onExit: (_) => setState(() => isHovered = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 480,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.blue.shade100),
                            boxShadow: [
                              BoxShadow(
                                color: isHovered ? Colors.black26 : Colors.black12,
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.person, color: Colors.teal.shade700),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        selectedUser!['fullName'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black, 
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                _infoRow('رقم الهوية:', selectedUser!['nationalId']),
                                _infoRow('تاريخ الميلاد:', selectedUser!['birthDate']),
                                _infoRow('البريد الإلكتروني:', selectedUser!['email']),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => showDialogMessage(true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: const Text('تأكيد'),
                                    ),
                                    TextButton(
                                      onPressed: () => showDialogMessage(false),
                                      child: const Text('رفض', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    final labelColor = Colors.teal.shade700;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
