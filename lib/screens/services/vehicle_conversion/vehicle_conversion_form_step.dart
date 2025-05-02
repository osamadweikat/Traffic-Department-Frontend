import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VehicleConversionFormStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onStepCompleted;
  final Map<String, dynamic>? prefilledData;

  const VehicleConversionFormStep({
    super.key,
    required this.onStepCompleted,
    this.prefilledData,
  });

  @override
  State<VehicleConversionFormStep> createState() => VehicleConversionFormStepState();
}

class VehicleConversionFormStepState extends State<VehicleConversionFormStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};

  final TextEditingController ownerIdController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController targetTypeController = TextEditingController();

  final List<String> targetTypes = ['خصوصي', 'تجاري'];
  String? selectedTargetType;

  bool colorChanged = false;
  bool structureChanged = false;
  bool readOnly = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledData != null) {
      ownerIdController.text = widget.prefilledData!['ownerId'] ?? '';
      ownerNameController.text = widget.prefilledData!['ownerName'] ?? '';
      plateNumberController.text = widget.prefilledData!['plateNumber'] ?? '';
      readOnly = true;
    }
  }

  @override
  void dispose() {
    ownerIdController.dispose();
    ownerNameController.dispose();
    plateNumberController.dispose();
    targetTypeController.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      formData['conversionType'] = selectedTargetType;
      formData['colorChanged'] = colorChanged;
      formData['structureChanged'] = structureChanged;

      widget.onStepCompleted(formData);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(ownerIdController, 'owner_id', 'ownerId', readOnly),
          _buildTextField(ownerNameController, 'owner_name', 'ownerName', readOnly),
          _buildTextField(plateNumberController, 'plate_number', 'plateNumber', readOnly),
          _buildSelectableField(
            controller: targetTypeController,
            label: 'target_vehicle_type1'.tr(),
            items: targetTypes,
            fieldKey: 'conversionType',
            selectedValue: selectedTargetType,
            onSelected: (value) {
              setState(() {
                selectedTargetType = value;
                targetTypeController.text = value;
                formData['conversionType'] = value;
              });
            },
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: colorChanged,
            onChanged: (value) => setState(() => colorChanged = value ?? false),
            title: Text('color_changed'.tr()),
          ),
          CheckboxListTile(
            value: structureChanged,
            onChanged: (value) => setState(() => structureChanged = value ?? false),
            title: Text('structure_changed'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelKey,
    String fieldKey,
    bool readOnly,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: StatefulBuilder(
        builder: (context, setState) => TextFormField(
          controller: controller,
          readOnly: readOnly,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: labelKey.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: controller.text.isNotEmpty
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
            filled: controller.text.isNotEmpty,
            fillColor: controller.text.isNotEmpty ? Colors.green.shade50 : null,
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'required_field'.tr() : null,
          onSaved: (value) => formData[fieldKey] = value,
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
        onSaved: (value) => formData[fieldKey] = value,
      ),
    );
  }

  void _showOptionsBottomSheet(
    TextEditingController controller,
    List<String> options,
    String? selectedValue,
    Function(String) onSelected,
  ) {
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
            final value = options[index];
            final isSelected = value == selectedTargetType;
            return ListTile(
              title: Text(
                value,
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                controller.text = value;
                onSelected(value);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
