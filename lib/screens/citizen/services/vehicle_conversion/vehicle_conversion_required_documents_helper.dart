class VehicleConversionRequiredHelper {
  static List<String> getRequiredDocuments(String conversionType) {
    List<String> baseDocuments = [
      "document_request_letter",
      "vehicle_license_or_replacement_form",
      "traffic_monitor_approval",
      "customs_clearance",
      "valid_insurance",
      "tax_clearance_certificate",
      "identity_or_power_of_attorney",
    ];

    if (conversionType == "تجاري") {
      baseDocuments.addAll([
        "vehicle_suitability_certificate",
        "engineering_diagram_if_needed",
      ]);
    }

    return baseDocuments;
  }
}
