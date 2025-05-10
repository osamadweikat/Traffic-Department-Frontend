import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart' as ui;
import '../../../theme/app_theme.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> with TickerProviderStateMixin {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  late final List<AnimationController> _starControllers;
  bool _versionCopied = false;

  @override
  void initState() {
    super.initState();
    _starControllers = List.generate(5, (index) => AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    ));
  }

  @override
  void dispose() {
    for (var controller in _starControllers) {
      controller.dispose();
    }
    _feedbackController.dispose();
    super.dispose();
  }

  void _showRatingDialog() {
    setState(() => _rating = 0);
    _feedbackController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('rate_app_title'.tr()),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: ui.TextDirection.rtl,
                  children: List.generate(5, (index) {
                    return AnimatedBuilder(
                      animation: _starControllers[index],
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _starControllers[index].value * 2 * 3.1416,
                          child: IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              for (var i = 0; i <= index; i++) {
                                _starControllers[i].forward(from: 0);
                              }
                              setDialogState(() => _rating = index + 1);
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _feedbackController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'write_here'.tr(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('thank_you_feedback'.tr())),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navy,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('submit'.tr(), style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final version = '1.0.0';

    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('about_app_title'.tr()),
          backgroundColor: AppTheme.navy,
        ),
        backgroundColor: AppTheme.lightGrey,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/traffic_logo.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text('app_name'.tr(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              GestureDetector(
                onLongPress: () {
                  ui.Clipboard.setData(ui.ClipboardData(text: version));
                  setState(() => _versionCopied = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('version_copied'.tr())),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) setState(() => _versionCopied = false);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _versionCopied ? Icons.check_circle_outline : Icons.copy,
                        size: 16,
                        color: _versionCopied ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'version_number'.tr(namedArgs: {'version': version}),
                        style: TextStyle(
                          color: _versionCopied ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('about_app_description'.tr(), style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 12),
                      Text('features_title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ...['feature_1', 'feature_2', 'feature_3', 'feature_4'].map(
                        (key) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(child: Text(key.tr())),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('developed_by'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('developer_names'.tr()),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('contact_info'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, color: AppTheme.navy),
                          const SizedBox(width: 8),
                          Text('app_contact_email'.tr()),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, color: AppTheme.navy),
                          const SizedBox(width: 8),
                          Text('dev_contact_email'.tr()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _showRatingDialog,
                icon: const Icon(Icons.star_rate, color: Colors.white),
                label: Text('rate_app'.tr(), style: const TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navy,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}