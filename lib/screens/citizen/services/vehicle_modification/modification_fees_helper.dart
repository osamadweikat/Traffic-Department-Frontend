class ModificationFeesHelper {
  static Map<String, dynamic> calculateFees(String modificationType) {
    double baseFee = 0;

    switch (modificationType) {
      case "تغيير إطارات المركبة":
        baseFee = 50;
        break;
      case "تغيير محرك المركبة":
        baseFee = 150;
        break;
      case "تغيير مبنى المركبة":
        baseFee = 130;
        break;
      case "تغيير لون المركبة":
        baseFee = 80;
        break;
      default:
        baseFee = 60;
    }

    double bankFee = 2;
    double total = baseFee + bankFee;

    return {
      "baseFee": baseFee,
      "bankFee": bankFee,
      "total": total,
    };
  }
}
