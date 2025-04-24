import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '/theme/app_theme.dart';
import 'package:traffic_department/screens/contact/contact_us_screen.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, String>> faqs = [
    {
      "category": "transactions",
      "question": "faq_1_q",
      "answer": "faq_1_a"
    },
    {
      "category": "vehicles",
      "question": "faq_2_q",
      "answer": "faq_2_a"
    },
    {
      "category": "vehicles",
      "question": "faq_3_q",
      "answer": "faq_3_a"
    },
    {
      "category": "complaints",
      "question": "faq_4_q",
      "answer": "faq_4_a"
    },
    {
      "category": "transactions",
      "question": "faq_5_q",
      "answer": "faq_5_a"
    },
    {
      "category": "app",
      "question": "faq_6_q",
      "answer": "faq_6_a"
    },
    {
      "category": "account",
      "question": "faq_7_q",
      "answer": "faq_7_a"
    },
    {
      "category": "general",
      "question": "faq_8_q",
      "answer": "faq_8_a"
    },
    {
      "category": "app",
      "question": "faq_9_q",
      "answer": "faq_9_a"
    },
    {
      "category": "app",
      "question": "faq_10_q",
      "answer": "faq_10_a"
    },
  ];

  String _searchQuery = '';
  String _selectedCategory = 'all';

  List<String> get categories => ["all", ...{...faqs.map((f) => f['category']!).toSet()}];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = faqs.where((faq) {
      final matchesCategory = _selectedCategory == "all" || faq['category'] == _selectedCategory;
      final matchesSearch = tr(faq['question']!).toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("faq_title").tr(),
        backgroundColor: AppTheme.navy,
        centerTitle: true,
      ),
      backgroundColor: AppTheme.lightGrey,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "search_question".tr(),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text("category_$cat".tr()),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: AppTheme.navy,
                    backgroundColor: Colors.grey[300],
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredFaqs.isEmpty
                ? Center(child: Text("no_results".tr()))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFaqs.length,
                    itemBuilder: (context, index) {
                      final item = filteredFaqs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: const Icon(Icons.question_answer_outlined, color: AppTheme.navy),
                            title: Text(
                              tr(item['question']!),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr(item['answer']!),
                                      style: const TextStyle(height: 1.6),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text("was_this_helpful".tr()),
                                        const Spacer(),
                                        IconButton(icon: const Icon(Icons.thumb_up_alt_outlined), onPressed: () {}),
                                        IconButton(icon: const Icon(Icons.thumb_down_alt_outlined), onPressed: () {}),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
              },
              icon: const Icon(Icons.support_agent, color: AppTheme.navy),
              label: const Text("still_need_help").tr(),
            ),
          )
        ],
      ),
    );
  }
}
