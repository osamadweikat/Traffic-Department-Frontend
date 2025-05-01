import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VehicleDeregistrationFormStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onStepCompleted;

  const VehicleDeregistrationFormStep({super.key, required this.onStepCompleted});

  @override
  State<VehicleDeregistrationFormStep> createState() => VehicleDeregistrationFormStepState();
}

class VehicleDeregistrationFormStepState extends State<VehicleDeregistrationFormStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};

  final TextEditingController ownerIdController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();

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
          _buildTextField(ownerIdController, 'owner_id'),
          _buildTextField(ownerNameController, 'owner_name'),
          _buildTextField(plateNumberController, 'plate_number'),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelKey.tr(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => (value == null || value.isEmpty) ? 'required_field'.tr() : null,
      ),
    );
  }
}
