Bertindaklah sebagai Senior Flutter Developer yang ahli dalam membangun antarmuka pengguna interaktif, animasi, dan arsitektur aplikasi tanpa peladen (serverless).

Tugas Anda adalah membuat aplikasi edukasi 2D interaktif bertema Kimia (Asam Basa). Hasilkan kode Flutter yang bersih, terstruktur, dan mematuhi spesifikasi desain, logika, dan arsitektur berikut secara ketat.

1. ARSITEKTUR & MANAJEMEN STATUS

Dilarang menggunakan basis data (seperti SQLite atau Hive) atau layanan ujung belakang (seperti Firebase).

Gunakan memori lokal dengan pengelola status bawaan atau paket Provider.

Daftarkan variabel status global berikut:

bool isMateriSelesai = false;

bool isSoalSelesai = false;

int skorTotal = 0;

List<Map<String, dynamic>> rekapEvaluasi = [];

2. SISTEM DESAIN & TEMA VISUAL (KIMIA AIR)

Palet Warna Latar: Gradasi linier dari Biru Tua (Navy Blue, misal: #0A192F) ke Biru Laut Pekat (#020C1B).

Palet Warna Aksen: Cyan Cerah atau Biru Neon (#64FFDA) untuk sorotan dan tombol aktif.

Warna Validasi: Hijau Toska untuk jawaban benar, Merah Koral untuk jawaban salah.

Gaya UI: Terapkan efek Glassmorphism (wadah tembus pandang dengan efek buram/blur) untuk semua kartu dan tombol. Gunakan sudut yang sangat membulat (border radius besar) menyerupai tetesan air.

Latar Belakang Global: Integrasikan animasi Lottie berupa gelembung air yang bergerak perlahan dari bawah ke atas secara terus-menerus pada menu utama.

3. SISTEM AUDIO & HAPTIK

Wajib mengintegrasikan paket audioplayers dan HapticFeedback.

Putar musik latar instrumental secara otomatis (berulang, volume 30%).

Sediakan tombol kontrol melayang di Menu Utama untuk mematikan/menyalakan audio global.

Terapkan efek suara: suara tetesan air saat tombol ditekan, denting ceria untuk jawaban kuis benar, dan gelembung pecah untuk jawaban salah.

4. SPESIFIKASI LAYAR & NAVIGASI

A. Splash Screen

Tampilan: Latar gradasi penuh dengan penampung di tengah untuk animasi Lottie (tabung erlenmeyer).

Logika: Berjalan selama 3 detik, lalu berpindah ke Menu Utama (tanpa opsi kembali).

B. Menu Utama (Beranda)

Tampilan: Tiga tombol besar bersusun vertikal bergaya Glassmorphism.

Tombol 1 (Materi): Selalu aktif. Ikon buku. Mengarahkan ke Layar Materi.

Tombol 2 (Latihan Soal): Jika isMateriSelesai salah, redupkan tombol, tampilkan ikon gembok, dan berikan peringatan getar jika ditekan. Jika benar, aktifkan tombol dengan warna aksen.

Tombol 3 (Evaluasi): Membaca status isSoalSelesai dengan aturan kunci yang sama seperti Tombol 2.

C. Layar Materi

Tampilan: Gunakan PageView agar pengguna dapat menggeser materi panjang ke samping.

Logika: Di halaman terakhir, tampilkan tombol Selesai Membaca. Saat ditekan, perbarui isMateriSelesai menjadi benar, lalu arahkan kembali ke Menu Utama.

D. Layar Latihan Soal

Tampilan: Satu soal per layar dengan empat tombol pilihan ganda Glassmorphism.

Logika Validasi Instan: Saat dijawab, berikan umpan balik haptik dan efek suara yang sesuai. Jika salah, tombol menjadi merah dan tombol yang benar otomatis menjadi hijau.

Logika Perekaman: Simpan soal yang salah dijawab beserta kunci penjelasannya ke dalam rekapEvaluasi.

Transisi: Berikan jeda 2 detik setelah menjawab sebelum beralih ke soal berikutnya.

Penyelesaian: Pada soal terakhir, tampilkan tombol Selesaikan Kuis. Perbarui isSoalSelesai menjadi benar, hitung skorTotal, dan kembalikan ke Menu Utama.

E. Layar Evaluasi

Tampilan: skorTotal di bagian atas. Jika skor sempurna, tampilkan animasi Lottie perayaan.

Konten: Gunakan ListView.builder untuk merender daftar rekapEvaluasi (hanya menampilkan soal yang salah dan penjelasannya).

Logika Ulang: Tombol Ulangi Pembelajaran di bawah untuk mengatur semua variabel boolean menjadi salah, mengosongkan daftar rekap, mengatur skor menjadi 0, dan kembali ke Menu Utama.

Tuliskan kode untuk struktur utama, navigasi, dan antarmuka pengguna secara lengkap. Jangan menambahkan fitur kompleks di luar instruksi ini.

Master Implementation Plan: Chemistry Education App

Act as a Senior Flutter Developer expert in UI/UX, animations, and serverless architecture. Your task is to generate a complete, production-ready Flutter application under the lib/ directory based on the following strict specifications.

1. Architecture & State Management

Do not use any local databases (SQLite, Hive) or backend services (Firebase).

Use the provider package with ChangeNotifier for global state management.

Create lib/app_state.dart containing:

bool isMateriSelesai = false;

bool isSoalSelesai = false;

int skorTotal = 0;

A list of recap items using a strongly-typed model.

Implement structured logging using the logger package. Create lib/core/logger_service.dart to initialize the logger. Inject info and debug logs at every state mutation and screen transition.

Create strongly-typed models: lib/models/question_model.dart and lib/models/recap_model.dart.

Create lib/core/constants.dart to store all hex colors, asset paths, and text styles.

2. Visual & Audio System

Theme: Navy Blue (#0A192F) to Deep Ocean Blue (#020C1B) gradient background. Accents in Bright Cyan/Neon Blue (#64FFDA). Correct validation is Teal Green, incorrect is Coral Red.

UI Style: Glassmorphism for all cards and buttons (translucent with blur effect and large rounded corners resembling water drops).

Audio: Integrate audioplayers for a looping instrumental background track (30% volume). Add a floating toggle button on the Main Menu to mute/unmute.

Haptics & SFX: Use HapticFeedback and short sound effects (water drop for button taps, bright chime for correct answers, bubble pop for incorrect answers). Wrap audio initialization in try-catch blocks to prevent crashes if assets are missing.

Assets: All Lottie and audio files must be bundled locally (e.g., assets/animations/, assets/audio/). Include a looping water bubble Lottie animation in the background of the Main Menu.

3. Screens & Navigation

Splash Screen: Full-screen gradient with a central Lottie animation (Erlenmeyer flask). Navigates to MenuScreen after 3 seconds without a back option.

Menu Screen: Three glassmorphism buttons.

Materi: Always active.

Latihan Soal: Unlocked only if isMateriSelesai is true. If false, show a padlock icon, dim the button, and vibrate on tap.

Evaluasi: Unlocked only if isSoalSelesai is true.

Materi Screen: Uses a PageView for content. The final page has a Finish Reading button that sets isMateriSelesai = true and pops back to the menu.

Latihan Soal Screen: One question per screen. Instant validation on tap (selected button turns red if wrong, correct button turns green). Updates the recap model if wrong. Moves to the next question after a 2-second delay. The final question calculates skorTotal, sets isSoalSelesai = true, and returns to the menu.

Evaluasi Screen: Displays total score (trigger a celebration Lottie if perfect). Shows a ListView of incorrectly answered questions and their explanations using rekapEvaluasi. Includes a Reset button to reset all state to default and return to the menu.

4. Dummy Data Injection
Inject the following dummy data into lib/core/constants.dart or directly into the model initializers so the prototype can be tested immediately:

Materi Pages (3 Pages):

Pengertian: Asam adalah zat yang menghasilkan ion hidrogen (H+) dalam air, sedangkan Basa menghasilkan ion hidroksida (OH-). Teori ini pertama kali dikemukakan oleh Svante Arrhenius.

Sifat-sifat: Larutan asam memiliki rentang pH di bawah 7, rasanya masam, dan bersifat korosif. Sebaliknya, larutan basa memiliki pH di atas 7, terasa licin seperti sabun, dan bersifat kaustik.

Indikator: Kertas lakmus adalah indikator paling umum. Asam akan mengubah lakmus biru menjadi merah. Basa akan mengubah lakmus merah menjadi biru.

Quiz Questions (3 Questions):

Question: Kertas lakmus biru jika dimasukkan ke dalam larutan asam akan berubah menjadi warna apa?
Options: A. Tetap Biru, B. Merah, C. Kuning, D. Hijau
Correct Index: 1 (B. Merah)
Explanation: Larutan asam memiliki sifat mengubah kertas lakmus biru menjadi merah.

Question: Berapakah rentang derajat keasaman (pH) untuk larutan yang bersifat basa?
Options: A. pH kurang dari 7, B. pH sama dengan 7, C. pH lebih dari 7, D. pH sama dengan 0
Correct Index: 2 (C. pH lebih dari 7)
Explanation: Skala pH basa selalu berada di atas 7 hingga 14. Skala 7 adalah netral (air), dan di bawah 7 adalah asam.

Question: Menurut teori Arrhenius, zat yang melepaskan ion OH- ketika dilarutkan dalam air disebut...
Options: A. Asam, B. Garam, C. Larutan Netral, D. Basa
Correct Index: 3 (D. Basa)
Explanation: Teori Arrhenius secara spesifik mendefinisikan basa sebagai pelepas ion hidroksida (OH-) dalam larutan berair.