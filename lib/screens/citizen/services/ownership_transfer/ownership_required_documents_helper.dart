class OwnershipRequiredDocumentsHelper {
  static List<String> getRequiredDocuments(String vehicleType) {
    List<String> documents = [
      "identity_proof",
      "original_vehicle_license_or_loss_report",
      "valid_insurance_certificate",
      "ownership_transfer_form",
      "chassis_and_engine_verification"
    ];

    switch (vehicleType) {
      case "شاحنة":
      case "مركبة تجارية":
        documents.add("tax_clearance_certificate");
        break;

      case "تاكسي":
      case "حافلة عمومية":
        documents.addAll([
          "traffic_department_approval",
          "operation_license_valid",
          "structure_ownership_proof_if_needed",
          "tax_clearance_certificate"
        ]);
        break;

      case "حافلة خاصة":
      case "مركبة إيجار":
        documents.addAll([
          "traffic_department_approval",
          "tax_clearance_certificate"
        ]);
        break;

      case "مركبة تدريب سياقة":
        documents.addAll([
          "school_traffic_department_approval",
          "tax_clearance_certificate"
        ]);
        break;

      case "مركبة حكومية":
        documents.addAll([
          "customs_non_objection",
          "government_transport_approval"
        ]);
        break;

      case "مركبة معفاة من الجمارك":
        documents.add("customs_duty_payment");
        break;

      case "ناقلة وقود":
        documents.addAll([
          "petroleum_authority_approval",
          "tax_clearance_certificate"
        ]);
        break;

      case "صهريج حليب":
        documents.add("health_ministry_approval");
        break;

      case "مركبة إسعاف":
      case "عيادة متنقلة":
      case "مركبة نقل موتى":
        documents.addAll([
          "red_crescent_approval",
          "health_ministry_approval"
        ]);
        break;

      case "مركبة روضة":
      case "مركبة مدرسة":
        documents.addAll([
          "traffic_department_approval",
          "school_license_valid",
          "operation_license_valid"
        ]);
        break;

      case "مركبة جمعيات أهلية":
      case "مركبة جمعيات أجنبية":
        documents.add("ministry_of_interior_approval");
        break;

      case "تراكتور زراعي":
        documents.add("ministry_of_agriculture_approval");
        break;

      case "مركبة جر وتخليص":
      case "ناقلة سيارات":
        documents.addAll([
          "vehicle_profession_approval",
          "road_transport_approval"
        ]);
        break;

      case "مركبة تأجير":
        documents.addAll([
          "road_transport_approval",
          "tax_clearance_certificate"
        ]);
        break;

      case "مركبة نقل أموال":
        documents.add("monetary_authority_approval");
        break;

      case "مركبة نضح":
      case "صهريج مياه":
      case "مركبة نفايات":
        documents.addAll([
          "environmental_authority_approval",
          "health_ministry_approval"
        ]);
        break;
    }

    return documents;
  }
}
