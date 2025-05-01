class VehicleMortgageReleaseFeesHelper {
  static Map<String, dynamic> calculateFees() {
    double serviceFee = 30;
    double bankFee = 2;
    double total = serviceFee + bankFee;

    return {
      'serviceFee': serviceFee,
      'bankFee': bankFee,
      'total': total,
    };
  }
}
