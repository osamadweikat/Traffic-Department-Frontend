import 'package:flutter/material.dart';
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
    'شكوى عن معاملة',
    'مشكلة مع الموظف',
    'مشكلة في الخدمات',
    'اقتراحات لتحسين الخدمات والتطبيق',
  ];

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الإرسال'),
        content: const Text('هل أنت متأكد من إرسال الشكوى؟'),
        actions: [
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('تأكيد'),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم إرسال النموذج بنجاح")),
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
      case 'شكوى عن معاملة':
        return _buildTransactionComplaintForm();
      case 'مشكلة مع الموظف':
        return _buildEmployeeComplaintForm();
      case 'مشكلة في الخدمات':
        return _buildServiceComplaintForm();
      case 'اقتراحات لتحسين الخدمات والتطبيق':
        return _buildSuggestionsForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTransactionComplaintForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField('transactionId', 'رقم المعاملة'),
        const SizedBox(height: 12),
        _buildTextField('description', 'تفاصيل الشكوى', maxLines: 4),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildEmployeeComplaintForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField('employeeName', 'اسم الموظف'),
        const SizedBox(height: 12),
        _buildTextField('description', 'تفاصيل المشكلة', maxLines: 4),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildServiceComplaintForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField('title', 'عنوان المشكلة'),
        const SizedBox(height: 12),
        _buildTextField('description', 'وصف المشكلة بالتفصيل', maxLines: 4),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildSuggestionsForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField('suggestionArea', 'المجال المستهدف (خدمة، تطبيق، تجربة مستخدم)'),
        const SizedBox(height: 12),
        _buildTextField('description', 'وصف الاقتراح', maxLines: 4),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildTextField(String key, String label, {int maxLines = 1}) {
    return TextField(
      controller: controllers[key],
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.send),
      label: const Text("إرسال"),
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

  Widget _buildCategorySelector(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
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
              category,
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الشكاوى والاقتراحات"),
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
                "اختر نوع الشكوى أو الاقتراح:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ...categories.map(_buildCategorySelector),
              _buildFormForSelectedCategory(),
            ],
          ),
        ),
      ),
    );
  }
}
