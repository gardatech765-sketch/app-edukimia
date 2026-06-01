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
  // 8 Materi Pages Data
  static const List<Map<String, String>> materiList = [
    {
      'title': '1. Teori Asam-Basa Arrhenius',
      'subtitle': 'Konsep Dasar Asam & Basa',
      'content':
          'Menurut Svante Arrhenius (1884), asam adalah zat yang menghasilkan ion H⁺ (hidrogen) ketika dilarutkan dalam air, sedangkan basa adalah zat yang menghasilkan ion OH⁻ (hidroksida).\n\n'
          'Contoh asam Arrhenius:\n'
          '• HCl → H⁺ + Cl⁻ (asam klorida)\n'
          '• CH₃COOH → H⁺ + CH₃COO⁻ (asam asetat/cuka)\n\n'
          'Contoh basa Arrhenius:\n'
          '• NaOH → Na⁺ + OH⁻ (natrium hidroksida)\n'
          '• Ca(OH)₂ → Ca²⁺ + 2OH⁻ (kalsium hidroksida)\n\n'
          'Teori Brønsted-Lowry (1923) memperluas konsep ini: asam adalah donor proton (H⁺) dan basa adalah akseptor proton, sehingga reaksi asam-basa dapat terjadi tanpa pelarut air.',
      'icon': '🧪',
    },
    {
      'title': '2. Skala pH & Kekuatan Asam-Basa',
      'subtitle': 'Mengukur Derajat Keasaman',
      'content':
          'pH adalah ukuran konsentrasi ion H⁺ dalam larutan, dengan skala 0–14.\n\n'
          '• pH < 7 → Asam (semakin kecil, semakin kuat)\n'
          '• pH = 7 → Netral (air murni)\n'
          '• pH > 7 → Basa (semakin besar, semakin kuat)\n\n'
          'Rumus: pH = -log[H⁺]\n\n'
          'Contoh pH bahan sehari-hari:\n'
          '• Jus lemon: pH 2–3 (asam kuat)\n'
          '• Cuka: pH 2,4–3,4\n'
          '• Air hujan normal: pH 5,6\n'
          '• Air murni: pH 7\n'
          '• Sabun: pH 9–10\n'
          '• Larutan NaOH: pH 13–14 (basa kuat)\n\n'
          'Asam kuat (HCl, H₂SO₄, HNO₃) terionisasi sempurna, sedangkan asam lemah (CH₃COOH) hanya terionisasi sebagian.',
      'icon': '📊',
    },
    {
      'title': '3. Indikator Asam-Basa',
      'subtitle': 'Cara Mendeteksi Sifat Larutan',
      'content':
          'Indikator adalah zat yang berubah warna sesuai pH larutan. Ada dua jenis utama:\n\n'
          '🔬 Indikator Sintetis:\n'
          '• Kertas lakmus merah → tetap merah (asam), biru (basa)\n'
          '• Kertas lakmus biru → merah (asam), tetap biru (basa)\n'
          '• Fenolftalein: tidak berwarna (asam/netral), merah muda (basa, pH > 8,2)\n'
          '• Metil jingga: merah (asam, pH < 3,1), kuning (basa, pH > 4,4)\n\n'
          '🌿 Indikator Alami:\n'
          '• Kunyit: kuning cerah (asam/netral), merah-coklat (basa)\n'
          '• Kubis ungu: merah (asam), hijau-kuning (basa)\n'
          '• Bunga sepatu: merah (asam), hijau (basa)\n'
          '• Bunga telang: biru (netral), merah muda (asam), hijau (basa)\n\n'
          'Indikator universal dapat menunjukkan nilai pH secara lebih spesifik melalui perubahan warna bertahap.',
      'icon': '🌈',
    },
    {
      'title': '4. Penerapan Asam-Basa dalam Kehidupan',
      'subtitle': 'Relevansi di Sekitar Kita',
      'content':
          'Konsep asam-basa hadir dalam berbagai aspek kehidupan sehari-hari:\n\n'
          '🍋 Makanan & Minuman:\n'
          '• Rasa asam pada buah (sitrat, malat) → asam organik alami\n'
          '• Fermentasi yogurt & tempe menghasilkan asam laktat\n'
          '• Soda kue (NaHCO₃) sebagai basa dalam adonan kue\n\n'
          '🏥 Kesehatan:\n'
          '• Lambung menggunakan HCl (pH 1,5–3,5) untuk mencerna makanan\n'
          '• Antasida (Mg(OH)₂) menetralkan kelebihan asam lambung\n'
          '• Pasta gigi bersifat basa untuk menetralkan asam dari bakteri mulut\n\n'
          '🌱 Pertanian:\n'
          '• Tanah asam (pH < 6) dikapur dengan CaCO₃ agar tanaman tumbuh optimal\n'
          '• Pupuk urea bersifat sedikit asam\n\n'
          '🏭 Industri:\n'
          '• H₂SO₄ digunakan dalam baterai aki dan pembuatan pupuk\n'
          '• NaOH digunakan dalam pembuatan sabun (saponifikasi)',
      'icon': '🌍',
    },
    {
      'title': '5. Etnokimia: Kearifan Lokal & Asam-Basa',
      'subtitle': 'Ilmu Kimia dalam Budaya Nusantara',
      'content':
          'Etnokimia mengkaji pengetahuan kimia yang terkandung dalam praktik budaya dan kearifan lokal masyarakat.\n\n'
          '🌿 Penggunaan Bahan Alam sebagai Indikator:\n'
          '• Masyarakat Jawa menggunakan kunyit untuk menguji keasaman bahan makanan — kunyit berubah merah-coklat saat terkena basa (seperti kapur sirih)\n'
          '• Bunga telang (Clitoria ternatea) digunakan dalam minuman tradisional; warnanya berubah dari biru ke ungu/merah muda saat ditambah perasan jeruk (asam)\n\n'
          '🍃 Praktik Tradisional Berbasis Asam-Basa:\n'
          '• Nginang (menyirih): campuran daun sirih, kapur sirih (Ca(OH)₂), dan pinang menciptakan reaksi basa yang menghasilkan warna merah\n'
          '• Pembuatan tempe & tape: fermentasi menghasilkan asam organik yang mengawetkan makanan secara alami\n'
          '• Penggunaan abu kayu (basa) untuk merendam biji-bijian agar lebih mudah dikupas (nixtamalisasi lokal)\n\n'
          '🏺 Pewarnaan Alami Batik:\n'
          '• Penggunaan tawas (Al₂(SO₄)₃) sebagai mordan bersifat asam untuk mengikat warna alami pada kain\n'
          '• Kapur sirih digunakan untuk mengubah warna indigo menjadi lebih cerah',
      'icon': '🏺',
    },
    {
      'title': '6. Green Chemistry: Kimia Ramah Lingkungan',
      'subtitle': 'Prinsip Kimia Berkelanjutan',
      'content':
          'Green Chemistry (Kimia Hijau) adalah pendekatan yang merancang proses dan produk kimia untuk meminimalkan dampak negatif terhadap lingkungan dan kesehatan.\n\n'
          '12 Prinsip Green Chemistry (Paul Anastas, 1998) yang relevan dengan asam-basa:\n\n'
          '♻️ Pencegahan Limbah:\n'
          '• Lebih baik mencegah terbentuknya limbah daripada mengolahnya\n'
          '• Contoh: menetralkan limbah asam industri dengan basa sebelum dibuang\n\n'
          '🌱 Bahan Baku Terbarukan:\n'
          '• Menggunakan bahan dari sumber alam yang dapat diperbarui\n'
          '• Contoh: asam sitrat dari fermentasi gula (bukan sintesis petrokimia)\n\n'
          '⚗️ Katalis Ramah Lingkungan:\n'
          '• Menggunakan katalis asam/basa alami (enzim) menggantikan asam mineral kuat\n'
          '• Contoh: enzim lipase menggantikan H₂SO₄ dalam reaksi esterifikasi\n\n'
          '💧 Pelarut Aman:\n'
          '• Mengganti pelarut organik berbahaya dengan air atau pelarut bio-based\n'
          '• Reaksi asam-basa dalam air jauh lebih aman dan ramah lingkungan',
      'icon': '🌿',
    },
    {
      'title': '7. Penerapan Green Chemistry Lokal',
      'subtitle': 'Solusi Berkelanjutan dari Bahan Lokal',
      'content':
          'Prinsip green chemistry dapat diterapkan menggunakan bahan-bahan lokal yang mudah ditemukan di Indonesia:\n\n'
          '🍋 Asam dari Sumber Terbarukan:\n'
          '• Asam jawa (Tamarindus indica) mengandung asam tartrat dan sitrat — pengganti asam sintetis dalam pembersih alami\n'
          '• Jeruk nipis sebagai pembersih noda karat (asam sitrat bereaksi dengan oksida besi)\n'
          '• Cuka aren/kelapa sebagai pengawet makanan alami\n\n'
          '🌾 Basa dari Sumber Alami:\n'
          '• Abu sekam padi mengandung K₂CO₃ dan Na₂CO₃ — digunakan sebagai sabun tradisional\n'
          '• Air lindi abu kayu (lye alami) untuk pembuatan sabun tanpa NaOH sintetis\n\n'
          '🔬 Indikator Alami sebagai Pengganti Sintetis:\n'
          '• Ekstrak kubis ungu, bunga telang, atau kunyit menggantikan indikator kimia sintetis di laboratorium sekolah\n'
          '• Lebih aman, murah, dan biodegradable\n\n'
          '🏭 Pengolahan Limbah Asam-Basa:\n'
          '• Limbah asam dari industri dapat dinetralkan dengan kapur (CaCO₃) yang murah dan tersedia lokal\n'
          '• Prinsip: asam + basa → garam + air (reaksi netralisasi)',
      'icon': '🌾',
    },
    {
      'title': '8. Rangkuman & Koneksi Konsep',
      'subtitle': 'Integrasi Asam-Basa, Etnokimia & Green Chemistry',
      'content':
          'Ketiga tema dalam modul ini saling terhubung membentuk pemahaman kimia yang holistik:\n\n'
          '🔗 Koneksi Utama:\n'
          '• Konsep asam-basa (teori, pH, indikator) → fondasi ilmiah\n'
          '• Etnokimia → bukti bahwa masyarakat lokal telah menerapkan kimia secara intuitif selama berabad-abad\n'
          '• Green chemistry → arah masa depan: kimia yang bertanggung jawab terhadap lingkungan\n\n'
          '📌 Poin Kunci:\n'
          '• Asam: pH < 7, donor H⁺, rasa masam, mengubah lakmus biru → merah\n'
          '• Basa: pH > 7, donor OH⁻, rasa pahit/licin, mengubah lakmus merah → biru\n'
          '• Indikator alami (kunyit, bunga telang) = solusi green chemistry lokal\n'
          '• Kearifan lokal (nginang, pewarnaan batik, fermentasi) = etnokimia berbasis asam-basa\n\n'
          '💡 Refleksi:\n'
          'Kimia bukan hanya ilmu di laboratorium — ia hidup dalam tradisi, makanan, dan lingkungan kita. Memahami asam-basa berarti memahami dunia di sekitar kita dengan lebih bijak dan berkelanjutan.',
      'icon': '🔗',
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
