import 'package:flutter/material.dart';
import 'package:traffic_department/data/admin_inbox_data.dart';

class AdminInboxScreen extends StatefulWidget {
  const AdminInboxScreen({super.key});

  @override
  State<AdminInboxScreen> createState() => _AdminInboxScreenState();
}

class _AdminInboxScreenState extends State<AdminInboxScreen> {
  String selectedInboxFilter = 'الكل';
  bool sendToAll = false;
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A237E),
          centerTitle: true,
          automaticallyImplyLeading: false, 
          title: const Text(
            'صندوق الوارد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.inbox), text: 'الرسائل الواردة'),
              Tab(icon: Icon(Icons.send), text: 'إرسال رسالة'),
            ],
          ),
        ),

        body: TabBarView(
          children: [_buildInboxMessages(), _buildSendMessageForm()],
        ),
      ),
    );
  }

  Widget _buildInboxMessages() {
    final filteredMessages =
        adminInboxMessages.where((message) {
          if (selectedInboxFilter == 'الكل') return true;
          if (selectedInboxFilter == 'مقروءة') return message['isRead'] == true;
          if (selectedInboxFilter == 'غير مقروءة')
            return message['isRead'] == false;
          return true;
        }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  ['الكل', 'غير مقروءة', 'مقروءة'].map((filter) {
                    final isSelected = selectedInboxFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        selectedColor: Colors.blue.shade100,
                        onSelected: (_) {
                          setState(() {
                            selectedInboxFilter = filter;
                          });
                        },
                        labelStyle: TextStyle(
                          color:
                              isSelected ? Colors.blue.shade900 : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final message = filteredMessages[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text(message['subject']),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'من: موظف رقم ${message['employeeId']} - ${message['department']}',
                                ),
                                Text(
                                  'التاريخ: ${message['date']} - ${message['time']}',
                                ),
                                const SizedBox(height: 12),
                                Text(message['content']),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('إغلاق'),
                              ),
                            ],
                          ),
                    );

                    setState(() {
                      message['isRead'] = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          message['isRead']
                              ? Colors.white
                              : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['subject'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'من: موظف رقم ${message['employeeId']} - ${message['department']}',
                        ),
                        Text('بتاريخ: ${message['date']} - ${message['time']}'),
                        const SizedBox(height: 8),
                        Text(
                          message['content'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendMessageForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: sendToAll,
                  onChanged: (value) {
                    setState(() {
                      sendToAll = value!;
                      if (sendToAll) {
                        employeeIdController.clear();
                      }
                    });
                  },
                ),
                const Text('إرسال إلى جميع الموظفين'),
              ],
            ),

            const SizedBox(height: 12),

            if (!sendToAll)
              TextField(
                controller: employeeIdController,
                decoration: InputDecoration(
                  labelText: 'رقم الموظف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
              ),

            const SizedBox(height: 12),

            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'الموضوع',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: contentController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'محتوى الرسالة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.send),
                label: const Text(
                  'إرسال الرسالة',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('تم الإرسال'),
                          content: const Text('تم إرسال الرسالة بنجاح.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('موافق'),
                            ),
                          ],
                        ),
                  );

                  setState(() {
                    sendToAll = false;
                    employeeIdController.clear();
                    subjectController.clear();
                    contentController.clear();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
