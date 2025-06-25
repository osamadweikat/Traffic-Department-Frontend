import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'required_documents_new_vehicle_helper.dart';

class RequiredDocumentsNewVehicleStep extends StatefulWidget {
  final Map<String, dynamic> vehicleInfo;
  final Function(Map<String, File>) onStepCompleted;

  const RequiredDocumentsNewVehicleStep({
    Key? key,
    required this.vehicleInfo,
    required this.onStepCompleted,
  }) : super(key: key);

  @override
  State<RequiredDocumentsNewVehicleStep> createState() => RequiredDocumentsNewVehicleStepState();
}

class RequiredDocumentsNewVehicleStepState extends State<RequiredDocumentsNewVehicleStep> {
  Map<String, File> uploadedDocuments = {};
  bool showValidationErrors = false;

  Future<void> _pickImage(String docKey) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        uploadedDocuments[docKey] = File(pickedFile.path);
      });
      widget.onStepCompleted(uploadedDocuments);
    }
  }

  void _removeImage(String docKey) {
    setState(() {
      uploadedDocuments.remove(docKey);
    });
    widget.onStepCompleted(uploadedDocuments);
  }

  bool validateDocuments() {
    final requiredDocs = RequiredDocumentsNewVehicleHelper.getRequiredDocuments(widget.vehicleInfo);

    final allUploaded = requiredDocs.every((docKey) => uploadedDocuments.containsKey(docKey));

    setState(() {
      showValidationErrors = !allUploaded;
    });

    return allUploaded;
  }

  @override
  Widget build(BuildContext context) {
    final requiredDocs = RequiredDocumentsNewVehicleHelper.getRequiredDocuments(widget.vehicleInfo);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requiredDocs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final docKey = requiredDocs[index];
            final file = uploadedDocuments[docKey];
            final isMissing = file == null && showValidationErrors;

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              color: file != null ? Colors.green.shade50 : (isMissing ? Colors.red.shade50 : Colors.white),
              child: ListTile(
                leading: Icon(
                  file == null ? Icons.upload_file : Icons.check_circle,
                  color: file == null ? Colors.blueGrey : Colors.green,
                ),
                title: Text(
                  docKey.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file == null ? 'click_to_upload'.tr() : 'file_uploaded'.tr(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (isMissing)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'required_field'.tr(),
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                trailing: file != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility, color: Colors.blue),
                            onPressed: () => _previewImage(file),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeImage(docKey),
                          ),
                        ],
                      )
                    : IconButton(
                        icon: const Icon(Icons.image_outlined),
                        onPressed: () => _pickImage(docKey),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _previewImage(File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.file(file),
        ),
      ),
    );
  }
}
