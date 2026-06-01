import 'package:flutter/material.dart';

/// Centralized configuration file for the Chemistry (Asam Basa) application.
/// Houses colors, asset paths, typography styling, and raw chemistry data.
class AppColors {
  // Theme Color Palette
  static const Color bgStart = Color(0x00A192FF); // Navy Blue starting point (Parsed from #0A192F)
  static const Color navyStart = Color(0xFF0A192F); // Navy Blue (#0A192F)
  static const Color navyEnd = Color(0xFF020C1B);   // Deep Ocean Blue (#020C1B)
  
  static const Color accentNeon = Color(0xFF64FFDA); // Bright Neon Cyan (#64FFDA)
  
  // Validation Colors
  static const Color correctGreen = Color(0xFF00BFA5); // Teal Green for correct answers
  static const Color incorrectCoral = Color(0xFFFF5252); // Coral Red for incorrect answers
  
  // Transparent colors for Glassmorphic borders and fills
  static Color glassBg = Colors.white.withValues(alpha: 0.06);
  static Color glassBorder = Colors.white.withValues(alpha: 0.12);
  static Color glassAccentBorder = const Color(0xFF64FFDA).withValues(alpha: 0.3);
}

class AppAssets {
  // Animations (Lottie files)
  static const String splashAnimation = 'assets/animations/splash.json';
  static const String bubblesAnimation = 'assets/animations/bubbles.json';
  static const String celebrationAnimation = 'assets/animations/celebration.json';
  
  // Audio files (audioplayers assets use prefix assets/ by default or relative)
  static const String bgMusic = 'audio/background.mp3';
  static const String tapSfx = 'audio/tap.wav';
  static const String correctSfx = 'audio/correct.wav';
  static const String incorrectSfx = 'audio/incorrect.wav';
}

class AppTextStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.5,
    fontFamily: 'Outfit',
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF8892B0), // Cool gray-blue
    fontFamily: 'Outfit',
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    height: 1.6,
    color: Colors.white70,
    fontFamily: 'Outfit',
  );

  static const TextStyle buttonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.navyEnd,
    letterSpacing: 1.2,
    fontFamily: 'Outfit',
  );
}

class ChemistryData {
  // 3 Materi Pages Data
  static const List<Map<String, String>> materiList = [
    {
      'title': '1. Pengertian Asam & Basa',
      'subtitle': 'Teori Klasik Svante Arrhenius',
      'content': 'Asam adalah zat yang menghasilkan ion hidrogen (H+) dalam air, sedangkan Basa menghasilkan ion hidroksida (OH-). Teori ini pertama kali dikemukakan oleh Svante Arrhenius pada tahun 1884. Pemahaman ini melandasi konsep keasaman cairan di sekitar kita.',
      'icon': '🧪',
    },
    {
      'title': '2. Sifat Fisik & Kimia',
      'subtitle': 'Karakteristik Senyawa',
      'content': 'Larutan asam memiliki rentang pH di bawah 7, rasanya masam, dan bersifat korosif (dapat merusak logam). Sebaliknya, larutan basa memiliki pH di atas 7, terasa licin seperti sabun (saponifikasi), dan bersifat kaustik (dapat membakar jaringan kulit).',
      'icon': '⚡',
    },
    {
      'title': '3. Indikator Asam Basa',
      'subtitle': 'Identifikasi Cepat & Akurat',
      'content': 'Kertas lakmus adalah indikator asam-basa paling praktis. Larutan asam akan mengubah kertas lakmus biru menjadi merah (merah menandakan bahaya asam). Sebaliknya, larutan basa akan mengubah kertas lakmus merah menjadi biru (blue = basa).',
      'icon': '⚗️',
    },
  ];

  // 3 Quiz Questions Data
  static const List<Map<String, dynamic>> quizQuestions = [
    {
      'question': 'Kertas lakmus biru jika dimasukkan ke dalam larutan asam akan berubah menjadi warna apa?',
      'options': [
        'A. Tetap Biru',
        'B. Merah',
        'C. Kuning',
        'D. Hijau'
      ],
      'correctIndex': 1,
      'explanation': 'Larutan asam memiliki sifat spesifik mengubah kertas lakmus biru menjadi merah, menandakan sifat asamnya.',
    },
    {
      'question': 'Berapakah rentang derajat keasaman (pH) untuk larutan yang bersifat basa?',
      'options': [
        'A. pH kurang dari 7',
        'B. pH sama dengan 7',
        'C. pH lebih dari 7',
        'D. pH sama dengan 0'
      ],
      'correctIndex': 2,
      'explanation': 'Skala pH berkisar antara 0 - 14. Basa selalu berada di atas skala 7 hingga 14. Skala 7 adalah netral (air murni), dan di bawah 7 bersifat asam.',
    },
    {
      'question': 'Menurut teori Arrhenius, zat yang melepaskan ion OH- ketika dilarutkan dalam air disebut...',
      'options': [
        'A. Asam',
        'B. Garam',
        'C. Larutan Netral',
        'D. Basa'
      ],
      'correctIndex': 3,
      'explanation': 'Teori Arrhenius mendefinisikan asam sebagai pelepas ion hidrogen (H+), sedangkan Basa melepaskan ion hidroksida (OH-) dalam larutan air.',
    },
  ];
}
