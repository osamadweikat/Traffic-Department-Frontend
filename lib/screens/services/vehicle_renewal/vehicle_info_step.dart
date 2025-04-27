// 🚀 ثاني كود: VehicleInfoStep (معلومات المركبة مع التحقق البصري)

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

  String? selectedVehicleType;
  String? selectedFuelType;

  bool showVehicleTypeError = false;
  bool showFuelTypeError = false;

  final List<String> vehicleTypes = [
    'خصوصي',
    'عمومي',
    'شحن خفيف',
    'شحن ثقيل',
    'مركبة نقل وقود/مواد خطرة',
    'حافلة نقل عام أو خاصة',
    'مركبة مدارس',
    'مركبة حكومية',
    'مركبة تأجير',
    'صهريج نضح أو مياه أو حليب',
  ];

  final List<String> fuelTypes = [
    'بنزين',
    'ديزل',
    'هايبرد',
    'كهرباء',
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
    setState(() {
      showVehicleTypeError = selectedVehicleType == null;
      showFuelTypeError = selectedFuelType == null;
    });

    if (isValid && !showVehicleTypeError && !showFuelTypeError) {
      widget.onStepCompleted({
        'vehicleNumber': _vehicleNumberController.text,
        'vehicleType': selectedVehicleType,
        'fuelType': selectedFuelType,
        'engineCapacity': int.tryParse(_engineCapacityController.text) ?? 0,
        'productionYear': int.tryParse(_productionYearController.text) ?? 0,
      });
      return true;
    }
    return false;
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

          Text('choose_vehicle_type'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildSelectionList(vehicleTypes, selectedVehicleType, (value) {
            setState(() {
              selectedVehicleType = value;
              showVehicleTypeError = false;
            });
          }, showVehicleTypeError),
          const SizedBox(height: 16),

          Text('choose_fuel_type'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildSelectionList(fuelTypes, selectedFuelType, (value) {
            setState(() {
              selectedFuelType = value;
              showFuelTypeError = false;
            });
          }, showFuelTypeError),
          const SizedBox(height: 16),

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

  Widget _buildSelectionList(List<String> options, String? selectedValue, ValueChanged<String> onSelected, bool showError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final bool isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onSelected(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.navy.withOpacity(0.1) : Colors.white,
                  border: Border.all(color: isSelected ? AppTheme.navy : (showError ? Colors.red : Colors.grey.shade400)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? AppTheme.navy : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              'required_field'.tr(),
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
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
