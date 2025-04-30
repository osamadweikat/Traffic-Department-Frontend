import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OwnershipTransferFormStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onStepCompleted;

  const OwnershipTransferFormStep({super.key, required this.onStepCompleted});

  @override
  State<OwnershipTransferFormStep> createState() => OwnershipTransferFormStepState();
}

class OwnershipTransferFormStepState extends State<OwnershipTransferFormStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> vehicleData = {};

  final TextEditingController currentOwnerIdController = TextEditingController();
  final TextEditingController currentOwnerNameController = TextEditingController();
  final TextEditingController buyerIdController = TextEditingController();
  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();

  final List<String> vehicleTypes = [
    "خصوصي", "شاحنة", "خلاطة/مضخة باطون", "صهريج حليب", "ناقلة وقود/مواد خطرة",
    "مركبة إطفاء", "حافلة سياحية/خاصة", "هياكل عمومية - تاكسي/حافلة برخصة جديدة",
    "هياكل عمومية - هيكل بدل هيكل", "مركبة تدريب سياقة", "مركبة إسعاف/عيادة متنقلة",
    "مركبة روضة/مدرسة", "مركبة حكومية", "مركبة جمعيات أهلية أو أجنبية", "تراكتور زراعي",
    "مركبة جر وتخليص/ناقلة سيارات", "مركبة تأجير", "مركبة نقل أموال", "صهريج نضح",
    "مركبة نفايات", "صهريج مياه"
  ];

  final List<String> fuelTypes = ["بنزين", "ديزل", "هايبرد", "كهرباء"];

  String? selectedVehicleType;
  String? selectedFuelType;

  bool validateAndSave() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      widget.onStepCompleted(vehicleData);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    currentOwnerIdController.dispose();
    currentOwnerNameController.dispose();
    buyerIdController.dispose();
    buyerNameController.dispose();
    vehicleTypeController.dispose();
    fuelTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNumberField(
            controller: currentOwnerIdController,
            label: 'current_owner_id'.tr(),
            fieldKey: 'currentOwnerId',
          ),
          _buildTextField(
            controller: currentOwnerNameController,
            label: 'current_owner_name'.tr(),
            fieldKey: 'currentOwnerName',
          ),
          _buildNumberField(
            controller: buyerIdController,
            label: 'buyer_id'.tr(),
            fieldKey: 'buyerId',
          ),
          _buildTextField(
            controller: buyerNameController,
            label: 'buyer_name'.tr(),
            fieldKey: 'buyerName',
          ),
          _buildSelectableField(
            controller: vehicleTypeController,
            label: 'vehicle_type'.tr(),
            items: vehicleTypes,
            fieldKey: 'vehicleType',
            selectedValue: selectedVehicleType,
            onSelected: (value) => setState(() => selectedVehicleType = value),
          ),
          _buildSelectableField(
            controller: fuelTypeController,
            label: 'fuel_type'.tr(),
            items: fuelTypes,
            fieldKey: 'fuelType',
            selectedValue: selectedFuelType,
            onSelected: (value) => setState(() => selectedFuelType = value),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String fieldKey,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'required_field'.tr() : null,
        onSaved: (value) => vehicleData[fieldKey] = value,
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String fieldKey,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'required_field'.tr() : null,
        onSaved: (value) => vehicleData[fieldKey] = value,
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
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'required_field'.tr() : null,
        onSaved: (value) => vehicleData[fieldKey] = value,
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
