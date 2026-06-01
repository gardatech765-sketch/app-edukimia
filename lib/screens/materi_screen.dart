import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/logger_service.dart';
import '../providers/app_state.dart';
import '../widgets/glass_button.dart';
import '../widgets/audio_control.dart';

/// Renders the horizontal slides for chemistry acids and bases training.
/// Unlocks subsequent quiz once the reader clicks "Selesai Membaca" on page 3.
class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    logger.i(
      '[MateriScreen] Opened learning module. Starting page at index 0.',
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Sets state in provider, plays BGM tap feedback, and returns to dashboard.
  void _completeModule() {
    logger.i(
      '[MateriScreen] Completed final slide. Dispatching markMateriSelesai.',
    );
    AudioManager.instance.playSfx(AppAssets.tapSfx);

    // Unlock next phase
    Provider.of<AppState>(context, listen: false).markMateriSelesai();

    // Success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: GlassButton(
          borderColor: AppColors.correctGreen.withValues(alpha: 0.5),
          fillColor: AppColors.correctGreen.withValues(alpha: 0.1),
          paddingVertical: 12,
          child: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: AppColors.correctGreen),
              SizedBox(width: 12),
              Text(
                'Modul Selesai! Latihan Soal Terbuka!',
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

  @override
  Widget build(BuildContext context) {
    final pages = ChemistryData.materiList;

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

          // Glowing background aura
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentNeon.withValues(alpha: 0.03),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Navigation Header
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
                        'MODUL PEMBELAJARAN',
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

                // Top Progress indicator lines
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: List.generate(
                      pages.length,
                      (index) => Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: _currentPageIndex >= index
                                ? AppColors.accentNeon
                                : Colors.white12,
                            boxShadow: _currentPageIndex == index
                                ? [
                                    BoxShadow(
                                      color: AppColors.accentNeon.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // PageView swiping area
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      logger.d('[MateriScreen] Swiped to page index: $index');
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        child: Center(
                          child: SingleChildScrollView(
                            child: GlassButton(
                              borderColor: Colors.white.withValues(alpha: 0.12),
                              fillColor: Colors.white.withValues(alpha: 0.03),
                              paddingVertical: 36,
                              paddingHorizontal: 28,
                              borderRadius: 36,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon Badge
                                  Center(
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.accentNeon.withValues(
                                          alpha: 0.05,
                                        ),
                                        border: Border.all(
                                          color: AppColors.accentNeon
                                              .withValues(alpha: 0.2),
                                          width: 1.5,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        item['icon'] ?? '📖',
                                        style: const TextStyle(fontSize: 38),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Title
                                  Text(
                                    item['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Subtitle
                                  Text(
                                    item['subtitle'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.accentNeon,
                                      letterSpacing: 1.0,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  const Divider(
                                    color: Colors.white12,
                                    height: 1,
                                  ),
                                  const SizedBox(height: 18),

                                  // Content Body
                                  Text(
                                    item['content'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                      color: Colors.white70,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Lower control button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Swipe back button helper
                      Opacity(
                        opacity: _currentPageIndex > 0 ? 1.0 : 0.0,
                        child: GlassButton(
                          onTap: _currentPageIndex > 0
                              ? () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOutCubic,
                                  );
                                }
                              : null,
                          paddingVertical: 12,
                          paddingHorizontal: 20,
                          borderRadius: 16,
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white70,
                          ),
                        ),
                      ),

                      // Primary indicator button
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _currentPageIndex == pages.length - 1
                              ? GlassButton(
                                  onTap: _completeModule,
                                  borderColor: AppColors.accentNeon,
                                  fillColor: AppColors.accentNeon.withValues(
                                    alpha: 0.12,
                                  ),
                                  paddingVertical: 14,
                                  borderRadius: 20,
                                  child: const Text(
                                    'SELESAI MEMBACA',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accentNeon,
                                      letterSpacing: 1.2,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                )
                              : GlassButton(
                                  onTap: () {
                                    _pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOutCubic,
                                    );
                                  },
                                  paddingVertical: 14,
                                  borderRadius: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'LANJUT',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1.2,
                                          fontFamily: 'Outfit',
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),

                      // Fake spacer on final page to maintain layout symmetry
                      Opacity(
                        opacity: _currentPageIndex < pages.length - 1
                            ? 1.0
                            : 0.0,
                        child: GlassButton(
                          onTap: _currentPageIndex < pages.length - 1
                              ? () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOutCubic,
                                  );
                                }
                              : null,
                          paddingVertical: 12,
                          paddingHorizontal: 20,
                          borderRadius: 16,
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
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
