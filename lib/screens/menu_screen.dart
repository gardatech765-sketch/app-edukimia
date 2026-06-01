import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../core/constants.dart';
import '../core/logger_service.dart';
import '../providers/app_state.dart';
import '../widgets/audio_control.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _navigateTo(BuildContext context, String route) {
    AudioManager.instance.playSfx(AppAssets.tapSfx);
    logger.i('[MenuScreen] Navigating to: $route');
    Navigator.pushNamed(context, route);
  }

  void _triggerLockWarning(BuildContext context, String message) {
    HapticFeedback.vibrate();
    AudioManager.instance.playSfx(AppAssets.incorrectSfx);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.incorrectCoral.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.incorrectCoral.withValues(alpha: 0.4), width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_rounded, color: AppColors.incorrectCoral, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(message,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit', fontSize: 13)),
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
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    // Breakpoints
    final bool isSmall  = h < 640;   // iPhone SE
    final bool isMedium = h < 780;   // iPhone 12/13
    final bool isTablet = w >= 600;  // Tablet / landscape lebar

    final double hPad         = isTablet ? w * 0.12 : 20.0;
    final double sectionGap   = isSmall ? 10.0 : isMedium ? 14.0 : 20.0;
    final double iconSize     = isSmall ? 72.0 : isTablet ? 120.0 : 96.0;
    final double titleSize    = isSmall ? 16.0 : isTablet ? 24.0 : 19.0;
    final double subtitleSize = isSmall ? 11.0 : 13.0;
    final double tileVPad     = isSmall ? 11.0 : 15.0;
    final double avatarSize   = isSmall ? 38.0 : 44.0;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D1F3C), Color(0xFF020C1B)],
              ),
            ),
          ),
          // Dekorasi sudut proporsional
          Positioned(
            top: -w * 0.15, right: -w * 0.15,
            child: Container(
              width: w * 0.55, height: w * 0.55,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: AppColors.accentNeon.withValues(alpha: 0.04)),
            ),
          ),
          Positioned(
            bottom: -w * 0.2, left: -w * 0.12,
            child: Container(
              width: w * 0.65, height: w * 0.65,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: AppColors.accentNeon.withValues(alpha: 0.03)),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: hPad),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [

                            SizedBox(height: sectionGap * 0.7),

                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Container(
                                    width: 34, height: 34,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.accentNeon.withValues(alpha: 0.1),
                                      border: Border.all(
                                          color: AppColors.accentNeon.withValues(alpha: 0.3), width: 1),
                                    ),
                                    child: const Center(child: Text('⚗️', style: TextStyle(fontSize: 15))),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text('KIMIA AIR', style: TextStyle(
                                        fontSize: isTablet ? 20 : 17, fontWeight: FontWeight.bold,
                                        color: AppColors.accentNeon, letterSpacing: 2, fontFamily: 'Outfit')),
                                    Text('Asam & Basa Edukasi', style: TextStyle(
                                        fontSize: isTablet ? 13 : 11, color: const Color(0xFF8892B0), fontFamily: 'Outfit')),
                                  ]),
                                ]),
                                const AudioControl(),
                              ],
                            ),

                            SizedBox(height: sectionGap),

                            // Profile card
                            if (appState.isProfileSet)
                              Container(
                                padding: EdgeInsets.all(isSmall ? 10 : 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: AppColors.accentNeon.withValues(alpha: 0.2), width: 1),
                                ),
                                child: Row(children: [
                                  Container(
                                    width: avatarSize, height: avatarSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.accentNeon.withValues(alpha: 0.12),
                                      border: Border.all(
                                          color: AppColors.accentNeon.withValues(alpha: 0.35), width: 1.5),
                                    ),
                                    child: Center(child: Text(appState.selectedAvatar,
                                        style: TextStyle(fontSize: avatarSize * 0.52))),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(appState.nama, overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: isSmall ? 13 : 15,
                                            fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Outfit')),
                                      const SizedBox(height: 2),
                                      Text('${appState.kelas}  ·  ${appState.sekolah}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: isSmall ? 11 : 12,
                                            color: Colors.white54, fontFamily: 'Outfit')),
                                    ],
                                  )),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentNeon.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: AppColors.accentNeon.withValues(alpha: 0.25), width: 1),
                                    ),
                                    child: const Text('Siswa', style: TextStyle(fontSize: 11,
                                        color: AppColors.accentNeon, fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          backgroundColor: const Color(0xFF0D1F3C),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          title: const Text('Keluar?', style: TextStyle(color: Colors.white, fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
                                          content: const Text('Semua progress akan direset dan kamu perlu mengisi data diri ulang.', style: TextStyle(color: Colors.white54, fontFamily: 'Outfit', fontSize: 13)),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Batal', style: TextStyle(color: Colors.white38, fontFamily: 'Outfit')),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Ya, Keluar', style: TextStyle(color: AppColors.incorrectCoral, fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        Provider.of<AppState>(context, listen: false).resetAll();
                                        Navigator.pushReplacementNamed(context, '/form');
                                      }
                                    },
                                    child: Icon(Icons.logout_rounded,
                                        color: Colors.white38, size: isSmall ? 18 : 20),
                                  ),
                                ]),
                              ),

                            SizedBox(height: sectionGap),

                            // Icon tengah
                            Center(
                              child: Container(
                                width: iconSize, height: iconSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.accentNeon.withValues(alpha: 0.06),
                                  border: Border.all(
                                      color: AppColors.accentNeon.withValues(alpha: 0.15), width: 1.5),
                                ),
                                child: Lottie.asset(AppAssets.splashAnimation, fit: BoxFit.contain,
                                  errorBuilder: (ctx, e, st) => Center(
                                    child: Text('🧪', style: TextStyle(fontSize: iconSize * 0.44)))),
                              ),
                            ),

                            SizedBox(height: sectionGap * 0.7),

                            Center(child: Text('Pilih Modul Belajar', style: TextStyle(
                                fontSize: titleSize, fontWeight: FontWeight.bold,
                                color: Colors.white, fontFamily: 'Outfit', letterSpacing: 0.4))),
                            const SizedBox(height: 4),
                            Center(child: Text('Selesaikan setiap tahap secara berurutan',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: subtitleSize,
                                    color: Colors.white38, fontFamily: 'Outfit'))),

                            SizedBox(height: sectionGap),

                            // Tiles
                            _MenuTile(number: '01', title: 'Modul Materi',
                              subtitle: 'Teori Asam & Basa Arrhenius',
                              icon: Icons.menu_book_rounded, isUnlocked: true,
                              vPad: tileVPad, isSmall: isSmall, isTablet: isTablet,
                              onTap: () => _navigateTo(context, '/materi')),
                            SizedBox(height: isSmall ? 8 : 12),

                            _MenuTile(number: '02', title: 'Latihan Soal',
                              subtitle: appState.isMateriSelesai ? 'Uji pemahaman kamu' : 'Selesaikan materi dulu',
                              icon: Icons.psychology_rounded, isUnlocked: appState.isMateriSelesai,
                              vPad: tileVPad, isSmall: isSmall, isTablet: isTablet,
                              onTap: appState.isMateriSelesai
                                  ? () => _navigateTo(context, '/latihan')
                                  : () => _triggerLockWarning(context, 'Pelajari semua materi terlebih dahulu!')),
                            SizedBox(height: isSmall ? 8 : 12),

                            _MenuTile(number: '03', title: 'Rekap Evaluasi',
                              subtitle: appState.isSoalSelesai ? 'Lihat hasil belajarmu' : 'Selesaikan latihan soal dulu',
                              icon: Icons.analytics_rounded, isUnlocked: appState.isSoalSelesai,
                              vPad: tileVPad, isSmall: isSmall, isTablet: isTablet,
                              onTap: appState.isSoalSelesai
                                  ? () => _navigateTo(context, '/evaluasi')
                                  : () => _triggerLockWarning(context, 'Selesaikan latihan soal terlebih dahulu!')),

                            const Spacer(),

                            _ProgressBar(appState: appState, isSmall: isSmall),
                            SizedBox(height: isSmall ? 14 : 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String number, title, subtitle;
  final IconData icon;
  final bool isUnlocked, isSmall, isTablet;
  final VoidCallback onTap;
  final double vPad;

  const _MenuTile({
    required this.number, required this.title, required this.subtitle,
    required this.icon, required this.isUnlocked, required this.onTap,
    required this.vPad, required this.isSmall, required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = isUnlocked ? AppColors.accentNeon : Colors.white24;
    final double circleSize     = isSmall ? 36 : isTablet ? 50 : 42;
    final double titleFontSize  = isSmall ? 13 : isTablet ? 17 : 15;
    final double subFontSize    = isSmall ? 11 : isTablet ? 13 : 12;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: vPad),
        decoration: BoxDecoration(
          color: isUnlocked
              ? AppColors.accentNeon.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isUnlocked
                ? AppColors.accentNeon.withValues(alpha: 0.28)
                : Colors.white.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
        child: Row(children: [
          Container(
            width: circleSize, height: circleSize,
            decoration: BoxDecoration(shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.12),
                border: Border.all(color: accent.withValues(alpha: 0.28), width: 1)),
            child: Center(child: isUnlocked
                ? Icon(icon, color: accent, size: circleSize * 0.48)
                : Icon(Icons.lock_outline_rounded, color: Colors.white24, size: circleSize * 0.44)),
          ),
          SizedBox(width: isSmall ? 10 : 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(number, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                  color: accent.withValues(alpha: 0.65), fontFamily: 'Outfit', letterSpacing: 1.2)),
              const SizedBox(width: 6),
              if (isUnlocked) Container(width: 5, height: 5,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      color: AppColors.accentNeon.withValues(alpha: 0.8))),
            ]),
            const SizedBox(height: 2),
            Text(title, style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.white : Colors.white38, fontFamily: 'Outfit')),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: subFontSize,
                color: isUnlocked ? Colors.white54 : Colors.white24, fontFamily: 'Outfit')),
          ])),
          Icon(isUnlocked ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
              color: isUnlocked ? AppColors.accentNeon.withValues(alpha: 0.55) : Colors.white12,
              size: isSmall ? 18 : 22),
        ]),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final AppState appState;
  final bool isSmall;
  const _ProgressBar({required this.appState, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    final int done = (appState.isMateriSelesai ? 1 : 0) + (appState.isSoalSelesai ? 1 : 0);
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Progress Belajar', style: TextStyle(
            fontSize: isSmall ? 11 : 12, color: Colors.white38, fontFamily: 'Outfit')),
        Text('$done / 2 Selesai', style: TextStyle(
            fontSize: isSmall ? 11 : 12, color: AppColors.accentNeon,
            fontFamily: 'Outfit', fontWeight: FontWeight.w600)),
      ]),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: done / 2,
          minHeight: isSmall ? 5 : 6,
          backgroundColor: Colors.white.withValues(alpha: 0.08),
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentNeon),
        ),
      ),
    ]);
  }
}