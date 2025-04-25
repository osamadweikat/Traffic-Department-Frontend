import 'package:flutter/material.dart';
import '/theme/app_theme.dart';

class ManageCardsScreen extends StatefulWidget {
  const ManageCardsScreen({super.key});

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> cards = [
    {
      'holder': 'محمد خالد الزعبي',
      'number': '**** **** **** 1234',
      'expiry': '12/25',
      'brand': 'Visa',
    },
    {
      'holder': 'أحمد سمير مصطفى',
      'number': '**** **** **** 5678',
      'expiry': '08/26',
      'brand': 'Mastercard',
    },
  ];

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAddCardDialog() {
    String holder = '';
    String number = '';
    String expiry = '';
    String brand = 'Visa';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة بطاقة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'اسم صاحب البطاقة'),
              onChanged: (val) => holder = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'رقم البطاقة'),
              onChanged: (val) => number = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'تاريخ الانتهاء'),
              onChanged: (val) => expiry = val,
            ),
            DropdownButton<String>(
              value: brand,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Visa', child: Text('Visa')),
                DropdownMenuItem(value: 'Mastercard', child: Text('Mastercard')),
              ],
              onChanged: (val) {
                if (val != null) brand = val;
                setState(() {});
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            onPressed: () {
              if (holder.isNotEmpty && number.isNotEmpty && expiry.isNotEmpty) {
                setState(() {
                  cards.add({
                    'holder': holder,
                    'number': number,
                    'expiry': expiry,
                    'brand': brand,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          )
        ],
      ),
    );
  }

  void _removeCard(int index) {
    setState(() {
      cards.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بطاقاتي'),
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddCardDialog,
          backgroundColor: AppTheme.navy,
          child: const Icon(Icons.add),
        ),
        body: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideIn,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: AppTheme.navy,
                  elevation: 6,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        height: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card['brand']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              card['number']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  card['holder']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  card['expiry']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white),
                          onPressed: () => _removeCard(index),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
