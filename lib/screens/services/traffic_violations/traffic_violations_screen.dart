import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:traffic_department/screens/payment/payment_methods/jawwal_pay_payment_screen.dart';
import 'package:traffic_department/screens/payment/payment_methods/paypal_payment_screen.dart';
import 'package:traffic_department/screens/payment/payment_methods/visa_payment_bottom_sheet.dart';
import 'package:traffic_department/screens/services/traffic_violations/no_violations_dialog.dart';
import 'package:traffic_department/screens/services/traffic_violations/traffic_violations_data.dart';
import '../../../theme/app_theme.dart';

class TrafficViolationsScreen extends StatefulWidget {
  const TrafficViolationsScreen({super.key});

  @override
  State<TrafficViolationsScreen> createState() => _TrafficViolationsScreenState();
}

class _TrafficViolationsScreenState extends State<TrafficViolationsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> licenseViolations = [];
  List<Map<String, dynamic>> vehicleViolations = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _searchController.clear();
          licenseViolations = [];
          vehicleViolations = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void searchViolations(String value) {
  final licenseMatches = trafficViolations
      .where((v) => v['type'] == 'license' && v['id'] == value)
      .toList();

  final vehicleMatches = trafficViolations
      .where((v) => v['type'] == 'vehicle' && v['plateNumber'] == value)
      .toList();

  if (licenseMatches.isEmpty && vehicleMatches.isEmpty) {
    showDialog(
      context: context,
      builder: (_) => const NoViolationsDialog(),
    );
  }

  setState(() {
    licenseViolations = licenseMatches;
    vehicleViolations = vehicleMatches;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("traffic_violations").tr(),
        centerTitle: true,
        backgroundColor: AppTheme.navy,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.yellow,
          tabs: [
            Tab(text: "license_search".tr(), icon: const Icon(Icons.badge)),
            Tab(text: "vehicle_search".tr(), icon: const Icon(Icons.directions_car)),
          ],
        ),
      ),
      backgroundColor: AppTheme.lightGrey,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: _tabController.index == 0 ? 'enter_license_id'.tr() : 'enter_plate_number'.tr(),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => searchViolations(_searchController.text.trim()),
                  child: Text('search'.tr()),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ViolationsListView(violations: licenseViolations),
                ViolationsListView(violations: vehicleViolations),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ViolationsListView extends StatefulWidget {
  final List<Map<String, dynamic>> violations;
  const ViolationsListView({super.key, required this.violations});

  @override
  State<ViolationsListView> createState() => _ViolationsListViewState();
}

class _ViolationsListViewState extends State<ViolationsListView> with SingleTickerProviderStateMixin {
  Set<int> expandedIndexes = {};
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color getSeverityColor(int amount) {
    if (amount >= 600) return Colors.redAccent;
    if (amount >= 300) return Colors.orangeAccent;
    return Colors.greenAccent.shade400;
  }

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> allViolations = widget.violations.expand<Map<String, dynamic>>((entry) {
      final List<dynamic> innerViolations = entry['violations'] ?? [];
      return innerViolations.map<Map<String, dynamic>>((v) {
        return {
          ...v,
          "type": entry['type'],
          "reference": entry['id'] ?? entry['plateNumber'],
        };
      });
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: allViolations.length,
      itemBuilder: (context, index) {
        final violation = allViolations[index];
        final isExpanded = expandedIndexes.contains(index);
        final color = getSeverityColor(violation['amount']);

        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final double pulseValue = 0.3 + (_pulseController.value * 0.7);
            final double blur = isExpanded ? 30 : pulseValue * 30;
            final double spread = isExpanded ? 1 : pulseValue * 3;
            final double opacity = isExpanded ? 0.7 : pulseValue * 0.5;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(opacity),
                    blurRadius: blur,
                    spreadRadius: spread,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      expandedIndexes.remove(index);
                    } else {
                      expandedIndexes.add(index);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow("violation".tr(), violation['violation'] ?? ''),
                      buildRow("date".tr(), violation['date'] ?? ''),
                      buildRow("amount".tr(), "${violation['amount']} ₪"),
                      if (isExpanded) ...[
                        const SizedBox(height: 10),
                        buildRow("officer_name".tr(), violation['officer'] ?? '---'),
                        buildRow("location".tr(), violation['location'] ?? '---'),
                        buildRow("notes".tr(), violation['notes'] ?? '---'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildPaymentOption(Icons.credit_card, 'Visa/MasterCard', violation['amount'].toDouble()),
                            _buildPaymentOption(Icons.account_balance_wallet, 'PayPal', violation['amount'].toDouble()),
                            _buildPaymentOption(Icons.phone_android, 'Jawwal Pay', violation['amount'].toDouble()),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String label, double amount) {
    return InkWell(
      onTap: () {
        if (label == 'Visa/MasterCard') {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled: true,
            builder: (_) => VisaPaymentBottomSheet(
              onSubmit: (selectedCard) {},
            ),
          );
        } else if (label == 'PayPal') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaypalPaymentScreen(
                totalAmount: amount.toInt(),
                currencySymbol: "₪",
              ),
            ),
          );
        } else if (label == 'Jawwal Pay') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JawwalPayPaymentScreen(
                totalAmount: amount.toInt(),
                currencySymbol: "₪",
              ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppTheme.navy),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
