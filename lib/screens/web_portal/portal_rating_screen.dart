import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:traffic_department/screens/web_portal/success_dialog.dart';

class PortalRatingScreen extends StatefulWidget {
  const PortalRatingScreen({super.key});

  @override
  State<PortalRatingScreen> createState() => _PortalRatingScreenState();
}

class _PortalRatingScreenState extends State<PortalRatingScreen>
    with TickerProviderStateMixin {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();
  late List<AnimationController> _starControllers;
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _starControllers = List.generate(5, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    for (final controller in _starControllers) {
      controller.dispose();
    }
    _backgroundController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void _handleStarTap(int index) {
    setState(() => selectedRating = index + 1);
    for (int i = 0; i <= index; i++) {
      _starControllers[i].forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Lottie.asset(
                'assets/animations/soft_particles_background.json',
                controller: _backgroundController,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 50,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/star_effect.json',
                          height: 70,
                          repeat: true,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'قيّم بوابة دائرة السير',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final isSelected = index < selectedRating;
                        final controller = _starControllers[index];
                        final animation = Tween<double>(
                          begin: 1.0,
                          end: isSelected ? 1.4 : 1.05,
                        ).animate(
                          CurvedAnimation(
                            parent: controller,
                            curve: Curves.easeOutBack,
                          ),
                        );

                        return GestureDetector(
                          onTap: () => _handleStarTap(index),
                          child: AnimatedBuilder(
                            animation: Listenable.merge([
                              controller,
                              _backgroundController,
                            ]),
                            builder: (context, child) {
                              final scale =
                                  isSelected
                                      ? animation.value
                                      : 1.0 +
                                          (0.03 *
                                              (_backgroundController.value -
                                                      0.5)
                                                  .abs());

                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow:
                                        isSelected
                                            ? [
                                              BoxShadow(
                                                color: Colors.amber.withOpacity(
                                                  0.5,
                                                ),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                            : [],
                                  ),
                                  child: Icon(
                                    isSelected
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 56,
                                    color:
                                        isSelected
                                            ? Colors.amber
                                            : Colors.grey.shade400,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 30),

                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'ما رأيك في البوابة؟',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showSuccessDialog(
                            context: context,
                            title: 'شكراً لتقييمك',
                            message:
                                'نقدّر ملاحظاتك التي تساعدنا على تحسين البوابة الإلكترونية.',
                          );
                        },

                        icon: const Icon(Icons.send),
                        label: const Text('إرسال التقييم'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A5F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
