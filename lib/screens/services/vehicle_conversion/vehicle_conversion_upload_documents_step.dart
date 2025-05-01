import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/services/vehicle_conversion/vehicle_conversion_required_documents_helper.dart';

class VehicleConversionUploadDocumentsStep extends StatefulWidget {
  final String conversionType;
  final Function(Map<String, File>) onStepCompleted;

  const VehicleConversionUploadDocumentsStep({
    super.key,
    required this.conversionType,
    required this.onStepCompleted,
  });

  @override
  State<VehicleConversionUploadDocumentsStep> createState() =>
      VehicleConversionUploadDocumentsStepState();
}

class VehicleConversionUploadDocumentsStepState
    extends State<VehicleConversionUploadDocumentsStep> {
  Map<String, File> uploadedDocs = {};
  List<String> missingDocs = [];
  bool showErrors = false;

  Future<void> _pickImage(String docKey) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        uploadedDocs[docKey] = File(picked.path);
        missingDocs.remove(docKey);
      });
      widget.onStepCompleted(uploadedDocs);
    }
  }

  void _removeImage(String docKey) {
    setState(() {
      uploadedDocs.remove(docKey);
    });
    widget.onStepCompleted(uploadedDocs);
  }

  bool validateDocuments() {
    final requiredDocs = VehicleConversionRequiredHelper.getRequiredDocuments(widget.conversionType);
    final incomplete = requiredDocs.where((doc) => uploadedDocs[doc] == null).toList();
    setState(() {
      showErrors = incomplete.isNotEmpty;
      missingDocs = incomplete;
    });
    return incomplete.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final requiredDocs = VehicleConversionRequiredHelper.getRequiredDocuments(widget.conversionType);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requiredDocs.length,
          itemBuilder: (context, index) {
            final docKey = requiredDocs[index];
            final file = uploadedDocs[docKey];
            final isMissing = showErrors && missingDocs.contains(docKey);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: isMissing ? Colors.red.shade50 : Colors.white,
              child: ListTile(
                leading: Icon(
                  file != null ? Icons.check_circle : Icons.upload_file,
                  color: file != null ? Colors.green : Colors.grey,
                ),
                title: Text(
                  docKey.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: file == null ? Text('click_to_upload'.tr()) : Text('file_uploaded'.tr()),
                trailing: file != null
                    ? IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeImage(docKey),
                      )
                    : IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () => _pickImage(docKey),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
