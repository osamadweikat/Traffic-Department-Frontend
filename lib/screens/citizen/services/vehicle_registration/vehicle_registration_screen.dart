import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_registration/vehicle_info_new_registration_step.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_registration/required_documents_new_vehicle_step.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_registration/request_summary_new_step.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_renewal/payment_method_step.dart';
import '../../../../theme/app_theme.dart';

class VehicleRegistrationNewScreen extends StatefulWidget {
  const VehicleRegistrationNewScreen({super.key});

  @override
  State<VehicleRegistrationNewScreen> createState() => _VehicleRegistrationNewScreenState();
}

class _VehicleRegistrationNewScreenState extends State<VehicleRegistrationNewScreen> {
  int _currentStep = 0;
  List<bool> stepCompleted = [false, false, false, false];

  Map<String, dynamic> vehicleInfoData = {};
  Map<String, File> requiredDocumentsData = {};

  double totalAmount = 0.0;
  bool isShekel = false;

  final GlobalKey<VehicleInfoNewRegistrationStepState> _vehicleInfoStepKey = GlobalKey();
  final GlobalKey<RequiredDocumentsNewVehicleStepState> _requiredDocumentsStepKey = GlobalKey();
  final GlobalKey<PaymentMethodStepState> _paymentMethodStepKey = GlobalKey();

  void _onStepContinue() async {
    if (_currentStep == 0) {
      if (_vehicleInfoStepKey.currentState?.validateAndSave() ?? false) {
        setState(() {
          stepCompleted[_currentStep] = true;
          _currentStep++;
        });
      }
    } else if (_currentStep == 1) {
      if (_requiredDocumentsStepKey.currentState?.validateDocuments() ?? false) {
        setState(() {
          stepCompleted[_currentStep] = true;
          _currentStep++;
        });
      }
    } else if (_currentStep == 2) {
      setState(() {
        stepCompleted[_currentStep] = true;
        _currentStep++;
      });
    } else if (_currentStep == 3) {
      await _paymentMethodStepKey.currentState?.continueToSelectedPayment();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        stepCompleted[_currentStep - 1] = false;
        _currentStep--;
      });
    }
  }

  StepState _getStepState(int step) => stepCompleted[step] ? StepState.complete : StepState.indexed;

  Color _getStepColor(int step) => stepCompleted[step] ? Colors.green : Colors.black87;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('new_vehicle_registration'.tr()),
        centerTitle: true,
        backgroundColor: AppTheme.navy,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: Colors.green),
        ),
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.navy,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text('next'.tr(), style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.navy),
                      ),
                      child: Text('back'.tr(), style: TextStyle(color: AppTheme.navy)),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text('vehicle_information'.tr(), style: TextStyle(color: _getStepColor(0))),
              content: VehicleInfoNewRegistrationStep(
                key: _vehicleInfoStepKey,
                onStepCompleted: (data) {
                  vehicleInfoData = data;
                },
              ),
              isActive: _currentStep >= 0,
              state: _getStepState(0),
            ),
            Step(
              title: Text('required_documents'.tr(), style: TextStyle(color: _getStepColor(1))),
              content: RequiredDocumentsNewVehicleStep(
                key: _requiredDocumentsStepKey,
                vehicleInfo: vehicleInfoData,
                onStepCompleted: (data) {
                  requiredDocumentsData = data;
                },
              ),
              isActive: _currentStep >= 1,
              state: _getStepState(1),
            ),
            Step(
              title: Text('request_summary'.tr(), style: TextStyle(color: _getStepColor(2))),
              content: RequestSummaryNewStep(
                vehicleInfoData: vehicleInfoData,
                onAmountCalculated: (amount, selectedIsShekel) {
                  totalAmount = amount;
                  isShekel = selectedIsShekel;
                },
              ),
              isActive: _currentStep >= 2,
              state: _getStepState(2),
            ),
            Step(
              title: Text('payment_method'.tr(), style: TextStyle(color: _getStepColor(3))),
              content: PaymentMethodStep(
                key: _paymentMethodStepKey,
                totalAmount: totalAmount,
                isShekel: isShekel,
              ),
              isActive: _currentStep >= 3,
              state: _getStepState(3),
            ),
          ],
        ),
      ),
    );
  }
}
