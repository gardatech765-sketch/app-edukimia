import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../core/constants.dart';
import '../core/logger_service.dart';
import '../providers/app_state.dart';
import '../widgets/glass_button.dart';
import '../widgets/audio_control.dart';

/// The Main Hub / Dashboard screen of the application.
/// Manages route entry validation, status warnings, BGM toggles, and screen unlocks.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  /// Plays a light tap audio and performs navigation.
  void _navigateTo(BuildContext context, String route) {
    AudioManager.instance.playSfx(AppAssets.tapSfx);
    logger.i('[MenuScreen] Navigating to: $route');
    Navigator.pushNamed(context, route);
  }

  /// Triggers heavy haptic warnings and throws a sleek glass warning snackbar.
  void _triggerLockWarning(BuildContext context, String message) {
    HapticFeedback.vibrate(); // Heavy vibration warning
    AudioManager.instance.playSfx(AppAssets.incorrectSfx);
    logger.w('[MenuScreen] Tap blocked: $message');

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: GlassButton(
          borderColor: AppColors.incorrectCoral.withValues(alpha: 0.5),
          fillColor: AppColors.incorrectCoral.withValues(alpha: 0.1),
          paddingVertical: 12,
          child: Row(
            children: [
              const Icon(Icons.lock_rounded, color: AppColors.incorrectCoral),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.navyStart, AppColors.navyEnd],
              ),
            ),
          ),

          // Lottie Bubbles Background with custom procedural painter as fallback
          Lottie.asset(
            AppAssets.bubblesAnimation,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return const CustomBubblesPlaceholder();
            },
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Upper Control Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'KIMIA AIR',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentNeon,
                              letterSpacing: 2,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          Text(
                            'Asam & Basa Edukasi',
                            style: AppTextStyles.subtitleStyle.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      // Floating Audio Controller
                      const AudioControl(),
                    ],
                  ),
                  const Spacer(flex: 2),

                  // Center Greeting/Visual
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentNeon.withValues(alpha: 0.04),
                        border: Border.all(
                          color: AppColors.accentNeon.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: const Text('🧪', style: TextStyle(fontSize: 52)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'Silakan Pilih Modul Belajar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Pahami materi untuk membuka tantangan soal.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                        fontFamily: 'Outfit',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),

                  // Navigation Glass Buttons Stack (Vertically Aligned)
                  // 1. MATERI (Always Active)
                  GlassButton(
                    onTap: () => _navigateTo(context, '/materi'),
                    borderColor: AppColors.accentNeon.withValues(alpha: 0.25),
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.menu_book_rounded,
                          color: AppColors.accentNeon,
                          size: 24,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '1. MODUL MATERI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. LATIHAN SOAL (Locked if isMateriSelesai is false)
                  Opacity(
                    opacity: appState.isMateriSelesai ? 1.0 : 0.45,
                    child: GlassButton(
                      onTap: appState.isMateriSelesai
                          ? () => _navigateTo(context, '/latihan')
                          : () => _triggerLockWarning(
                              context,
                              'Pelajari semua materi terlebih dahulu untuk membuka latihan soal!',
                            ),
                      borderColor: appState.isMateriSelesai
                          ? AppColors.accentNeon.withValues(alpha: 0.35)
                          : Colors.white.withValues(alpha: 0.08),
                      fillColor: appState.isMateriSelesai
                          ? AppColors.accentNeon.withValues(alpha: 0.04)
                          : Colors.white.withValues(alpha: 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            appState.isMateriSelesai
                                ? Icons.psychology_rounded
                                : Icons.lock_outline_rounded,
                            color: appState.isMateriSelesai
                                ? AppColors.accentNeon
                                : Colors.white60,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '2. LATIHAN SOAL',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appState.isMateriSelesai
                                  ? Colors.white
                                  : Colors.white60,
                              letterSpacing: 1.2,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. EVALUASI (Locked if isSoalSelesai is false)
                  Opacity(
                    opacity: appState.isSoalSelesai ? 1.0 : 0.45,
                    child: GlassButton(
                      onTap: appState.isSoalSelesai
                          ? () => _navigateTo(context, '/evaluasi')
                          : () => _triggerLockWarning(
                              context,
                              'Selesaikan latihan soal terlebih dahulu untuk melihat evaluasi!',
                            ),
                      borderColor: appState.isSoalSelesai
                          ? AppColors.accentNeon.withValues(alpha: 0.35)
                          : Colors.white.withValues(alpha: 0.08),
                      fillColor: appState.isSoalSelesai
                          ? AppColors.accentNeon.withValues(alpha: 0.04)
                          : Colors.white.withValues(alpha: 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            appState.isSoalSelesai
                                ? Icons.analytics_rounded
                                : Icons.lock_outline_rounded,
                            color: appState.isSoalSelesai
                                ? AppColors.accentNeon
                                : Colors.white60,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '3. REKAP EVALUASI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appState.isSoalSelesai
                                  ? Colors.white
                                  : Colors.white60,
                              letterSpacing: 1.2,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Model for dynamic procedural background particles
class ChemicalBubble {
  double x;
  double y;
  double radius;
  double speed;
  double angle;
  double drift;

  ChemicalBubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.angle,
    required this.drift,
  });
}

/// Particle generator and controller for floating, glassy bubbles background.
class CustomBubblesPlaceholder extends StatefulWidget {
  const CustomBubblesPlaceholder({super.key});

  @override
  State<CustomBubblesPlaceholder> createState() =>
      _CustomBubblesPlaceholderState();
}

class _CustomBubblesPlaceholderState extends State<CustomBubblesPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ChemicalBubble> _bubbles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    // Smooth 10s loop to continuously refresh paint frames
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _controller.addListener(() {
      if (!mounted) return;
      setState(() {
        for (var bubble in _bubbles) {
          bubble.y -= bubble.speed;
          bubble.angle += 0.04;
          bubble.x += math.sin(bubble.angle) * bubble.drift;

          // Reset particles to bottom once they travel off-screen
          if (bubble.y < -bubble.radius * 2) {
            bubble.y = MediaQuery.of(context).size.height + bubble.radius * 2;
            bubble.x = _random.nextDouble() * MediaQuery.of(context).size.width;
          }
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bubbles.isEmpty) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 22; i++) {
        _bubbles.add(
          ChemicalBubble(
            x: _random.nextDouble() * size.width,
            y: _random.nextDouble() * size.height,
            radius: 3.5 + _random.nextDouble() * 11.5,
            speed: 0.6 + _random.nextDouble() * 1.3,
            angle: _random.nextDouble() * math.pi * 2,
            drift: 0.15 + _random.nextDouble() * 0.45,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomBubblesPainter(bubbles: _bubbles),
      size: Size.infinite,
    );
  }
}

/// Draws glassy, translucent liquid bubbles using raw canvas operations.
class CustomBubblesPainter extends CustomPainter {
  final List<ChemicalBubble> bubbles;

  CustomBubblesPainter({required this.bubbles});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = AppColors.accentNeon.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final fillPaint = Paint()
      ..color = AppColors.accentNeon.withValues(alpha: 0.015)
      ..style = PaintingStyle.fill;

    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    for (var bubble in bubbles) {
      canvas.drawCircle(Offset(bubble.x, bubble.y), bubble.radius, fillPaint);
      canvas.drawCircle(Offset(bubble.x, bubble.y), bubble.radius, strokePaint);

      // glossy reflection speck
      canvas.drawCircle(
        Offset(
          bubble.x - bubble.radius * 0.35,
          bubble.y - bubble.radius * 0.35,
        ),
        bubble.radius * 0.15,
        glossPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomBubblesPainter oldDelegate) {
    return true; // Re-drawn continuously via the animation listener
  }
}
