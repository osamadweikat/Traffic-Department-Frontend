import 'package:flutter/material.dart';
import 'package:traffic_department/widgets/add_card_form.dart';
import '/theme/app_theme.dart';

class ManageCardsScreen extends StatefulWidget {
  const ManageCardsScreen({super.key});

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  List<Map<String, String>> cards = [];
  final List<Map<String, String>> staticCards = [
    {
      'holder': 'محمد خالد الزعبي',
      'number': '1234 5678 9012 3456',
      'expiry': '12/25',
      'cvv': '123',
      'brand': 'Visa',
    },
    {
      'holder': 'أحمد سمير مصطفى',
      'number': '9876 5432 1098 7654',
      'expiry': '08/26',
      'cvv': '456',
      'brand': 'Mastercard',
    },
  ];

  List<Map<String, String>> sessionCards = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  Future<void> _loadSavedCards() async {
    setState(() {
      cards = [...staticCards];
    });
  }

  void _showAddCardForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: AddCardForm(
              onSubmit: (card) async {
                setState(() {
                  cards.add(card);
                  sessionCards.add(card);
                });
              },
            ),
          ),
    );
  }

  void _showCardDetails(Map<String, String> card, int index) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: _cardGradient(card['brand']!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card['brand']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() => cards.removeAt(index));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'رقم البطاقة:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      card['number']!,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      textDirection: TextDirection.ltr,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'تاريخ الانتهاء:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      card['expiry']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text('CVV:', style: TextStyle(color: Colors.white70)),
                    Text(
                      card['cvv']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'اسم صاحب البطاقة:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      card['holder']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Gradient _cardGradient(String brand) {
    return brand == 'Visa'
        ? LinearGradient(
          colors: [Colors.blueGrey.shade300, Colors.blueGrey.shade600],
        )
        : LinearGradient(
          colors: [
            Color(0xFFFFD700), 
            Color(0xFFB8860B),
            Colors.black,
          ],
        );
  }

  String _maskCardNumber(String number) {
    final parts = number.split(' ');
    if (parts.length != 4) return '**** **** **** ****';
    return '**** **** **** ${parts.last}';
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
          onPressed: _showAddCardForm,
          backgroundColor: AppTheme.navy,
          child: const Icon(Icons.add_card, color: Colors.white),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return GestureDetector(
              onTap: () => _showCardDetails(card, index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: _cardGradient(card['brand']!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                height: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card['brand']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.credit_card, color: Colors.white70),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _maskCardNumber(card['number']!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 2,
                        ),
                        textDirection: TextDirection.ltr,
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
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
