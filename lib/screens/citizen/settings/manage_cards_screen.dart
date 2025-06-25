import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' as ui;
import 'package:traffic_department/widgets/add_card_form.dart';
import 'package:easy_localization/easy_localization.dart';
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

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_cards');

    if (saved == null || saved.isEmpty) {
      final staticEncoded = staticCards.map((card) => json.encode(card)).toList();
      await prefs.setStringList('saved_cards', staticEncoded);
      cards = [...staticCards];
    } else {
      cards = saved.map((e) => Map<String, String>.from(json.decode(e))).toList();
    }

    setState(() {});
  }

  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = cards.map((card) => json.encode(card)).toList();
    await prefs.setStringList('saved_cards', encoded);
  }

  void _showAddCardForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
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
            });
            await _saveCards();
          },
        ),
      ),
    );
  }

  void _showCardDetails(Map<String, String> card, int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
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
                      icon: const Icon(Icons.delete_outline, color: Colors.white),
                      onPressed: () async {
                        setState(() => cards.removeAt(index));
                        await _saveCards();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('card_number'.tr(), style: const TextStyle(color: Colors.white70)),
                Text(
                  card['number']!,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  textDirection: ui.TextDirection.ltr,
                ),
                const SizedBox(height: 10),
                Text('expiry_date'.tr(), style: const TextStyle(color: Colors.white70)),
                Text(card['expiry']!, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                Text('cvv'.tr(), style: const TextStyle(color: Colors.white70)),
                Text(card['cvv']!, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                Text('cardholder_name'.tr(), style: const TextStyle(color: Colors.white70)),
                Text(card['holder']!, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Gradient _cardGradient(String brand) {
    return brand == 'Visa'
        ? LinearGradient(colors: [Colors.blueGrey.shade300, Colors.blueGrey.shade600])
        : LinearGradient(colors: [const Color(0xFFFFD700), const Color(0xFFB8860B), Colors.black]);
  }

  String _maskCardNumber(String number) {
    final parts = number.split(' ');
    if (parts.length != 4) return '**** **** **** ****';
    return '**** **** **** ${parts.last}';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('my_cards'.tr()),
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddCardForm,
          backgroundColor: AppTheme.navy,
          child: const Icon(Icons.add_card, color: Colors.white),
        ),
        body: cards.isEmpty
            ? Center(child: Text('no_saved_cards'.tr(), style: const TextStyle(color: Colors.grey)))
            : ListView.builder(
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
                                style: const TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                              const Icon(Icons.credit_card, color: Colors.white70),
                            ],
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _maskCardNumber(card['number']!),
                              style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2),
                              textDirection: ui.TextDirection.ltr,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                card['holder']!,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
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
