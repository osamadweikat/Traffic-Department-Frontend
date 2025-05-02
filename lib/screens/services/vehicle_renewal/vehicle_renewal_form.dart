import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../theme/app_theme.dart';
import 'vehicle_info_step.dart';
import 'required_documents_step.dart';
import 'request_summary_step.dart';
import 'payment_method_step.dart';

class VehicleLicenseRenewalScreen extends StatefulWidget {
  final Map<String, dynamic>? prefilledData; 

  const VehicleLicenseRenewalScreen({super.key, this.prefilledData}); 

  @override
  State<VehicleLicenseRenewalScreen> createState() => _VehicleLicenseRenewalScreenState();
}

class _VehicleLicenseRenewalScreenState extends State<VehicleLicenseRenewalScreen> {
  int _currentStep = 0;
  List<bool> stepCompleted = [false, false, false, false];

  Map<String, dynamic> vehicleInfoData = {};
  Map<String, File> requiredDocumentsData = {};

  double totalAmount = 0.0;
  bool isShekel = false;

  final GlobalKey<VehicleInfoStepState> _vehicleInfoStepKey = GlobalKey();
  final GlobalKey<RequiredDocumentsStepState> _requiredDocumentsStepKey = GlobalKey();
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
        title: Text('renew_vehicle_license'.tr()),
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
              title: Text('vehicle_info'.tr(), style: TextStyle(color: _getStepColor(0))),
              content: VehicleInfoStep(
                key: _vehicleInfoStepKey,
                prefilledData: widget.prefilledData, 
                onStepCompleted: (data) => vehicleInfoData = data,
              ),
              isActive: _currentStep >= 0,
              state: _getStepState(0),
            ),
            Step(
              title: Text('required_documents'.tr(), style: TextStyle(color: _getStepColor(1))),
              content: RequiredDocumentsStep(
                key: _requiredDocumentsStepKey,
                vehicleInfoData: vehicleInfoData,
                onStepCompleted: (data) => requiredDocumentsData = data,
              ),
              isActive: _currentStep >= 1,
              state: _getStepState(1),
            ),
            Step(
              title: Text('request_summary'.tr(), style: TextStyle(color: _getStepColor(2))),
              content: RequestSummaryStep(
                vehicleInfoData: vehicleInfoData,
                onAmountCalculated: (amount, shekel) {
                  totalAmount = amount;
                  isShekel = shekel;
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
