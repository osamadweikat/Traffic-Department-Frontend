import 'package:flutter/material.dart';
import 'package:traffic_department/data/messages_data.dart';
import 'package:traffic_department/screens/staff/tasks/staff_messages/message_thread_screen.dart';
import 'package:traffic_department/screens/staff/tasks/staff_messages/compose_message_screen.dart';

class MessageInboxScreen extends StatefulWidget {
  const MessageInboxScreen({super.key});

  @override
  State<MessageInboxScreen> createState() => _MessageInboxScreenState();
}

class _MessageInboxScreenState extends State<MessageInboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E3A5F),
          centerTitle: true,
          title: const Text(
            'صندوق الرسائل',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        message['subject'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('من: ${message['from']}'),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('التاريخ: ${message['date']}'),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('عدد الردود: ${message['replies'].length}'),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment:
                          Alignment
                              .centerLeft,
                      child: Directionality(
                        textDirection:
                            TextDirection.ltr, 
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                messages.removeAt(index);
                                (context as Element)
                                    .markNeedsBuild(); 
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text('حذف'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MessageThreadScreen(
                                          message: message,
                                        ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.mail_outline),
                              label: const Text('عرض المحادثة'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ComposeMessageScreen()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('رسالة جديدة'),
          backgroundColor: Colors.teal.shade700,
        ),
      ),
    );
  }
}
