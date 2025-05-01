import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VehicleMortgageReleaseFormStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onStepCompleted;

  const VehicleMortgageReleaseFormStep({super.key, required this.onStepCompleted});

  @override
  State<VehicleMortgageReleaseFormStep> createState() => VehicleMortgageReleaseFormStepState();
}

class VehicleMortgageReleaseFormStepState extends State<VehicleMortgageReleaseFormStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};

  final TextEditingController ownerIdController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController actionTypeController = TextEditingController();

  final List<String> actionTypes = ['mortgage'.tr(), 'release'.tr()];
  String? selectedActionType;

  @override
  void dispose() {
    ownerIdController.dispose();
    ownerNameController.dispose();
    plateNumberController.dispose();
    actionTypeController.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      formData['ownerId'] = ownerIdController.text.trim();
      formData['ownerName'] = ownerNameController.text.trim();
      formData['plateNumber'] = plateNumberController.text.trim();
      formData['isRelease'] = selectedActionType == 'release'.tr();

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
          _buildSelectableField(
            controller: actionTypeController,
            label: 'mortgage_action_type'.tr(),
            items: actionTypes,
            selectedValue: selectedActionType,
            onSelected: (value) {
              setState(() {
                selectedActionType = value;
                actionTypeController.text = value;
              });
            },
          ),
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

  Widget _buildSelectableField({
    required TextEditingController controller,
    required String label,
    required List<String> items,
    required String? selectedValue,
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
        ),
        validator: (value) => (value == null || value.isEmpty) ? 'required_field'.tr() : null,
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
