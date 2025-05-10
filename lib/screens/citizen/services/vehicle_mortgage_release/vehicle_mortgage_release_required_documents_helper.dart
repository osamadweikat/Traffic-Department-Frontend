class VehicleMortgageReleaseRequiredHelper {
  static List<String> getRequiredDocuments({required bool isRelease}) {
    return isRelease
        ? [
            "release_request_letter",
            "valid_vehicle_license_or_replacement",
            "valid_insurance",
            "original_release_court_document",
            "release_letter_from_lien_holder",
            "identity_document",
          ]
        : [
            "mortgage_request_letter",
            "valid_vehicle_license_or_replacement",
            "valid_insurance",
            "original_mortgage_court_document",
            "mortgage_request_from_lien_holder",
            "identity_document",
          ];
  }
}
