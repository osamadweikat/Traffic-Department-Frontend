import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ModificationFormStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onStepCompleted;
  final Map<String, dynamic>? prefilledData;

  const ModificationFormStep({
    super.key,
    required this.onStepCompleted,
    this.prefilledData,
  });

  @override
  State<ModificationFormStep> createState() => ModificationFormStepState();
}

class ModificationFormStepState extends State<ModificationFormStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> modificationData = {};

  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController modificationTypeController = TextEditingController();

  final List<String> modificationTypes = [
    "تغيير إطارات المركبة",
    "تغيير محرك المركبة",
    "تغيير مبنى المركبة",
    "تغيير لون المركبة"
  ];

  String? selectedModificationType;
  bool readOnly = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledData != null) {
      vehicleNumberController.text = widget.prefilledData!['plateNumber'] ?? '';
      readOnly = true;
    }
  }

  bool validateAndSave() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onStepCompleted(modificationData);
      return true;
    }
    return false;
  }

  List<String> getRequiredDocuments() {
    return modificationTypes.contains(selectedModificationType)
        ? [selectedModificationType!]
        : [];
  }

  @override
  void dispose() {
    vehicleNumberController.dispose();
    notesController.dispose();
    modificationTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildSelectableField(
            controller: modificationTypeController,
            label: 'modification_type'.tr(),
            items: modificationTypes,
            fieldKey: 'modificationType',
            selectedValue: selectedModificationType,
            onSelected: (value) => setState(() => selectedModificationType = value),
          ),
          _buildTextField(
            controller: vehicleNumberController,
            label: 'vehicle_number'.tr(),
            fieldKey: 'vehicleNumber',
            keyboardType: TextInputType.number,
            readOnly: readOnly,
          ),
          _buildTextField(
            controller: notesController,
            label: 'notes'.tr(),
            fieldKey: 'notes',
            required: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String fieldKey,
    bool required = true,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: StatefulBuilder(
        builder: (context, setState) => TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: controller.text.isNotEmpty
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
            filled: controller.text.isNotEmpty,
            fillColor: controller.text.isNotEmpty ? Colors.green.shade50 : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: required
              ? (value) => (value == null || value.isEmpty) ? 'required_field'.tr() : null
              : null,
          onSaved: (value) => modificationData[fieldKey] = value,
        ),
      ),
    );
  }

  Widget _buildSelectableField({
    required TextEditingController controller,
    required String label,
    required List<String> items,
    required String fieldKey,
    String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _showOptionsBottomSheet(controller, items, selectedValue, onSelected),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: controller.text.isNotEmpty
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
          filled: controller.text.isNotEmpty,
          fillColor: controller.text.isNotEmpty ? Colors.green.shade50 : null,
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'required_field'.tr() : null,
        onSaved: (value) => modificationData[fieldKey] = value,
      ),
    );
  }

  void _showOptionsBottomSheet(TextEditingController controller, List<String> options, String? selectedValue, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          itemCount: options.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final isSelected = selectedValue == options[index];
            return ListTile(
              title: Text(
                options[index],
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                controller.text = options[index];
                onSelected(options[index]);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
