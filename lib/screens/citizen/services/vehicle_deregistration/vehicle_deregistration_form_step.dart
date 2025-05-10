import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VehicleDeregistrationFormStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onStepCompleted;
  final Map<String, dynamic>? prefilledData;

  const VehicleDeregistrationFormStep({
    super.key,
    required this.onStepCompleted,
    this.prefilledData,
  });

  @override
  State<VehicleDeregistrationFormStep> createState() => VehicleDeregistrationFormStepState();
}

class VehicleDeregistrationFormStepState extends State<VehicleDeregistrationFormStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};

  final TextEditingController ownerIdController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();

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
    super.dispose();
  }

  bool validateAndSave() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      formData['ownerId'] = ownerIdController.text.trim();
      formData['ownerName'] = ownerNameController.text.trim();
      formData['plateNumber'] = plateNumberController.text.trim();

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
          _buildTextField(ownerIdController, 'owner_id', readOnly),
          _buildTextField(ownerNameController, 'owner_name', readOnly),
          _buildTextField(plateNumberController, 'plate_number', readOnly),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelKey, bool readOnly) {
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
        ),
      ),
    );
  }
}
