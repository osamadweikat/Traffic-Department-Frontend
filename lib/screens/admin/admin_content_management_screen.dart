import 'package:easy_localization/easy_localization.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:traffic_department/data/admin_content_data.dart';

class AdminContentManagementScreen extends StatefulWidget {
  const AdminContentManagementScreen({super.key});

  @override
  State<AdminContentManagementScreen> createState() =>
      _AdminContentManagementScreenState();
}

class _AdminContentManagementScreenState
    extends State<AdminContentManagementScreen> {
  int selectedTab = 0;
  String formattedDate = DateFormat('d MMMM yyyy', 'ar').format(DateTime.now());
String formattedTime = DateFormat('hh:mm a', 'ar').format(DateTime.now());


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A237E),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'إدارة المحتوى',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedTab,
              onDestinationSelected: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.article),
                  label: Text('الأخبار'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.description),
                  label: Text('التقارير الرسمية'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.question_answer),
                  label: Text('الأسئلة الشائعة'),
                ),
              ],
            ),

            const VerticalDivider(thickness: 1, width: 1),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IndexedStack(
                  index: selectedTab,
                  children: [
                    _buildNewsManagement(),
                    _buildReportsManagement(),
                    _buildFAQManagement(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editNews(int index) {
    final news = newsList[index];
    final TextEditingController titleController = TextEditingController(
      text: news['title'],
    );
    final TextEditingController summaryController = TextEditingController(
      text: news['summary'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل الخبر'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'عنوان الخبر'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: summaryController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'الملخص'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  newsList[index]['title'] = titleController.text;
                  newsList[index]['summary'] = summaryController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  void _editReport(int index) {
    final report = officialReports[index];
    final TextEditingController titleController = TextEditingController(
      text: report['title'],
    );
    final TextEditingController summaryController = TextEditingController(
      text: report['summary'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل التقرير'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'عنوان التقرير'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: summaryController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'الملخص'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  officialReports[index]['title'] = titleController.text;
                  officialReports[index]['summary'] = summaryController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  void _editFAQ(int index) {
    final faq = adminFAQData[index];
    final TextEditingController questionController = TextEditingController(
      text: faq['question'],
    );
    final TextEditingController answerController = TextEditingController(
      text: faq['answer'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل السؤال الشائع'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(labelText: 'السؤال'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: answerController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'الإجابة'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  adminFAQData[index]['question'] = questionController.text;
                  adminFAQData[index]['answer'] = answerController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewsManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إدارة الأخبار',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            _addNews();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
          ),
          child: const Text('إضافة خبر جديد'),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              return Card(
                child: ListTile(
                  title: Text(news['title']!),
                  subtitle: Text('${news['date']} - ${news['time']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editNews(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            newsList.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _addNews() {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('إضافة خبر جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'عنوان الخبر'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: summaryController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'الملخص'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              String formattedDate = DateFormat('d MMMM yyyy', 'ar').format(DateTime.now());
              String formattedTime = DateFormat('hh:mm a', 'ar').format(DateTime.now());

              setState(() {
                newsList.add({
                  'title': titleController.text,
                  'date': formattedDate,
                  'time': formattedTime,
                  'summary': summaryController.text,
                  'content': '',
                });
              });
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      );
    },
  );
}

  Widget _buildReportsManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إدارة التقارير الرسمية',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            _addReport();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
          ),
          child: const Text('إضافة تقرير جديد'),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            itemCount: officialReports.length,
            itemBuilder: (context, index) {
              final report = officialReports[index];
              return Card(
                child: ListTile(
                  title: Text(report['title']),
                  subtitle: Text(report['date']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editReport(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            officialReports.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _addReport() {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('إضافة تقرير جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'عنوان التقرير'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: summaryController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'الملخص'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              String formattedDate = DateFormat('d MMMM yyyy', 'ar').format(DateTime.now());

              setState(() {
                officialReports.add({
                  'title': titleController.text,
                  'icon': 'description',
                  'date': formattedDate,
                  'author': 'دائرة السير',
                  'summary': summaryController.text,
                  'sections': [],
                  'footer_note': '',
                });
              });
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      );
    },
  );
}

  Widget _buildFAQManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إدارة الأسئلة الشائعة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            _addFAQ();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
          ),
          child: const Text('إضافة سؤال شائع'),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            itemCount: adminFAQData.length,
            itemBuilder: (context, index) {
              final faq = adminFAQData[index];
              return Card(
                child: ListTile(
                  title: Text(faq['question']!),
                  subtitle: Text(faq['answer']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editFAQ(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            adminFAQData.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  void _addFAQ() {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('إضافة سؤال شائع'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: 'السؤال'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: answerController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'الإجابة'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                adminFAQData.add({
                  'question': questionController.text,
                  'answer': answerController.text,
                });
              });
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      );
    },
  );
}

}
