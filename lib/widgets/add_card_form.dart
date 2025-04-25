import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' as ui;
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

class AddCardForm extends StatefulWidget {
  final void Function(Map<String, String>) onSubmit;
  final bool isPaymentMode;
  final bool showSaveCheckbox;
  const AddCardForm({
    super.key,
    required this.onSubmit,
    this.isPaymentMode = false,
    this.showSaveCheckbox = false,
  });

  @override
  State<AddCardForm> createState() => _AddCardFormState();
}

class _AddCardFormState extends State<AddCardForm> {
  final _formKey = GlobalKey<FormState>();
  String holder = '';
  String number = '';
  String expiry = '';
  String cvv = '';
  String brand = 'Visa';
  bool saveCard = false;

  final TextEditingController numberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String formatCardNumberLTR(String input) {
    final digitsOnly = convertToEnglishDigits(
      input.replaceAll(RegExp(r'[^0-9٠-٩]'), ''),
    );
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length && i < 16; i++) {
      if (i % 4 == 0 && i != 0) buffer.write(' ');
      buffer.write(digitsOnly[i]);
    }
    return buffer.toString();
  }

  String convertToEnglishDigits(String input) {
    final arabicToEnglish = {
      '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4',
      '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9',
    };
    return input.split('').map((e) => arabicToEnglish[e] ?? e).join();
  }

  Future<void> _selectExpiryMonthYear() async {
    final now = DateTime.now();
    final picked = await showMonthPicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      final formatted = DateFormat('MM/yy').format(picked);
      setState(() {
        expiry = formatted;
        dateController.text = formatted;
      });
    }
  }

  @override
  void dispose() {
    numberController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = brand == 'Visa'
        ? LinearGradient(colors: [Colors.blueGrey.shade300, Colors.blueGrey.shade600])
        : const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFB8860B), Colors.black]);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: cardColor,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(brand, style: const TextStyle(color: Colors.white70)),
                    const Icon(Icons.credit_card, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  number.isEmpty ? '**** **** **** ****' : formatCardNumberLTR(number),
                  style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2),
                  textDirection: ui.TextDirection.ltr,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('expiry'.tr(), style: const TextStyle(color: Colors.white70)),
                        Text(expiry.isEmpty ? '--/--' : expiry, style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('cvv'.tr(), style: const TextStyle(color: Colors.white70)),
                        Text(cvv.isEmpty ? '***' : convertToEnglishDigits(cvv), style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(holder.isEmpty ? 'card_holder_name'.tr() : holder, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'card_holder_name'.tr()),
                    onChanged: (val) => setState(() => holder = val),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'required'.tr();
                      if (val.trim().split(' ').length != 2) return 'name_two_parts'.tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: numberController,
                    decoration: InputDecoration(labelText: 'card_number'.tr()),
                    keyboardType: TextInputType.number,
                    textDirection: ui.TextDirection.ltr,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) {
                      final formatted = formatCardNumberLTR(val);
                      numberController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                      setState(() => number = formatted);
                    },
                    validator: (val) =>
                      val == null || convertToEnglishDigits(val).replaceAll(' ', '').length != 16 ? 'card_number_length'.tr() : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dateController,
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'expiry'.tr()),
                          onTap: _selectExpiryMonthYear,
                          validator: (val) => val == null || val.isEmpty ? 'required'.tr() : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'cvv'.tr()),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                          onChanged: (val) => setState(() => cvv = val),
                          validator: (val) => val == null || convertToEnglishDigits(val).length != 3 ? 'cvv_length'.tr() : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCardTypeOption('Visa'),
                      const SizedBox(width: 20),
                      _buildCardTypeOption('Mastercard'),
                    ],
                  ),
                  if (widget.showSaveCheckbox)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: CheckboxListTile(
                        title: Text('save_card_to_my_cards'.tr()),
                        value: saveCard,
                        onChanged: (val) => setState(() => saveCard = val ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final cardData = {
                          'holder': holder,
                          'number': convertToEnglishDigits(number),
                          'expiry': expiry,
                          'cvv': convertToEnglishDigits(cvv),
                          'brand': brand,
                          'saveCard': saveCard.toString(),
                        };
                        widget.onSubmit(cardData);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(widget.isPaymentMode ? 'confirm_payment'.tr() : 'add'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade600,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTypeOption(String type) {
    final selected = brand == type;
    return GestureDetector(
      onTap: () => setState(() => brand = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.amber.shade600 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? Colors.amber : Colors.grey, width: 1.5),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: selected ? Colors.black : Colors.grey.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
