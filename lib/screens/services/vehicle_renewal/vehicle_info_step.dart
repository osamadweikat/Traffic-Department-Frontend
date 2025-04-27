import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../theme/app_theme.dart';

class VehicleInfoStep extends StatefulWidget {
  final void Function(Map<String, dynamic> data) onStepCompleted;

  const VehicleInfoStep({Key? key, required this.onStepCompleted}) : super(key: key);

  @override
  VehicleInfoStepState createState() => VehicleInfoStepState();
}

class VehicleInfoStepState extends State<VehicleInfoStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _engineCapacityController = TextEditingController();
  final TextEditingController _productionYearController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _passengerCountController = TextEditingController();

  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();

  String? selectedVehicleType;
  String? selectedFuelType;

  final List<String> vehicleTypes = [
    'خصوصي', 'عمومي', 'شحن خفيف', 'شحن ثقيل',
    'مركبة نقل وقود/مواد خطرة', 'حافلة نقل عام أو خاصة',
    'مركبة مدارس', 'مركبة حكومية', 'مركبة تأجير',
    'صهريج نضح أو مياه أو حليب', 'دراجة نارية', 'مقطورة', 'جرار'
  ];

  final List<String> fuelTypes = [
    'بنزين', 'ديزل', 'هايبرد', 'كهرباء'
  ];

  Future<void> _selectProductionYear() async {
    final currentYear = DateTime.now().year;
    final pickedYear = await showDialog<int>(
      context: context,
      builder: (context) {
        return YearPickerDialog(
          initialYear: currentYear,
          minYear: 1950,
          maxYear: currentYear,
        );
      },
    );

    if (pickedYear != null) {
      _productionYearController.text = pickedYear.toString();
    }
  }

  bool validateAndSave() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (selectedVehicleType == null || selectedFuelType == null) return false;

    final requiresWeight = _requiresWeight(selectedVehicleType);
    final requiresPassengerCount = _requiresPassengerCount(selectedVehicleType);

    if (isValid) {
      if (requiresWeight && (_weightController.text.isEmpty)) return false;
      if (requiresPassengerCount && (_passengerCountController.text.isEmpty)) return false;

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
    return false;
  }

  bool _requiresWeight(String? vehicleType) {
    return vehicleType == 'شحن خفيف' || vehicleType == 'شحن ثقيل' || vehicleType == 'مقطورة';
  }

  bool _requiresPassengerCount(String? vehicleType) {
    return vehicleType == 'مركبة تأجير' || vehicleType == 'حافلة نقل عام أو خاصة';
  }

  void _showBottomSheet({
  required List<String> options,
  required ValueChanged<String> onSelected,
  required String title,
  required String? selected,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6, 
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Flexible( 
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(), 
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = selected == option;
                  return ListTile(
                    title: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? AppTheme.navy : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _vehicleNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'vehicle_number'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
          ),
          const SizedBox(height: 16),

          GestureDetector(
            onTap: () => _showBottomSheet(
              options: vehicleTypes,
              onSelected: (value) => setState(() {
                selectedVehicleType = value;
                _vehicleTypeController.text = value;
              }),
              title: 'choose_vehicle_type'.tr(),
              selected: selectedVehicleType,
            ),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _vehicleTypeController,
                decoration: InputDecoration(
                  labelText: 'choose_vehicle_type'.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => selectedVehicleType == null ? 'required_field'.tr() : null,
              ),
            ),
          ),
          const SizedBox(height: 16),

          GestureDetector(
            onTap: () => _showBottomSheet(
              options: fuelTypes,
              onSelected: (value) => setState(() {
                selectedFuelType = value;
                _fuelTypeController.text = value;
              }),
              title: 'choose_fuel_type'.tr(),
              selected: selectedFuelType,
            ),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _fuelTypeController,
                decoration: InputDecoration(
                  labelText: 'choose_fuel_type'.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => selectedFuelType == null ? 'required_field'.tr() : null,
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (_requiresWeight(selectedVehicleType))
            Column(
              children: [
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'vehicle_weight'.tr(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
                ),
                const SizedBox(height: 16),
              ],
            ),

          if (_requiresPassengerCount(selectedVehicleType))
            Column(
              children: [
                TextFormField(
                  controller: _passengerCountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'passenger_count'.tr(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
                ),
                const SizedBox(height: 16),
              ],
            ),

          TextFormField(
            controller: _engineCapacityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'engine_capacity'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _productionYearController,
            readOnly: true,
            onTap: _selectProductionYear,
            decoration: InputDecoration(
              labelText: 'production_year'.tr(),
              suffixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) => value == null || value.isEmpty ? 'required_field'.tr() : null,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class YearPickerDialog extends StatelessWidget {
  final int initialYear;
  final int minYear;
  final int maxYear;

  const YearPickerDialog({
    Key? key,
    required this.initialYear,
    required this.minYear,
    required this.maxYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('select_production_year'.tr()),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: maxYear - minYear + 1,
          itemBuilder: (context, index) {
            final year = maxYear - index;
            return ListTile(
              title: Text('$year'),
              onTap: () => Navigator.of(context).pop(year),
            );
          },
        ),
      ),
    );
  }
}
