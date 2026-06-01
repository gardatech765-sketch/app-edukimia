import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/glass_button.dart';
import '../widgets/audio_control.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  // Kata-kata bijak seputar kimia & belajar
  static const _quotes = [
    (
      quote: '"Ilmu adalah cahaya yang menerangi jalan menuju kebenaran."',
      author: '— Imam Al-Ghazali',
    ),
    (
      quote: '"Alam semesta adalah laboratorium terbesar yang pernah ada."',
      author: '— Marie Curie',
    ),
    (
      quote:
          '"Setiap reaksi kimia mengajarkan kita bahwa perubahan adalah keniscayaan."',
      author: '— Lavoisier',
    ),
    (
      quote: '"Belajar bukan tentang mengisi ember, melainkan menyalakan api."',
      author: '— W.B. Yeats',
    ),
  ];

  late final _quote = (_quotes.toList()..shuffle()).first;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
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
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    // Audio control pojok kanan
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: const AudioControl(),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Icon dekoratif
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentNeon.withValues(alpha: 0.07),
                        border: Border.all(
                          color: AppColors.accentNeon.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Text('🌿', style: TextStyle(fontSize: 40)),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Kata bijak
                    Text(
                      _quote.quote,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.65,
                        color: Colors.white,
                        fontFamily: 'Outfit',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _quote.author,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.accentNeon,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Tombol mulai
                    GlassButton(
                      onTap: () {
                        AudioManager.instance.playSfx(AppAssets.tapSfx);
                        Navigator.pushReplacementNamed(context, '/form');
                      },
                      borderColor: AppColors.accentNeon.withValues(alpha: 0.5),
                      fillColor: AppColors.accentNeon.withValues(alpha: 0.12),
                      paddingVertical: 16,
                      borderRadius: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'MULAI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentNeon,
                              letterSpacing: 2,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.accentNeon,
                            size: 20,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
