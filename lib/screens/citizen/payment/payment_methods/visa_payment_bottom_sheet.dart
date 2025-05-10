import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:traffic_department/theme/app_theme.dart';
import 'package:traffic_department/widgets/add_card_form.dart';
import 'package:traffic_department/widgets/loading_overlay.dart';
import 'package:traffic_department/widgets/success_dialog.dart';

class VisaPaymentBottomSheet extends StatefulWidget {
  final void Function(Map<String, String> selectedCard) onSubmit;
  const VisaPaymentBottomSheet({super.key, required this.onSubmit});

  @override
  State<VisaPaymentBottomSheet> createState() => _VisaPaymentBottomSheetState();
}

class _VisaPaymentBottomSheetState extends State<VisaPaymentBottomSheet> {
  List<Map<String, String>> allCards = [];
  Map<String, String>? selectedCard;
  bool showAddNewCard = false;

  @override
  void initState() {
    super.initState();
    _loadAllCards();
  }

  Future<void> _loadAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_cards') ?? [];
    final savedCards = saved.map((e) => Map<String, String>.from(json.decode(e))).toList();
    setState(() {
      allCards = savedCards;
    });
  }

  Widget _buildCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('select_card'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (allCards.isEmpty)
          Center(child: Text('no_saved_cards'.tr(), style: const TextStyle(color: Colors.grey))),
        ...allCards.map((card) {
          final isSelected = selectedCard == card;
          return GestureDetector(
            onTap: () => setState(() => selectedCard = card),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: _cardGradient(card['brand'] ?? ''),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? Colors.amber : Colors.transparent, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card['brand'] ?? '', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 10),
                  Text(card['number'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(card['expiry'] ?? '', style: const TextStyle(color: Colors.white)),
                      Text(card['holder'] ?? '', style: const TextStyle(color: Colors.white))
                    ],
                  )
                ],
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => setState(() => showAddNewCard = true),
            child: Text('pay_with_new_card'.tr()),
          ),
        )
      ],
    );
  }

  Gradient _cardGradient(String brand) {
    return brand == 'Visa'
        ? LinearGradient(colors: [Colors.blueGrey.shade300, Colors.blueGrey.shade600])
        : const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFB8860B), Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }

  Future<void> _confirmPayment() async {
    
    showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const LoadingOverlay();
      },
    );

    await Future.delayed(const Duration(seconds: 10));

    Navigator.of(context, rootNavigator: true).pop(); 

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => SuccessDialog(
        onConfirm: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (route) => false);
        },
      ),
    );
  }

  Future<void> _submitSelectedCard() async {
    if (selectedCard != null) {
      await _confirmPayment(); 
      widget.onSubmit(selectedCard!);
    } else {
      _showErrorDialog('please_select_card'.tr());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (_) => AlertDialog(
        title: Text('error'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('payment_with_card'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            if (!showAddNewCard) _buildCards(),
            if (!showAddNewCard)
              const SizedBox(height: 16),
            if (!showAddNewCard)
              ElevatedButton(
                onPressed: _submitSelectedCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('confirm_payment'.tr()),
              ),
            if (showAddNewCard)
              AddCardForm(
                onSubmit: (newCard) async {
                  await _loadAllCards();
                  setState(() {
                    selectedCard = newCard;
                    showAddNewCard = false;
                  });
                  await _submitSelectedCard();
                },
                isPaymentMode: true,
                showSaveCheckbox: true,
              ),
          ],
        ),
      ),
    );
  }
}
