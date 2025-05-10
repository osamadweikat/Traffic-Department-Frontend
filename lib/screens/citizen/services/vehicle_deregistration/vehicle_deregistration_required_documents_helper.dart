class VehicleDeregistrationRequiredHelper {
  static List<String> getRequiredDocuments() {
    return [
      "deregistration_request_letter",
      "valid_vehicle_license_or_replacement",
      "tax_clearance_certificate",
      "approval_from_relevant_authorities",
      "identity_document",
      "vehicle_plate_or_police_report",
      "vehicle_chassis_plate"
    ];
  }
}
