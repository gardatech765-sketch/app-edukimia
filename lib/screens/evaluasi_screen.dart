import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../core/constants.dart';
import '../core/logger_service.dart';
import '../providers/app_state.dart';
import '../widgets/glass_button.dart';
import '../widgets/audio_control.dart';

/// Renders final scoring metrics, perfect-score Lottie animation,
/// ListView details of missed answers, and offers a full state reset cycle.
class EvaluasiScreen extends StatelessWidget {
  const EvaluasiScreen({super.key});

  /// Plays tap sound, calls provider to clear all progress registers,
  /// and returns to main menu.
  void _resetAndRestart(BuildContext context) {
    logger.i('[EvaluasiScreen] Executing reset sequence.');
    AudioManager.instance.playSfx(AppAssets.tapSfx);

    // Clear Provider state
    Provider.of<AppState>(context, listen: false).resetAll();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: GlassButton(
          borderColor: AppColors.accentNeon.withValues(alpha: 0.5),
          fillColor: AppColors.accentNeon.withValues(alpha: 0.1),
          paddingVertical: 12,
          child: Row(
            children: const [
              Icon(Icons.refresh_rounded, color: AppColors.accentNeon),
              SizedBox(width: 12),
              Text(
                'Pembelajaran diatur ulang dari awal!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Navigator.pop(context);
  }

  /// Evaluates and yields appropriate performance remarks.
  String _resolvePerformanceRemark(int score) {
    if (score == 100) return '🏅 SANGAT SEMPURNA!';
    if (score >= 70) return '🌟 LUAR BIASA!';
    if (score >= 40) return '👍 CUKUP BAIK!';
    return '📚 PERLU BELAJAR LAGI!';
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final score = appState.skorTotal;
    final isPerfect = score == 100;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.navyStart, AppColors.navyEnd],
              ),
            ),
          ),

          // Confetti overlay on perfect score (using procedural as fallback)
          if (isPerfect)
            Lottie.asset(
              AppAssets.celebrationAnimation,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const CustomConfettiPlaceholder();
              },
            ),

          // Main Layout
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          AudioManager.instance.playSfx(AppAssets.tapSfx);
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'EVALUASI PEMBELAJARAN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const AudioControl(),
                    ],
                  ),
                ),

                // Score metrics display area
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: GlassButton(
                    borderColor: isPerfect
                        ? AppColors.accentNeon.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.12),
                    fillColor: isPerfect
                        ? AppColors.accentNeon.withValues(alpha: 0.04)
                        : Colors.white.withValues(alpha: 0.02),
                    borderRadius: 28,
                    paddingVertical: 24,
                    child: Column(
                      children: [
                        Text(
                          _resolvePerformanceRemark(score),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isPerfect
                                ? AppColors.accentNeon
                                : Colors.white70,
                            letterSpacing: 1.5,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$score',
                              style: TextStyle(
                                fontSize: 68,
                                fontWeight: FontWeight.bold,
                                color: isPerfect
                                    ? AppColors.accentNeon
                                    : Colors.white,
                                fontFamily: 'Outfit',
                              ),
                            ),
                            const Text(
                              '/100',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white38,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Pertanyaan Terjawab: ${ChemistryData.quizQuestions.length}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white54,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Title header for logs list
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.feedback_rounded,
                        color: AppColors.accentNeon,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appState.rekapEvaluasi.isEmpty
                            ? 'HASIL ANALISIS SOAL'
                            : 'REKAPITULASI KESALAHAN JAWABAN',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          letterSpacing: 1.0,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ],
                  ),
                ),

                // Error logs List or Perfect Success glass banner
                Expanded(
                  child: appState.rekapEvaluasi.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          child: Center(
                            child: SingleChildScrollView(
                              child: GlassButton(
                                borderColor: AppColors.correctGreen.withValues(
                                  alpha: 0.3,
                                ),
                                fillColor: AppColors.correctGreen.withValues(
                                  alpha: 0.03,
                                ),
                                borderRadius: 24,
                                paddingVertical: 32,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.correctGreen
                                            .withValues(alpha: 0.08),
                                      ),
                                      child: const Icon(
                                        Icons.celebration_rounded,
                                        color: AppColors.correctGreen,
                                        size: 48,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'Luar Biasa!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                      ),
                                      child: Text(
                                        'Anda menjawab semua pertanyaan dengan benar. Konsep kimia Asam Basa telah dikuasai dengan sangat baik!',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          color: Colors.white70,
                                          fontFamily: 'Outfit',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          itemCount: appState.rekapEvaluasi.length,
                          itemBuilder: (context, index) {
                            final recap = appState.rekapEvaluasi[index];
                            final question = recap.question;
                            final wrongAnswer =
                                question.options[recap.selectedWrongIndex];
                            final correctAnswer =
                                question.options[question.correctIndex];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: GlassButton(
                                borderColor: AppColors.incorrectCoral
                                    .withValues(alpha: 0.2),
                                fillColor: Colors.white.withValues(alpha: 0.01),
                                borderRadius: 20,
                                paddingVertical: 20,
                                paddingHorizontal: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Question Header ID
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.incorrectCoral
                                                .withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            'SALAH',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.incorrectCoral,
                                              fontFamily: 'Outfit',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            question.questionText,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'Outfit',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Wrong answer card element
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.cancel_outlined,
                                          color: AppColors.incorrectCoral,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Jawaban Anda: $wrongAnswer',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.incorrectCoral,
                                              fontFamily: 'Outfit',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),

                                    // Correct answer card element
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: AppColors.correctGreen,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Jawaban Benar: $correctAnswer',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.correctGreen,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Outfit',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    const Divider(
                                      color: Colors.white12,
                                      height: 1,
                                    ),
                                    const SizedBox(height: 14),

                                    // Chemistry explanation
                                    const Text(
                                      'PENJELASAN ILMIAH:',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accentNeon,
                                        letterSpacing: 1.0,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      question.explanation,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        height: 1.5,
                                        color: Colors.white70,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Restart button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: GlassButton(
                    onTap: () => _resetAndRestart(context),
                    borderColor: AppColors.accentNeon,
                    fillColor: AppColors.accentNeon.withValues(alpha: 0.12),
                    borderRadius: 22,
                    paddingVertical: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.refresh_rounded,
                          color: AppColors.accentNeon,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'ULANGI PEMBELAJARAN',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentNeon,
                            letterSpacing: 1.2,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Particle elements model for procedural celebration confetti
class ConfettiParticle {
  double x;
  double y;
  Color color;
  double size;
  double speedY;
  double speedX;
  double rotation;
  double rotationSpeed;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speedY,
    required this.speedX,
    required this.rotation,
    required this.rotationSpeed,
  });
}

/// Particle configuration and update controller for raw canvas confetti.
class CustomConfettiPlaceholder extends StatefulWidget {
  const CustomConfettiPlaceholder({super.key});

  @override
  State<CustomConfettiPlaceholder> createState() =>
      _CustomConfettiPlaceholderState();
}

class _CustomConfettiPlaceholderState extends State<CustomConfettiPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();

  final List<Color> _palette = [
    AppColors.accentNeon,
    Colors.amberAccent,
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    AppColors.correctGreen,
  ];

  @override
  void initState() {
    super.initState();
    // A 4-second loop to continuously refresh paint cycles
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _controller.addListener(() {
      if (!mounted) return;
      setState(() {
        for (var p in _particles) {
          p.y += p.speedY;
          p.x += p.speedX;
          p.rotation += p.rotationSpeed;

          // Recycle particles to the top
          if (p.y > MediaQuery.of(context).size.height) {
            p.y = -p.size * 2;
            p.x = _random.nextDouble() * MediaQuery.of(context).size.width;
          }
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_particles.isEmpty) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 45; i++) {
        _particles.add(
          ConfettiParticle(
            x: _random.nextDouble() * size.width,
            y:
                _random.nextDouble() * size.height -
                size.height, // Spawn off-screen top
            color: _palette[_random.nextInt(_palette.length)],
            size: 5.0 + _random.nextDouble() * 7.5,
            speedY: 2.2 + _random.nextDouble() * 3.8,
            speedX: -1.2 + _random.nextDouble() * 2.4,
            rotation: _random.nextDouble() * math.pi * 2,
            rotationSpeed: 0.04 + _random.nextDouble() * 0.08,
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
      painter: CustomConfettiPainter(particles: _particles),
      size: Size.infinite,
    );
  }
}

/// Paints colorful rotating confetti strips onto the Canvas.
class CustomConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  CustomConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rotation);

      // Draw rectangular paper fragment
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 1.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomConfettiPainter oldDelegate) {
    return true; // Redraw frame calculations
  }
}
