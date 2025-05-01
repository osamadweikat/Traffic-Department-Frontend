class LostDocumentsRequiredHelper {
  static List<String> getRequiredDocuments({
    required String documentType,
    required String replacementType,
  }) {
    List<String> documents = [];

    if (documentType == "رخصة مركبة") {
      documents = [
        "document_request_letter",
        "replacement_form",
        "valid_insurance",
        "identity_or_power_of_attorney",
      ];
      if (replacementType == "فاقد") {
        documents.add("police_report");
      } else if (replacementType == "تالف") {
        documents.add("damaged_license_copy");
      }
    }

    else if (documentType == "رخصة قيادة") {
      documents = [
        "identity_or_passport",
        "replacement_form",
      ];
      if (replacementType == "فاقد") {
        documents.add("lost_license_affidavit");
      } else if (replacementType == "تالف") {
        documents.add("damaged_license_copy");
      }
    }

    return documents;
  }
}
