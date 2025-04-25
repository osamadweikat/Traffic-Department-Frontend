import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../theme/app_theme.dart';

class PaymentFormSheet extends StatefulWidget {
  const PaymentFormSheet({super.key});

  @override
  State<PaymentFormSheet> createState() => _PaymentFormSheetState();
}

class _PaymentFormSheetState extends State<PaymentFormSheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _expiryDate = TextEditingController();
  final TextEditingController _cvv = TextEditingController();
  final TextEditingController _cardHolder = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardNumber.dispose();
    _expiryDate.dispose();
    _cvv.dispose();
    _cardHolder.dispose();
    super.dispose();
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('payment_success'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('card_payment'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _cardNumber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'card_number'.tr(),
                      prefixIcon: const Icon(Icons.credit_card),
                    ),
                    validator: (value) => value!.length < 16 ? 'invalid_card'.tr() : null,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryDate,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            labelText: 'expiry_date'.tr(),
                            prefixIcon: const Icon(Icons.date_range),
                          ),
                          validator: (value) => value!.isEmpty ? 'required'.tr() : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _cvv,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'cvv'.tr(),
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          validator: (value) => value!.length < 3 ? 'invalid_cvv'.tr() : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _cardHolder,
                    decoration: InputDecoration(
                      labelText: 'card_holder'.tr(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) => value!.isEmpty ? 'required'.tr() : null,
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.navy,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'submit'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
