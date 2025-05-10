class OwnershipFeesHelper {
  static Map<String, dynamic> calculateOwnershipFees(String? fuelType) {
    double baseFee;

    final normalizedFuel = fuelType?.toLowerCase() ?? '';

    if (normalizedFuel == 'ديزل' || normalizedFuel == 'diesel') {
      baseFee = 200;
    } else {
      baseFee = 100;
    }

    const double bankFee = 2;
    final double total = baseFee + bankFee;

    return {
      "baseFee": baseFee,
      "bankFee": bankFee,
      "total": total,
    };
  }
}
