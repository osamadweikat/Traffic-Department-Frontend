class RequiredDocumentsNewVehicleHelper {
  static List<String> getRequiredDocuments(Map<String, dynamic> vehicleData) {
    List<String> documents = [
      "personal_id",
      "customs_clearance_certificate",
      "purchase_agreement",
      "valid_insurance_certificate"
    ];

    String vehicleType = vehicleData['vehicleType'] ?? "";

    switch (vehicleType) {
      case "شاحنة":
        documents.addAll([
          "equipment_sale_contract",
          "customs_clearance_for_equipment",
          "installation_certificate",
          "technical_inspection_certificate",
          "engineering_diagram"
        ]);
        break;

      case "خلاطة/مضخة باطون":
        documents.addAll([
          "mixer_or_pump_sale_contract",
          "customs_clearance_for_equipment",
          "installation_certificate",
          "technical_inspection_certificate",
          "engineering_diagram"
        ]);
        break;

      case "صهريج حليب":
        documents.addAll([
          "engineering_diagram",
          "technical_inspection_certificate",
          "health_ministry_approval"
        ]);
        break;

      case "ناقلة وقود/مواد خطرة":
        documents.addAll([
          "petroleum_authority_approval",
          "civil_defense_approval",
          "engineering_diagram",
          "technical_inspection_certificate"
        ]);
        break;

      case "مركبة إطفاء":
        documents.addAll([
          "civil_defense_approval",
          "engineering_diagram",
          "technical_inspection_certificate"
        ]);
        break;

      case "حافلة سياحية/خاصة":
        documents.addAll([
          "traffic_monitoring_department_approval",
          "operation_permit",
          "seating_arrangement_diagram",
          "technical_inspection_certificate"
        ]);
        break;

      case "هياكل عمومية - تاكسي/حافلة برخصة جديدة":
        documents.addAll([
          "traffic_monitoring_department_escort",
          "valid_operation_license",
          "technical_inspection_certificate",
          "engineering_diagram_or_producer_diagram"
        ]);
        break;

      case "هياكل عمومية - هيكل بدل هيكل":
        documents.addAll([
          "traffic_monitoring_department_approval",
          "valid_operation_license",
          "technical_inspection_certificate",
          "engineering_diagram_or_producer_diagram",
          "old_structure_disposition_document"
        ]);
        break;

      case "مركبة تدريب سياقة":
        documents.addAll([
          "driving_schools_monitoring_department_approval",
          "equipment_sale_contract",
          "customs_clearance_for_equipment",
          "engineering_diagram",
          "technical_inspection_certificate",
          "installation_certificate"
        ]);
        break;

      case "مركبة إسعاف/عيادة متنقلة":
        documents.addAll([
          "red_crescent_approval",
          "health_ministry_approval",
          "engineering_diagram_or_producer_diagram",
          "technical_inspection_certificate"
        ]);
        break;

      case "مركبة روضة/مدرسة":
        documents.addAll([
          "traffic_monitoring_department_approval",
          "school_or_kindergarten_license",
          "valid_operation_license",
          "seating_arrangement_diagram",
          "technical_inspection_certificate"
        ]);
        break;

      case "مركبة حكومية":
        documents.add("government_transportation_approval");
        break;

      case "مركبة جمعيات أهلية أو أجنبية":
        documents.add("ministry_of_interior_approval");
        break;

      case "تراكتور زراعي":
        documents.add("agriculture_ministry_approval");
        break;

      case "مركبة جر وتخليص/ناقلة سيارات":
        documents.addAll([
          "vehicle_professions_approval",
          "engineering_diagram",
          "technical_inspection_certificate"
        ]);
        break;

      case "مركبة تأجير":
        documents.add("road_transport_approval_with_signs");
        break;

      case "مركبة نقل أموال":
        documents.addAll([
          "palestinian_monetary_authority_approval",
          "technical_inspection_certificate"
        ]);
        break;

      case "صهريج نضح":
        documents.addAll([
          "environmental_authority_approval",
          "health_ministry_approval",
          "engineering_diagram",
          "technical_inspection_certificate"
        ]);
        break;

      case "مركبة نفايات":
        documents.addAll([
          "environmental_authority_approval",
          "health_ministry_approval",
          "engineering_diagram",
          "technical_inspection_certificate"
        ]);
        break;

      case "صهريج مياه":
        documents.addAll([
          "health_ministry_approval",
          "engineering_diagram",
          "technical_inspection_certificate"
        ]);
        break;
    }

    return documents;
  }
}
