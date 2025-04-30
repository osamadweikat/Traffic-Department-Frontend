class ModificationRequiredDocumentsHelper {
  static List<String> getRequiredDocuments(String modificationType) {
    switch (modificationType) {
      case "تغيير إطارات المركبة":
        return [
          "proof_of_ownership",
          "insurance_certificate",
          "identity_document",
          "modification_request_form",
          "diagnosis_report_for_tires",
        ];

      case "تغيير محرك المركبة":
        return [
          "proof_of_ownership",
          "insurance_certificate",
          "identity_document",
          "modification_request_form",
          "engine_specification_diagnosis",
          "engine_sale_invoice",
          "customs_approval_letter",
          "legal_affidavit_engine",
          "garage_installation_certificate",
          "engine_sale_certificate_from_license",
        ];

      case "تغيير مبنى المركبة":
        return [
          "proof_of_ownership",
          "insurance_certificate",
          "identity_document",
          "modification_request_form",
          "equipment_sale_invoice",
          "customs_equipment_approval",
          "legal_affidavit_equipment",
          "engineering_plan2",
          "fitness_certificate_from_center",
          "garage_installation_certificate",
        ];

      case "تغيير لون المركبة":
        return [
          "proof_of_ownership",
          "insurance_certificate",
          "identity_document",
          "modification_request_form",
          "preapproval_color_change",
          "vehicle_identification_diagnosis",
        ];

      default:
        return [
          "proof_of_ownership",
          "insurance_certificate",
          "identity_document",
          "modification_request_form",
        ];
    }
  }
}
