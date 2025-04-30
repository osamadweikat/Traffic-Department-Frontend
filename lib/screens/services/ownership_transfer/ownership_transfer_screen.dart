import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/services/ownership_transfer/ownership_required_documents_helper.dart';
import 'package:traffic_department/screens/services/ownership_transfer/ownership_summary_step.dart';
import 'package:traffic_department/screens/services/ownership_transfer/ownership_upload_documents_step.dart';
import 'package:traffic_department/screens/services/vehicle_renewal/payment_method_step.dart';
import '../../../theme/app_theme.dart';
import 'ownership_transfer_form_step.dart';

class OwnershipTransferScreen extends StatefulWidget {
  const OwnershipTransferScreen({super.key});

  @override
  State<OwnershipTransferScreen> createState() => _OwnershipTransferScreenState();
}

class _OwnershipTransferScreenState extends State<OwnershipTransferScreen> {
  int _currentStep = 0;
  List<bool> stepCompleted = [false, false, false, false];

  final GlobalKey<OwnershipTransferFormStepState> _formStepKey = GlobalKey();
  final GlobalKey<OwnershipUploadDocumentsStepState> _uploadDocsKey = GlobalKey();
  final GlobalKey<PaymentMethodStepState> _paymentMethodStepKey = GlobalKey(); 

  Map<String, dynamic> ownershipData = {};
  Map<String, dynamic> uploadedDocs = {};
  double totalAmount = 0.0;
  bool isShekel = true;

  Future<void> _onStepContinue() async {
    if (_currentStep == 0) {
      final isValid = _formStepKey.currentState?.validateAndSave() ?? false;
      if (!isValid) return;
      ownershipData = _formStepKey.currentState!.vehicleData;
    }

    if (_currentStep == 1) {
      String vehicleType = ownershipData['vehicleType'] ?? '';
      final requiredDocs =
          OwnershipRequiredDocumentsHelper.getRequiredDocuments(vehicleType);

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
      await _paymentMethodStepKey.currentState?.continueToSelectedPayment(); 
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

  StepState _getStepState(int step) =>
      stepCompleted[step] ? StepState.complete : StepState.indexed;

  Color _getStepColor(int step) =>
      stepCompleted[step] ? Colors.green : Colors.black87;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ownership_transfer'.tr()),
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
              title: Text('fill_transfer_form'.tr(), style: TextStyle(color: _getStepColor(0))),
              content: OwnershipTransferFormStep(
                key: _formStepKey,
                onStepCompleted: (data) => ownershipData = data,
              ),
              isActive: _currentStep >= 0,
              state: _getStepState(0),
            ),
            Step(
              title: Text('upload_documents'.tr(), style: TextStyle(color: _getStepColor(1))),
              content: OwnershipUploadDocumentsStep(
                key: _uploadDocsKey,
                vehicleType: ownershipData['vehicleType'] ?? '',
                onStepCompleted: (docs) => uploadedDocs = docs,
              ),
              isActive: _currentStep >= 1,
              state: _getStepState(1),
            ),
            Step(
              title: Text('request_summary'.tr(), style: TextStyle(color: _getStepColor(2))),
              content: OwnershipSummaryStep(
                ownershipData: ownershipData,
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
