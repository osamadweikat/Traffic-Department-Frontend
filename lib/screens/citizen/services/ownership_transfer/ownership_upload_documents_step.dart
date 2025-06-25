import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/citizen/services/ownership_transfer/ownership_required_documents_helper.dart';

class OwnershipUploadDocumentsStep extends StatefulWidget {
  final String vehicleType;
  final Function(Map<String, File>) onStepCompleted;

  const OwnershipUploadDocumentsStep({
    super.key,
    required this.vehicleType,
    required this.onStepCompleted,
  });

  @override
  State<OwnershipUploadDocumentsStep> createState() => OwnershipUploadDocumentsStepState();
}

class OwnershipUploadDocumentsStepState extends State<OwnershipUploadDocumentsStep> {
  Map<String, File> uploadedDocs = {};
  Set<String> missingDocs = {};

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

  void markMissingDocuments(List<String> docs) {
    setState(() {
      missingDocs = docs.toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final requiredDocs = OwnershipRequiredDocumentsHelper.getRequiredDocuments(widget.vehicleType);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requiredDocs.length,
          itemBuilder: (context, index) {
            final docKey = requiredDocs[index];
            final file = uploadedDocs[docKey];
            final isMissing = missingDocs.contains(docKey);

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
                subtitle: file != null
                    ? Text('file_uploaded'.tr())
                    : isMissing
                        ? Text('required_field'.tr(), style: const TextStyle(color: Colors.red))
                        : Text('click_to_upload'.tr()),
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
