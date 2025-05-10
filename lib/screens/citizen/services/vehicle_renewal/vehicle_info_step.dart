import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VehicleInfoStep extends StatefulWidget {
  final void Function(Map<String, dynamic> data) onStepCompleted;
  final Map<String, dynamic>? prefilledData;

  const VehicleInfoStep({Key? key, required this.onStepCompleted, this.prefilledData}) : super(key: key);

  @override
  VehicleInfoStepState createState() => VehicleInfoStepState();
}

class VehicleInfoStepState extends State<VehicleInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  final _engineCapacityController = TextEditingController();
  final _productionYearController = TextEditingController();
  final _weightController = TextEditingController();
  final _passengerCountController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _fuelTypeController = TextEditingController();

  String? selectedVehicleType;
  String? selectedFuelType;
  bool readOnly = false;

  final List<String> vehicleTypes = [
    'خصوصي', 'عمومي', 'شحن خفيف', 'شحن ثقيل',
    'مركبة نقل وقود/مواد خطرة', 'حافلة نقل عام أو خاصة',
    'مركبة مدارس', 'مركبة حكومية', 'مركبة تأجير',
    'صهريج نضح أو مياه أو حليب', 'دراجة نارية', 'مقطورة', 'جرار'
  ];

  final List<String> fuelTypes = ['بنزين', 'ديزل', 'هايبرد', 'كهرباء'];

  @override
  void initState() {
    super.initState();
    final data = widget.prefilledData;
    if (data != null) {
      readOnly = true;
      _vehicleNumberController.text = data['plateNumber'] ?? '';
      _engineCapacityController.text = data['engineCapacity']?.toString() ?? '';
      _productionYearController.text = data['year']?.toString() ?? '';
      _weightController.text = data['weight']?.toString() ?? '';
      _passengerCountController.text = data['capacity']?.toString() ?? '';
      selectedVehicleType = data['type'];
      _vehicleTypeController.text = selectedVehicleType ?? '';
      selectedFuelType = data['fuel'];
      _fuelTypeController.text = selectedFuelType ?? '';
    }
  }

  bool validateAndSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return false;
    if (selectedVehicleType == null || selectedFuelType == null) return false;

    final requiresWeight = _requiresWeight(selectedVehicleType);
    final requiresPassengerCount = _requiresPassengerCount(selectedVehicleType);

    if (requiresWeight && _weightController.text.isEmpty) return false;
    if (requiresPassengerCount && _passengerCountController.text.isEmpty) return false;

    widget.onStepCompleted({
      'vehicleNumber': _vehicleNumberController.text,
      'vehicleType': selectedVehicleType,
      'fuelType': selectedFuelType,
      'engineCapacity': int.tryParse(_engineCapacityController.text) ?? 0,
      'productionYear': int.tryParse(_productionYearController.text) ?? 0,
      'weight': _weightController.text.isNotEmpty ? int.tryParse(_weightController.text) : null,
      'passengerCount': _passengerCountController.text.isNotEmpty ? int.tryParse(_passengerCountController.text) : null,
    });

    return true;
  }

  bool _requiresWeight(String? type) => ['شحن خفيف', 'شحن ثقيل', 'مقطورة'].contains(type);
  bool _requiresPassengerCount(String? type) => ['مركبة تأجير', 'حافلة نقل عام أو خاصة'].contains(type);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildField(_vehicleNumberController, 'vehicle_number'.tr(), readOnly),
          _buildDropdown(_vehicleTypeController, 'choose_vehicle_type'.tr(), vehicleTypes, selectedVehicleType, readOnly),
          _buildDropdown(_fuelTypeController, 'choose_fuel_type'.tr(), fuelTypes, selectedFuelType, readOnly),
          if (_requiresWeight(selectedVehicleType))
            _buildField(_weightController, 'vehicle_weight'.tr(), readOnly),
          if (_requiresPassengerCount(selectedVehicleType))
            _buildField(_passengerCountController, 'passenger_count'.tr(), readOnly),
          _buildField(_engineCapacityController, 'engine_capacity'.tr(), readOnly),
          _buildField(_productionYearController, 'production_year'.tr(), readOnly, isYear: true),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, bool readOnly, {bool isYear = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly || isYear,
        onTap: isYear && !readOnly ? _selectProductionYear : null,
        keyboardType: TextInputType.number,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: controller.text.isNotEmpty ? const Icon(Icons.check_circle, color: Colors.green) : null,
          filled: controller.text.isNotEmpty,
          fillColor: controller.text.isNotEmpty ? Colors.green.shade50 : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => (value == null || value.isEmpty) ? 'required_field'.tr() : null,
      ),
    );
  }

  Widget _buildDropdown(
  TextEditingController controller,
  String label,
  List<String> items,
  String? selected,
  bool readOnly,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: readOnly
          ? null
          : () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: false,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                backgroundColor: Colors.grey.shade100,
                builder: (_) => Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final value = items[index];
                      final isSelected = controller.text == value;
                      return ListTile(
                        title: Text(
                          value,
                          style: TextStyle(
                            color: isSelected ? Colors.green : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            controller.text = value;
                            if (label == 'choose_vehicle_type'.tr()) selectedVehicleType = value;
                            if (label == 'choose_fuel_type'.tr()) selectedFuelType = value;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              );
            },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: controller.text.isNotEmpty
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        filled: controller.text.isNotEmpty,
        fillColor: controller.text.isNotEmpty ? Colors.green.shade50 : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'required_field'.tr() : null,
    ),
  );
}


  Future<void> _selectProductionYear() async {
    final currentYear = DateTime.now().year;
    final pickedYear = await showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('select_production_year'.tr()),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: currentYear - 1950 + 1,
              itemBuilder: (_, index) {
                final year = currentYear - index;
                return ListTile(
                  title: Text('$year'),
                  onTap: () => Navigator.of(context).pop(year),
                );
              },
            ),
          ),
        );
      },
    );

    if (pickedYear != null) {
      setState(() => _productionYearController.text = pickedYear.toString());
    }
  }
}
