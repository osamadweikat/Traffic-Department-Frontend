import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VehicleInfoNewRegistrationStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onStepCompleted;

  const VehicleInfoNewRegistrationStep({Key? key, required this.onStepCompleted}) : super(key: key);

  @override
  State<VehicleInfoNewRegistrationStep> createState() => VehicleInfoNewRegistrationStepState();
}

class VehicleInfoNewRegistrationStepState extends State<VehicleInfoNewRegistrationStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> vehicleData = {};

  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController brandModelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController chassisNumberController = TextEditingController();
  final TextEditingController engineNumberController = TextEditingController();
  final TextEditingController engineCapacityController = TextEditingController(); 
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController passengerCapacityController = TextEditingController();

  final List<String> vehicleTypes = [
    "خصوصي",
    "شاحنة", "خلاطة/مضخة باطون", "صهريج حليب", "ناقلة وقود/مواد خطرة", "مركبة إطفاء",
    "حافلة سياحية/خاصة", "هياكل عمومية - تاكسي/حافلة برخصة جديدة", "هياكل عمومية - هيكل بدل هيكل",
    "مركبة تدريب سياقة", "مركبة إسعاف/عيادة متنقلة", "مركبة روضة/مدرسة", "مركبة حكومية",
    "مركبة جمعيات أهلية أو أجنبية", "تراكتور زراعي", "مركبة جر وتخليص/ناقلة سيارات",
    "مركبة تأجير", "مركبة نقل أموال", "صهريج نضح", "مركبة نفايات", "صهريج مياه"
  ];

  final List<String> fuelTypes = ["بنزين", "ديزل", "هايبرد", "كهرباء"];

  String? selectedVehicleType;
  String? selectedFuelType;
  String? selectedYear;

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
    vehicleTypeController.dispose();
    brandModelController.dispose();
    yearController.dispose();
    chassisNumberController.dispose();
    engineNumberController.dispose();
    engineCapacityController.dispose(); 
    fuelTypeController.dispose();
    weightController.dispose();
    passengerCapacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildSelectableField(
            controller: vehicleTypeController,
            label: "vehicle_type".tr(),
            items: vehicleTypes,
            fieldKey: "vehicleType",
            selectedValue: selectedVehicleType,
            onSelected: (value) => setState(() => selectedVehicleType = value),
          ),
          _buildTextField(
            controller: brandModelController,
            label: "brand_model".tr(),
            fieldKey: "brandModel",
          ),
          _buildYearField(
            controller: yearController,
            label: "manufacture_year".tr(),
            fieldKey: "manufactureYear",
          ),
          _buildTextField(
            controller: chassisNumberController,
            label: "chassis_number".tr(),
            fieldKey: "chassisNumber",
          ),
          _buildTextField(
            controller: engineNumberController,
            label: "engine_number".tr(),
            fieldKey: "engineNumber",
          ),
          _buildNumberField(
            controller: engineCapacityController,
            label: "engine_capacity".tr(),
            fieldKey: "engineCapacity",
          ),
          _buildSelectableField(
            controller: fuelTypeController,
            label: "fuel_type".tr(),
            items: fuelTypes,
            fieldKey: "fuelType",
            selectedValue: selectedFuelType,
            onSelected: (value) => setState(() => selectedFuelType = value),
          ),
          _buildNumberField(
            controller: weightController,
            label: "vehicle_weight".tr(),
            fieldKey: "weight",
          ),
          _buildNumberField(
            controller: passengerCapacityController,
            label: "passenger_capacity".tr(),
            fieldKey: "passengerCapacity",
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "required_field".tr();
          }
          return null;
        },
        onSaved: (value) {
          vehicleData[fieldKey] = value;
        },
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "required_field".tr();
          }
          return null;
        },
        onSaved: (value) {
          vehicleData[fieldKey] = value;
        },
      ),
    );
  }

  Widget _buildYearField({
    required TextEditingController controller,
    required String label,
    required String fieldKey,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _showYearPicker(controller),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "required_field".tr();
          }
          return null;
        },
        onSaved: (value) {
          vehicleData[fieldKey] = value;
        },
      ),
    );
  }

  Future<void> _showYearPicker(TextEditingController controller) async {
    int currentYear = DateTime.now().year;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text("اختر سنة الإنتاج", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: currentYear - 1950 + 1,
                itemBuilder: (context, index) {
                  int year = currentYear - index;
                  return ListTile(
                    title: Text(year.toString()),
                    onTap: () {
                      controller.text = year.toString();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "required_field".tr();
          }
          return null;
        },
        onSaved: (value) {
          vehicleData[fieldKey] = value;
        },
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
