import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'modification_form_step.dart';
import 'modification_upload_documents_step.dart';
import 'modification_summary_step.dart';
import 'modification_required_documents_helper.dart';
import 'package:traffic_department/screens/services/vehicle_renewal/payment_method_step.dart';
import '../../../theme/app_theme.dart';

class VehicleModificationScreen extends StatefulWidget {
  const VehicleModificationScreen({super.key});

  @override
  State<VehicleModificationScreen> createState() => _VehicleModificationScreenState();
}

class _VehicleModificationScreenState extends State<VehicleModificationScreen> {
  int _currentStep = 0;
  List<bool> stepCompleted = [false, false, false, false];

  Map<String, dynamic> modificationData = {};
  Map<String, dynamic> uploadedDocs = {};
  double totalAmount = 0.0;
  bool isShekel = true;

  final GlobalKey<ModificationFormStepState> _formStepKey = GlobalKey();
  final GlobalKey<ModificationUploadDocumentsStepState> _uploadDocsKey = GlobalKey();
  final GlobalKey<PaymentMethodStepState> _paymentKey = GlobalKey();

  Future<void> _onStepContinue() async {
    if (_currentStep == 0) {
      final isValid = _formStepKey.currentState?.validateAndSave() ?? false;
      if (!isValid) return;
      modificationData = _formStepKey.currentState!.modificationData;
    }

    if (_currentStep == 1) {
      final requiredDocs = ModificationRequiredDocumentsHelper.getRequiredDocuments(
        modificationData['modificationType'] ?? '',
      );
      final missingDocs = requiredDocs.where((doc) => uploadedDocs[doc] == null).toList();
      if (missingDocs.isNotEmpty) {
        _uploadDocsKey.currentState?.markMissingDocuments(missingDocs);
        return;
      }
    }

    if (_currentStep == 2) {
      setState(() {
        stepCompleted[_currentStep] = true;
        _currentStep++;
      });
      return;
    }

    if (_currentStep == 3) {
      await _paymentKey.currentState?.continueToSelectedPayment();
      return;
    }

    if (_currentStep < 3) {
      setState(() {
        stepCompleted[_currentStep] = true;
        _currentStep++;
      });
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
        title: Text('vehicle_modification'.tr()),
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
              title: Text('modification_form'.tr(), style: TextStyle(color: _getStepColor(0))),
              content: ModificationFormStep(
                key: _formStepKey,
                onStepCompleted: (data) => modificationData = data,
              ),
              isActive: _currentStep >= 0,
              state: _getStepState(0),
            ),
            Step(
              title: Text('upload_documents'.tr(), style: TextStyle(color: _getStepColor(1))),
              content: ModificationUploadDocumentsStep(
                key: _uploadDocsKey,
                modificationType: modificationData['modificationType'] ?? '',
                onStepCompleted: (docs) => uploadedDocs = docs,
              ),
              isActive: _currentStep >= 1,
              state: _getStepState(1),
            ),
            Step(
              title: Text('request_summary'.tr(), style: TextStyle(color: _getStepColor(2))),
              content: ModificationSummaryStep(
                modificationData: modificationData,
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
                key: _paymentKey,
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
