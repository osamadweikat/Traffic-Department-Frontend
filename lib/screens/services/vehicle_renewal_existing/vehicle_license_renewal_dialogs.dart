import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:traffic_department/screens/services/vehicle_renewal_existing/vehicle_license_renewal_existing_screen.dart'; // ✅ إضافة الاستيراد الصحيح

class VehicleRenewalDialogs {
  
  static Future<void> showValidLicenseDialog(BuildContext context, {required bool hasViolations}) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                hasViolations
                    ? 'assets/animations/warning_animation1.json'
                    : 'assets/animations/success_animation.json',
                width: 120,
                height: 120,
                repeat: true, 
              ),
              const SizedBox(height: 20),
              Text(
                hasViolations ? "warning".tr() : "all_good".tr(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: hasViolations ? Colors.orange : Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hasViolations
                    ? "you_have_pending_violations".tr()
                    : "license_is_valid_no_action_needed".tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasViolations ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('ok'.tr(), style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showExpiredLicenseDialog(BuildContext context, Map<String, dynamic> vehicle) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/expired_animation.json',
                width: 120,
                height: 120,
                repeat: true,
              ),
              const SizedBox(height: 20),
              Text(
                "license_expired".tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "license_expired_please_renew".tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VehicleLicenseRenewalExistingScreen(vehicleData: vehicle),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('renew_now'.tr(), style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> checkAndRenewLicense(BuildContext context, Map<String, dynamic> vehicle) async {
    final expiryDateStr = vehicle["expiry"];
    final violations = vehicle["violations"] as List<dynamic>;

    final expiryDate = DateTime.tryParse(expiryDateStr);

    if (expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("invalid_license_expiry".tr())),
      );
      return;
    }

    final now = DateTime.now();

    if (expiryDate.isAfter(now)) {
      if (violations.isNotEmpty) {
        await showValidLicenseDialog(context, hasViolations: true);
      } else {
        await showValidLicenseDialog(context, hasViolations: false);
      }
    } else {
      await showExpiredLicenseDialog(context, vehicle);
    }
  }
}
