class VehicleDeregistrationFeesHelper {
  static Map<String, dynamic> calculateFees() {
    double bankFee = 2;
    double total = bankFee;

    return {
      'bankFee': bankFee,
      'total': total,
    };
  }
}
