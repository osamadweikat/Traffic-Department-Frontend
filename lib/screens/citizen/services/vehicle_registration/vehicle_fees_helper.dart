class VehicleFeesHelper {
  static Map<String, dynamic> calculateVehicleFees(Map<String, dynamic> vehicleInfo) {
    final String? vehicleType = vehicleInfo['vehicleType'];
    final String? fuelType = vehicleInfo['fuelType'];
    final int? engineCapacity = int.tryParse(vehicleInfo['engineCapacity']?.toString() ?? '');
    final int? productionYear = int.tryParse(vehicleInfo['manufactureYear']?.toString() ?? '');
    final int? weight = int.tryParse(vehicleInfo['weight']?.toString() ?? '');
    final int? passengerCapacity = int.tryParse(vehicleInfo['passengerCapacity']?.toString() ?? '');

    final int currentYear = DateTime.now().year;

    double baseFee = 0;
    List<Map<String, dynamic>> feeDetails = [];

    if (vehicleType == null || vehicleType.isEmpty) {
      baseFee = 200;
      feeDetails.add({"title": "default_fee", "amount": baseFee});
    }
    else if (vehicleType == "دراجة آلية") {
      if (engineCapacity != null) {
        if (engineCapacity <= 50) {
          baseFee = 5;
        } else if (engineCapacity <= 150) {
          baseFee = 15;
        } else {
          baseFee = 30;
        }
        feeDetails.add({"title": "motorcycle_fee", "amount": baseFee});
      } else {
        baseFee = 200;
        feeDetails.add({"title": "default_fee", "amount": baseFee});
      }
    }
    else if (vehicleType == "خصوصي") {
      if (fuelType == "ديزل") {
        baseFee = 500;
        feeDetails.add({"title": "private_vehicle_diesel_fee", "amount": baseFee});
      } else {
        if (engineCapacity != null && productionYear != null) {
          int age = currentYear - productionYear;
          if (engineCapacity <= 1000) {
            baseFee = (age <= 3) ? 80 : (age <= 8) ? 75 : 60;
          } else if (engineCapacity <= 2000) {
            baseFee = (age <= 3) ? 120 : (age <= 8) ? 115 : 110;
          } else if (engineCapacity <= 3000) {
            baseFee = (age <= 3) ? 240 : (age <= 8) ? 220 : 200;
          } else {
            baseFee = (age <= 3) ? 300 : (age <= 8) ? 270 : 220;
          }
          feeDetails.add({"title": "private_vehicle_fee", "amount": baseFee});
        } else {
          baseFee = 200;
          feeDetails.add({"title": "default_fee", "amount": baseFee});
        }
      }
    }
    else if (vehicleType == "شاحنة" || vehicleType == "خلاطة/مضخة باطون" || vehicleType == "صهريج حليب" ||
             vehicleType == "ناقلة وقود/مواد خطرة" || vehicleType == "مركبة نفايات" || vehicleType == "صهريج نضح" ||
             vehicleType == "صهريج مياه" || vehicleType == "مركبة جر وتخليص/ناقلة سيارات") {
      if (weight != null) {
        if (weight <= 16000) {
          baseFee = 180;
        } else if (weight <= 20000) {
          baseFee = 230;
        } else {
          baseFee = 330;
        }
        feeDetails.add({"title": "heavy_commercial_vehicle_fee", "amount": baseFee});
      } else {
        baseFee = 200;
        feeDetails.add({"title": "default_fee", "amount": baseFee});
      }
    }
    else if (vehicleType == "مركبة تأجير" || vehicleType == "هياكل عمومية - تاكسي/حافلة برخصة جديدة" || vehicleType == "هياكل عمومية - هيكل بدل هيكل") {
      if (passengerCapacity != null) {
        if (passengerCapacity <= 4) {
          baseFee = (fuelType == "ديزل") ? 60 : 15;
        } else {
          baseFee = (fuelType == "ديزل") ? 100 : 20;
        }
        feeDetails.add({"title": "rental_or_taxi_fee", "amount": baseFee});
      } else {
        baseFee = 200;
        feeDetails.add({"title": "default_fee", "amount": baseFee});
      }
    }
    else if (vehicleType == "حافلة سياحية/خاصة" || vehicleType == "مركبة روضة/مدرسة") {
      if (fuelType == "ديزل") {
        baseFee = 100;
      } else {
        baseFee = 50;
      }
      feeDetails.add({"title": "bus_fee", "amount": baseFee});
    }
    else if (vehicleType == "مركبة حكومية" || vehicleType == "مركبة جمعيات أهلية أو أجنبية") {
      baseFee = 30;
      feeDetails.add({"title": "government_vehicle_fee", "amount": baseFee});
    }
    else if (vehicleType == "مركبة تدريب سياقة" || vehicleType == "مركبة إسعاف/عيادة متنقلة") {
      baseFee = 100;
      feeDetails.add({"title": "training_or_ambulance_vehicle_fee", "amount": baseFee});
    }
    else if (vehicleType == "تراكتور زراعي") {
      baseFee = (fuelType == "ديزل") ? 50 : 20;
      feeDetails.add({"title": "tractor_fee", "amount": baseFee});
    }
    else {
      baseFee = 200;
      feeDetails.add({"title": "default_fee", "amount": baseFee});
    }

    return {
      "baseFee": baseFee,
      "details": feeDetails,
      "total": baseFee,
    };
  }
}
