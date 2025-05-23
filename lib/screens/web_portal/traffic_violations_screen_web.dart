import 'package:flutter/material.dart';
import 'package:traffic_department/screens/web_portal/no_violations_dialog_web.dart';
import 'package:traffic_department/screens/citizen/services/traffic_violations/traffic_violations_data.dart';

class TrafficViolationsScreenWeb extends StatefulWidget {
  const TrafficViolationsScreenWeb({super.key});

  @override
  State<TrafficViolationsScreenWeb> createState() =>
      _TrafficViolationsScreenWebState();
}

class _TrafficViolationsScreenWebState extends State<TrafficViolationsScreenWeb>
    with SingleTickerProviderStateMixin {
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

  void searchViolations(String value) {
    final licenseMatches =
        trafficViolations
            .where((v) => v['type'] == 'license' && v['id'] == value)
            .toList();

    final vehicleMatches =
        trafficViolations
            .where((v) => v['type'] == 'vehicle' && v['plateNumber'] == value)
            .toList();

    if (licenseMatches.isEmpty && vehicleMatches.isEmpty) {
      showNoViolationsDialogWeb(context);
    }

    setState(() {
      licenseViolations = licenseMatches;
      vehicleViolations = vehicleMatches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'المخالفات المرورية',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF002D5B),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.yellow,
            tabs: const [
              Tab(text: "حسب الرخصة", icon: Icon(Icons.badge)),
              Tab(text: "حسب رقم اللوحة", icon: Icon(Icons.directions_car)),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFF4F6FA),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText:
                            _tabController.index == 0
                                ? 'أدخل رقم الرخصة'
                                : 'أدخل رقم اللوحة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed:
                        () => searchViolations(_searchController.text.trim()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('بحث'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ViolationsListViewWeb(violations: licenseViolations),
                  ViolationsListViewWeb(violations: vehicleViolations),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViolationsListViewWeb extends StatefulWidget {
  final List<Map<String, dynamic>> violations;
  const ViolationsListViewWeb({super.key, required this.violations});

  @override
  State<ViolationsListViewWeb> createState() => _ViolationsListViewWebState();
}

class _ViolationsListViewWebState extends State<ViolationsListViewWeb>
    with SingleTickerProviderStateMixin {
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
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final allViolations =
        widget.violations.expand<Map<String, dynamic>>((entry) {
          final List<Map<String, dynamic>> innerViolations =
              (entry['violations'] as List).cast<Map<String, dynamic>>();
          return innerViolations.map<Map<String, dynamic>>((v) {
            return {
              ...v,
              "type": entry['type'],
              "reference": entry['id'] ?? entry['plateNumber'],
            };
          });
        }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allViolations.length,
      itemBuilder: (context, index) {
        final violation = allViolations[index];
        final isExpanded = expandedIndexes.contains(index);
        final color = getSeverityColor(violation['amount']);

        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final double pulse = 0.3 + (_pulseController.value * 0.7);
            return GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded
                      ? expandedIndexes.remove(index)
                      : expandedIndexes.add(index);
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(pulse * 0.5),
                      blurRadius: isExpanded ? 30 : pulse * 30,
                      spreadRadius: isExpanded ? 1 : pulse * 3,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow("المخالفة", violation['violation'] ?? ''),
                    _buildRow("التاريخ", violation['date'] ?? ''),
                    _buildRow("المبلغ", "${violation['amount']} ₪"),
                    if (isExpanded) ...[
                      const SizedBox(height: 12),
                      _buildRow("اسم الشرطي", violation['officer'] ?? '---'),
                      _buildRow("الموقع", violation['location'] ?? '---'),
                      _buildRow("ملاحظات", violation['notes'] ?? '---'),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
