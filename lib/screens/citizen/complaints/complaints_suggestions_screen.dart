import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '/theme/app_theme.dart';

class ComplaintsSuggestionsScreen extends StatefulWidget {
  const ComplaintsSuggestionsScreen({super.key});

  @override
  State<ComplaintsSuggestionsScreen> createState() => _ComplaintsSuggestionsScreenState();
}

class _ComplaintsSuggestionsScreenState extends State<ComplaintsSuggestionsScreen> {
  String? _selectedCategory;
  final Map<String, TextEditingController> controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
    'transactionId': TextEditingController(),
    'employeeName': TextEditingController(),
    'suggestionArea': TextEditingController(),
  };

  final List<String> categories = [
    'complaint_transaction',
    'complaint_employee',
    'complaint_services',
    'suggestions_improvement',
  ];

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('confirm_send_title').tr(),
        content: const Text('confirm_send_message').tr(),
        actions: [
          TextButton(
            child: const Text('cancel').tr(),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('confirm').tr(),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text("form_sent_success").tr()),
              );
              controllers.forEach((key, controller) => controller.clear());
              setState(() => _selectedCategory = null);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormForSelectedCategory() {
    if (_selectedCategory == null) return const SizedBox.shrink();

    switch (_selectedCategory) {
      case 'complaint_transaction':
        return _buildTransactionComplaintForm();
      case 'complaint_employee':
        return _buildEmployeeComplaintForm();
      case 'complaint_services':
        return _buildServiceComplaintForm();
      case 'suggestions_improvement':
        return _buildSuggestionsForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTransactionComplaintForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField('transactionId', 'transaction_number'),
        const SizedBox(height: 12),
        _buildTextField('description', 'complaint_details', maxLines: 4),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildEmployeeComplaintForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField('employeeName', 'employee_name'),
        const SizedBox(height: 12),
        _buildTextField('description', 'problem_details', maxLines: 4),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildServiceComplaintForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField('title', 'problem_title'),
        const SizedBox(height: 12),
        _buildTextField('description', 'problem_description', maxLines: 4),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildSuggestionsForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField('suggestionArea', 'suggestion_area'),
        const SizedBox(height: 12),
        _buildTextField('description', 'suggestion_description', maxLines: 4),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildTextField(String key, String labelKey, {int maxLines = 1}) {
    return TextField(
      controller: controllers[key],
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelKey.tr(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.send),
      label: const Text("send").tr(),
      onPressed: _showConfirmDialog,
      style: ElevatedButton.styleFrom(
        foregroundColor: AppTheme.navy,
        backgroundColor: AppTheme.yellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 4,
      ),
    );
  }

  Widget _buildCategorySelector(String categoryKey) {
    final isSelected = _selectedCategory == categoryKey;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = categoryKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.yellow.withOpacity(0.15) : Colors.white,
          border: Border.all(color: isSelected ? AppTheme.navy : Colors.grey),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [BoxShadow(color: AppTheme.navy.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryKey.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.navy : Colors.black87,
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppTheme.navy)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("complaints_suggestions").tr(),
        centerTitle: true,
        backgroundColor: AppTheme.navy,
      ),
      backgroundColor: AppTheme.lightGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "select_complaint_type",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ).tr(),
            const SizedBox(height: 10),
            ...categories.map(_buildCategorySelector),
            _buildFormForSelectedCategory(),
          ],
        ),
      ),
    );
  }
}
