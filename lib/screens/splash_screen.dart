import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/constants.dart';
import '../core/logger_service.dart';
import '../widgets/audio_control.dart';

/// Implements a 3-second animated Splash Screen.
/// Plays BGM automatically and navigates to the Main Menu.
/// Employs a robust CustomPainter erlenmeyer flask fallback animation if Lottie fails.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    logger.i('[SplashScreen] Screen initialized. Initiating BGM...');
    
    // Auto-start looping instrumental music
    AudioManager.instance.initBgm(AppAssets.bgMusic);

    // A 3-second loop for procedural canvas animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Clean, non-backtrackable transition to Menu Screen after exactly 3s
    Timer(const Duration(seconds: 3), () {
      logger.i('[SplashScreen] 3 seconds passed. Navigating to MenuScreen.');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/menu');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.navyStart, AppColors.navyEnd],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated container wrapper with glassmorphism blur
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(28.0),
                    child: Lottie.asset(
                      AppAssets.splashAnimation,
                      errorBuilder: (context, error, stackTrace) {
                        // Graceful visual fallback: High fidelity animated Canvas Flask
                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: CustomFlaskPainter(
                                progress: _animationController.value,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    'KIMIA AIR',
                    style: AppTextStyles.titleStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Asam & Basa Edukasi 2D',
                    style: AppTextStyles.subtitleStyle.copyWith(
                      color: AppColors.accentNeon,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Sleek Neon Progress Bar
                  const SizedBox(
                    width: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentNeon),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders a highly interactive, procedural 2D Erlenmeyer flask with waves and rising bubbles.
class CustomFlaskPainter extends CustomPainter {
  final double progress;

  CustomFlaskPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Paints
    final paintFlask = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final paintGlow = Paint()
      ..color = AppColors.accentNeon.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    final pathFlask = Path();
    
    // Flask dimensions
    final double neckW = w * 0.24;
    final double neckTopY = h * 0.15;
    final double neckBottomY = h * 0.45;
    
    // Erlenmeyer construction
    pathFlask.moveTo(w / 2 - neckW / 2, neckTopY);
    pathFlask.lineTo(w / 2 - neckW / 2, neckBottomY); // Neck Left
    pathFlask.lineTo(w * 0.16, h * 0.86);            // Body Left
    pathFlask.quadraticBezierTo(w * 0.13, h * 0.89, w * 0.18, h * 0.89); // Curve Bottom-Left
    pathFlask.lineTo(w * 0.82, h * 0.89);            // Bottom Flat
    pathFlask.quadraticBezierTo(w * 0.87, h * 0.89, w * 0.84, h * 0.86); // Curve Bottom-Right
    pathFlask.lineTo(w / 2 + neckW / 2, neckBottomY); // Body Right
    pathFlask.lineTo(w / 2 + neckW / 2, neckTopY);    // Neck Right
    pathFlask.quadraticBezierTo(w / 2, neckTopY - 4, w / 2 - neckW / 2, neckTopY); // Lip

    // Draw glass container
    canvas.drawPath(pathFlask, paintGlow);
    canvas.drawPath(pathFlask, paintFlask);

    // Liquid fill using a wave function
    final paintLiquid = Paint()
      ..color = AppColors.accentNeon.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final pathLiquid = Path();
    final double liquidTopY = h * 0.66;
    final double waveAmp = 3.5;
    
    pathLiquid.moveTo(w * 0.26, liquidTopY);
    for (double i = w * 0.26; i <= w * 0.74; i++) {
      final double waveY = liquidTopY + math.sin((i / 14) + (progress * 2 * math.pi)) * waveAmp;
      pathLiquid.lineTo(i, waveY);
    }
    pathLiquid.lineTo(w * 0.75, h * 0.86);
    pathLiquid.quadraticBezierTo(w * 0.79, h * 0.875, w * 0.74, h * 0.875);
    pathLiquid.lineTo(w * 0.26, h * 0.875);
    pathLiquid.quadraticBezierTo(w * 0.21, h * 0.875, w * 0.25, h * 0.86);
    pathLiquid.close();

    canvas.drawPath(pathLiquid, paintLiquid);

    // Bubbles rising inside liquid
    final bubblePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final double bubbleProgress = (progress + (i * 0.25)) % 1.0;
      final double bubbleX = w * 0.35 + (i * (w * 0.09));
      final double startY = h * 0.84;
      final double endY = liquidTopY - 5;
      final double bubbleY = startY - (startY - endY) * bubbleProgress;
      final double bubbleSize = 2.0 + 1.8 * math.sin(bubbleProgress * math.pi);
      
      canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, bubblePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomFlaskPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
