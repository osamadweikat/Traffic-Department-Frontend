import 'package:flutter/material.dart';

class MessageThreadScreen extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageThreadScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final TextEditingController replyController = TextEditingController();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal.shade600,
          centerTitle: true,
          title: const Text(
            'تفاصيل الرسالة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  message['subject'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildMessageCard(
                    from: message['from'],
                    to: message['to'],
                    body: message['body'],
                    date: message['date'],
                    isMain: true,
                  ),
                  const SizedBox(height: 8),
                  ...message['replies'].map<Widget>((reply) {
                    return Column(
                      children: [
                        _buildMessageCard(
                          from: reply['from'],
                          to: reply['to'],
                          body: reply['body'],
                          date: reply['date'],
                          isMain: false,
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    controller: replyController,
                    maxLines: 3,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'اكتب ردك هنا...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (replyController.text.trim().isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم إرسال الرد')),
                          );
                          replyController.clear();
                        }
                      },
                      icon: const Icon(Icons.reply),
                      label: const Text('إرسال الرد'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard({
  required String from,
  required String to,
  required String body,
  required String date,
  required bool isMain,
}) {
  return Container(
    decoration: BoxDecoration(
      color: isMain ? Colors.teal.shade50 : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl, 
            children: [
              Text('من: $from', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              const Icon(Icons.send, size: 16),
              const SizedBox(width: 6),
              Text('إلى: $to', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            body,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            date,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}




}
