// 🚀 ثالث كود: RequiredDocumentsStep (رفع الوثائق مع تظليل أحمر ونص إذا ناقصة)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/services/vehicle_renewal/required_documents_helper.dart';

class RequiredDocumentsStep extends StatefulWidget {
  final Map<String, dynamic> vehicleInfoData;
  final Function(Map<String, File>) onStepCompleted;

  const RequiredDocumentsStep({
    Key? key,
    required this.vehicleInfoData,
    required this.onStepCompleted,
  }) : super(key: key);

  @override
  RequiredDocumentsStepState createState() => RequiredDocumentsStepState();
}

class RequiredDocumentsStepState extends State<RequiredDocumentsStep> {
  Map<String, File> uploadedDocuments = {};
  bool showValidationErrors = false;

  Future<void> _pickImage(String docTitle) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        uploadedDocuments[docTitle] = File(pickedFile.path);
      });
      widget.onStepCompleted(uploadedDocuments);
    }
  }

  void _removeImage(String docTitle) {
    setState(() {
      uploadedDocuments.remove(docTitle);
    });
    widget.onStepCompleted(uploadedDocuments);
  }

  bool validateDocuments() {
    final vehicleType = widget.vehicleInfoData['vehicleType'];
    final fuelType = widget.vehicleInfoData['fuelType'];
    final requiredDocs = RequiredDocumentsHelper.getRequiredDocuments(vehicleType, fuelType);

    bool allUploaded = requiredDocs.every((doc) => uploadedDocuments.containsKey(doc));

    setState(() {
      showValidationErrors = !allUploaded;
    });

    return allUploaded;
  }

  @override
  Widget build(BuildContext context) {
    final vehicleType = widget.vehicleInfoData['vehicleType'];
    final fuelType = widget.vehicleInfoData['fuelType'];

    final requiredDocs = RequiredDocumentsHelper.getRequiredDocuments(vehicleType, fuelType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requiredDocs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final docTitle = requiredDocs[index];
            final file = uploadedDocuments[docTitle];
            final isMissing = file == null && showValidationErrors;

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              color: file != null ? Colors.green.shade50 : (isMissing ? Colors.red.shade50 : Colors.white),
              child: ListTile(
                leading: file == null
                    ? const Icon(Icons.upload_file, color: Colors.blueGrey)
                    : const Icon(Icons.check_circle, color: Colors.green),
                title: Text(
                  docTitle,
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
                            onPressed: () {
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
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeImage(docTitle),
                          ),
                        ],
                      )
                    : IconButton(
                        icon: const Icon(Icons.image_outlined),
                        onPressed: () => _pickImage(docTitle),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
