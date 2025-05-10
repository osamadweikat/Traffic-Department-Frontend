class VehicleConversionFeesHelper {
  static Map<String, dynamic> calculateFees({
    required String newType, 
    required bool colorChanged,
    required bool structureChanged,
  }) {
    double colorFee = colorChanged ? 30 : 0;
    double structureFee = structureChanged ? 40 : 0;

    double newTypeFee = 0;
    if (newType == "خصوصي") {
      newTypeFee = 50;
    } else if (newType == "تجاري") {
      newTypeFee = 70;
    }

    double bankFee = 2;
    double total = colorFee + structureFee + newTypeFee + bankFee;

    return {
      'colorFee': colorFee,
      'structureFee': structureFee,
      'newTypeFee': newTypeFee,
      'bankFee': bankFee,
      'total': total,
    };
  }
}
