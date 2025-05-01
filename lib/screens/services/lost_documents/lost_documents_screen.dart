import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/services/lost_documents/lost_documents_form_step.dart';
import 'package:traffic_department/screens/services/lost_documents/lost_documents_upload_step.dart';
import 'package:traffic_department/screens/services/lost_documents/lost_documents_summary_step.dart';
import 'package:traffic_department/screens/services/vehicle_renewal/payment_method_step.dart';
import '../../../theme/app_theme.dart';

class LostDocumentsScreen extends StatefulWidget {
  const LostDocumentsScreen({super.key});

  @override
  State<LostDocumentsScreen> createState() => _LostDocumentsScreenState();
}

class _LostDocumentsScreenState extends State<LostDocumentsScreen> {
  int _currentStep = 0;
  List<bool> stepCompleted = [false, false, false, false];

  final GlobalKey<LostDocumentsFormStepState> _formStepKey = GlobalKey();
  final GlobalKey<LostDocumentsUploadStepState> _uploadStepKey = GlobalKey();
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
      if (_uploadStepKey.currentState?.validateDocuments() ?? false) {
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

  StepState _getStepState(int step) => stepCompleted[step] ? StepState.complete : StepState.indexed;
  Color _getStepColor(int step) => stepCompleted[step] ? Colors.green : Colors.black87;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lost_or_damaged_documents'.tr()),
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
                      style: OutlinedButton.styleFrom(side: BorderSide(color: AppTheme.navy)),
                      child: Text('back'.tr(), style: TextStyle(color: AppTheme.navy)),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text('fill_lost_form'.tr(), style: TextStyle(color: _getStepColor(0))),
              content: LostDocumentsFormStep(
                key: _formStepKey,
                onStepCompleted: (data) => formData = data,
              ),
              isActive: _currentStep >= 0,
              state: _getStepState(0),
            ),
            Step(
              title: Text('upload_documents'.tr(), style: TextStyle(color: _getStepColor(1))),
              content: LostDocumentsUploadStep(
                key: _uploadStepKey,
                documentType: formData['documentType'] ?? '',
                replacementType: formData['replacementType'] ?? '',
                onStepCompleted: (docs) => uploadedDocs = docs,
              ),
              isActive: _currentStep >= 1,
              state: _getStepState(1),
            ),
            Step(
              title: Text('request_summary'.tr(), style: TextStyle(color: _getStepColor(2))),
              content: LostDocumentsSummaryStep(
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
              title: Text('payment_method'.tr(), style: TextStyle(color: _getStepColor(3))),
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
