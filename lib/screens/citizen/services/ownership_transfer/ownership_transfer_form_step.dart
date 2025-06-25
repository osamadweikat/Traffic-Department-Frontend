import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OwnershipTransferFormStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onStepCompleted;
  final Map<String, dynamic>? prefilledData;

  const OwnershipTransferFormStep({super.key, required this.onStepCompleted, this.prefilledData});

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

  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledData != null) {
      currentOwnerIdController.text = widget.prefilledData!["ownerId"] ?? '';
      currentOwnerNameController.text = widget.prefilledData!["ownerName"] ?? '';
      vehicleTypeController.text = widget.prefilledData!["type"] ?? '';
      selectedVehicleType = widget.prefilledData!["type"];
      fuelTypeController.text = widget.prefilledData!["fuel"] ?? '';
      selectedFuelType = widget.prefilledData!["fuel"];
      isReadOnly = true;
    }
  }

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
          _buildTextField(currentOwnerIdController, 'current_owner_id'.tr(), 'currentOwnerId', isReadOnly),
          _buildTextField(currentOwnerNameController, 'current_owner_name'.tr(), 'currentOwnerName', isReadOnly),
          _buildTextField(buyerIdController, 'buyer_id'.tr(), 'buyerId', false, isNumber: true),
          _buildTextField(buyerNameController, 'buyer_name'.tr(), 'buyerName', false),
          _buildDropdown(vehicleTypeController, 'vehicle_type'.tr(), vehicleTypes, 'vehicleType', selectedVehicleType, (value) => setState(() => selectedVehicleType = value), isReadOnly),
          _buildDropdown(fuelTypeController, 'fuel_type'.tr(), fuelTypes, 'fuelType', selectedFuelType, (value) => setState(() => selectedFuelType = value), isReadOnly),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String fieldKey, bool readOnly, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: StatefulBuilder(
        builder: (context, setState) => TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: controller.text.isNotEmpty ? const Icon(Icons.check_circle, color: Colors.green) : null,
            filled: controller.text.isNotEmpty,
            fillColor: controller.text.isNotEmpty ? Colors.green.shade50 : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
          onSaved: (value) => vehicleData[fieldKey] = value,
        ),
      ),
    );
  }

  Widget _buildDropdown(
    TextEditingController controller,
    String label,
    List<String> items,
    String fieldKey,
    String? selectedValue,
    Function(String) onSelected,
    bool readOnly,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: readOnly ? null : () => _showOptionsBottomSheet(controller, items, selectedValue, onSelected),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: controller.text.isNotEmpty ? const Icon(Icons.check_circle, color: Colors.green) : null,
          filled: controller.text.isNotEmpty,
          fillColor: controller.text.isNotEmpty ? Colors.green.shade50 : null,
        ),
        validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
        onSaved: (value) => vehicleData[fieldKey] = value,
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
