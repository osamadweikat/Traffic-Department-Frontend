import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/citizen/services/vehicle_renewal/payment_method_step.dart';
import '../../../../theme/app_theme.dart';
import 'vehicle_deregistration_form_step.dart';
import 'vehicle_deregistration_upload_documents_step.dart';
import 'vehicle_deregistration_summary_step.dart';

class VehicleDeregistrationScreen extends StatefulWidget {
final Map<String, dynamic>? prefilledData;

const VehicleDeregistrationScreen({super.key, this.prefilledData});


  @override
  State<VehicleDeregistrationScreen> createState() =>
      _VehicleDeregistrationScreenState();
}

class _VehicleDeregistrationScreenState
    extends State<VehicleDeregistrationScreen> {
  int _currentStep = 0;
  List<bool> stepCompleted = [false, false, false, false];

  final GlobalKey<VehicleDeregistrationFormStepState> _formStepKey =
      GlobalKey();
  final GlobalKey<VehicleDeregistrationUploadDocumentsStepState>
  _uploadDocsKey = GlobalKey();
  final GlobalKey<PaymentMethodStepState> _paymentStepKey = GlobalKey();

  Map<String, dynamic> formData = {};
  Map<String, File> uploadedDocs = {};
  double totalAmount = 0.0;
  bool isShekel = true;

  void _onStepContinue() async {
    if (_currentStep == 0) {
      if (_formStepKey.currentState?.validateAndSave() ?? false) {
        setState(() {
          stepCompleted[_currentStep] = true;
          _currentStep++;
        });
      }
    } else if (_currentStep == 1) {
      if (_uploadDocsKey.currentState?.validateDocuments() ?? false) {
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
      await _paymentStepKey.currentState?.continueToSelectedPayment();
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

  StepState _getStepState(int step) =>
      stepCompleted[step] ? StepState.complete : StepState.indexed;
  Color _getStepColor(int step) =>
      stepCompleted[step] ? Colors.green : Colors.black87;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('vehicle_deregistration'.tr()),
        backgroundColor: AppTheme.navy,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(primary: Colors.green),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'next'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.navy),
                      ),
                      child: Text(
                        'back'.tr(),
                        style: TextStyle(color: AppTheme.navy),
                      ),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text(
                'fill_deregistration_form'.tr(),
                style: TextStyle(color: _getStepColor(0)),
              ),
              content: VehicleDeregistrationFormStep(
                key: _formStepKey,
                prefilledData:
                    widget.prefilledData, 
                onStepCompleted: (data) => formData = data,
              ),
              isActive: _currentStep >= 0,
              state: _getStepState(0),
            ),

            Step(
              title: Text(
                'upload_required_documents'.tr(),
                style: TextStyle(color: _getStepColor(1)),
              ),
              content: VehicleDeregistrationUploadDocumentsStep(
                key: _uploadDocsKey,
                onStepCompleted: (docs) => uploadedDocs = docs,
              ),
              isActive: _currentStep >= 1,
              state: _getStepState(1),
            ),
            Step(
              title: Text(
                'deregistration_summary'.tr(),
                style: TextStyle(color: _getStepColor(2)),
              ),
              content: VehicleDeregistrationSummaryStep(
                formData: formData,
                onFeesCalculated: (total, shekel) {
                  totalAmount = total;
                  isShekel = shekel;
                },
              ),
              isActive: _currentStep >= 2,
              state: _getStepState(2),
            ),
            Step(
              title: Text(
                'payment_method'.tr(),
                style: TextStyle(color: _getStepColor(3)),
              ),
              content: PaymentMethodStep(
                key: _paymentStepKey,
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
