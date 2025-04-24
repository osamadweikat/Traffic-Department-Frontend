import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/theme/app_theme.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  int _step = 0;
  String _message = '';
  List<String> _responses = [];
  final TextEditingController _messageController = TextEditingController();
  bool _isConversationStarted = false;
  bool _isConversationEnded = false;

  final List<Map<String, dynamic>> _savedConversations = [
    {
      "date": "2025/04/22 – 09:00",
      "messages": [
        "bot:greeting",
        "bot:problem_options",
        "user:1",
        "bot:select_transaction",
        "user:ترخيص مركبة",
        "bot:solutions_license",
        "bot:was_it_solved",
        "user:نعم",
        "bot:end_conversation"
      ],
      "supportAvailable": false
    },
    {
      "date": "2025/04/23 – 14:30",
      "messages": [
        "bot:greeting",
        "bot:problem_options",
        "user:3",
        "bot:ask_question",
        "user:هل يوجد دوام يوم الجمعة؟"
      ],
      "supportAvailable": true
    }
  ];

  final Map<String, List<String>> _transactionSuggestions = {
    "ترخيص مركبة": [
      "تحقق من الوثائق المطلوبة",
      "تأكد من سريان التأمين",
      "تأكد من خلو المركبة من المخالفات",
      "التحقق من سداد الرسوم",
      "تحديث بيانات المركبة"
    ],
    "نقل ملكية مركبة": [
      "التحقق من توقيع الطرفين",
      "إحضار هوية المالك الجديد",
      "تسديد رسوم النقل",
      "تأكيد مطابقة بيانات المركبة",
      "تحديث بيانات التأمين"
    ],
    "نتيجة فحص نظري": [
      "تسجيل الدخول إلى المنصة",
      "التأكد من رقم الجلوس",
      "تحديث الصفحة",
      "الاتصال بالدعم",
      "زيارة المركز المختص"
    ],
    "مخالفات مرورية": [
      "التحقق من رقم اللوحة",
      "الاستعلام عبر الموقع",
      "سداد المخالفة إلكترونياً",
      "مراجعة مركز المرور",
      "طلب اعتراض على المخالفة"
    ],
    "تغيير لون مركبة": [
      "إحضار نموذج تغيير اللون",
      "تصوير المركبة قبل وبعد",
      "مراجعة قسم الفحص",
      "دفع الرسوم",
      "تحديث الرخصة"
    ]
  };

  void _startConversation() {
    setState(() {
      _responses.clear();
      _isConversationStarted = true;
      _isConversationEnded = false;
      _step = 1;
      _responses.add("bot:greeting");
      _responses.add("bot:problem_options");
    });
  }

  void _sendMessage() {
    if (_message.trim().isEmpty) return;
    final msg = _message.trim();
    _responses.add("user:$msg");
    _messageController.clear();
    _message = '';

    if (_step == 1) {
      if (["1", "١"].contains(msg)) {
        _step = 2;
        _responses.add("bot:select_transaction");
      } else if (["2", "٢"].contains(msg)) {
        _step = 3;
        _responses.add("bot:solutions_app");
        _responses.add("bot:was_it_solved");
      } else if (["3", "٣"].contains(msg)) {
        _step = 4;
        _responses.add("bot:ask_question");
      } else {
        _responses.add("bot:invalid_option");
        _responses.add("bot:problem_options");
      }
    } else if (_step == 2) {
      if (_transactionSuggestions.containsKey(msg)) {
        _responses.add("bot:${_transactionSuggestions[msg]!.join("\n")}");
        _responses.add("bot:was_it_solved");
        _step = 5;
      } else {
        _responses.add("bot:unknown_transaction");
        _responses.add("bot:${_transactionSuggestions.keys.join("\n")}");
      }
    } else if (_step == 4) {
      _responses.add("bot:question_received");
      _responses.add("bot:end_conversation");
      _isConversationEnded = true;
    } else if (_step >= 3) {
      if (msg == "نعم" || msg.toLowerCase() == "yes") {
        _responses.add("bot:end_conversation");
        _isConversationEnded = true;
      } else if (msg == "لا" || msg.toLowerCase() == "no") {
        _responses.add("bot:forward_to_support");
        _isConversationEnded = true;
      }
    }

    setState(() {});
  }

  void _deleteConversation(int index) {
    final convo = _savedConversations[index];
    if (convo['supportAvailable'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("cannot_delete_pending".tr())),
      );
    } else {
      setState(() {
        _savedConversations.removeAt(index);
      });
    }
  }

  void _closeConversation() {
    setState(() {
      _isConversationStarted = false;
      _responses.clear();
      _messageController.clear();
      _message = '';
      _step = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("contact_traffic").tr(),
        centerTitle: true,
        backgroundColor: AppTheme.navy,
        leading: _isConversationStarted
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _closeConversation,
              )
            : null,
      ),
      backgroundColor: AppTheme.lightGrey,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!_isConversationStarted) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _savedConversations.length,
                  itemBuilder: (context, index) {
                    final conversation = _savedConversations[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        onTap: () => setState(() {
                          _responses = List.from(conversation['messages']);
                          _isConversationStarted = true;
                          _isConversationEnded = true;
                        }),
                        title: Text("conversation_on".tr(args: [conversation["date"]])),
                        subtitle: Text(
                          conversation["supportAvailable"]
                              ? "pending_reply".tr()
                              : "ended".tr(),
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteConversation(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startConversation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellow,
                    foregroundColor: AppTheme.navy,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("start_new_conversation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).tr(),
                ),
              ),
            ],
            if (_isConversationStarted) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _responses.length,
                  itemBuilder: (context, index) {
                    final message = _responses[index];
                    final isBot = message.startsWith("bot:");
                    final cleanMessage = message.replaceFirst("bot:", "").replaceFirst("user:", "");
                    return ListTile(
                      title: isBot ? _buildBotBubble(cleanMessage.tr()) : _buildUserBubble(cleanMessage),
                    );
                  },
                ),
              ),
              if (!_isConversationEnded) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _sendMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.yellow,
                        foregroundColor: AppTheme.navy,
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Icon(Icons.send),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        onChanged: (message) => setState(() => _message = message),
                        decoration: InputDecoration(
                          labelText: "type_here".tr(),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildUserBubble(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(12)),
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildBotBubble(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: AppTheme.yellow, borderRadius: BorderRadius.circular(12)),
        child: Text(message, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
