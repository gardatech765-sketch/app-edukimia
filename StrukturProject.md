lib/
│
├── main.dart
│
├── core/
│   ├── constants.dart
│   └── logger_service.dart
│
├── models/
│   ├── question_model.dart
│   └── recap_model.dart
│
├── providers/
│   └── app_state.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── menu_screen.dart
│   ├── materi_screen.dart
│   ├── latihan_screen.dart
│   └── evaluasi_screen.dart
│
└── widgets/
    ├── glass_button.dart
    └── audio_control.dart

assets/
├── animations/
│   ├── splash.json
│   ├── bubbles.json
│   └── celebration.json
│
└── audio/
    ├── background.mp3
    ├── tap.wav
    ├── correct.wav
    └── incorrect.wav
File Functions & Responsibilities:

lib/main.dart
Entry point of the application. Initializes MaterialApp, registers MultiProvider for state management, sets the global theme using colors from constants.dart, and defines the initial route to splash_screen.dart.

lib/core/constants.dart
Centralized configuration file. Contains static classes for AppColors (hex codes for Navy, Cyan, Teal, Coral), AppAssets (string paths to Lottie and Audio files), and dummy data arrays for the material text and quiz questions.

lib/core/logger_service.dart
Initializes the global Logger instance from the logger package to be imported and used across all files for structured debugging (info, debug, error logs).

lib/models/question_model.dart
Strongly-typed data class representing a single quiz question. Contains properties: String questionText, List<String> options, int correctIndex, and String explanation.

lib/models/recap_model.dart
Strongly-typed data class for evaluation. Contains the QuestionModel and int selectedWrongIndex to show what the user answered incorrectly.

lib/providers/app_state.dart
The ChangeNotifier class handling all business logic. Stores isMateriSelesai, isSoalSelesai, skorTotal, and List<RecapModel> rekapEvaluasi. Includes methods to calculate scores, add recaps, and reset the state. Integrates logger_service.dart to log every state mutation.

lib/screens/splash_screen.dart
Stateless widget displaying a full-screen gradient and the splash.json Lottie animation. Uses Future.delayed (3 seconds) to navigate to menu_screen.dart using pushReplacement.

lib/screens/menu_screen.dart
The main navigation hub. Reads AppState via Provider to determine the locked/unlocked visual state of the three navigation buttons. Contains the bubbles.json background animation.

lib/screens/materi_screen.dart
Displays the chemistry material using a PageView. The last page renders a button that calls a method in AppState to unlock the quiz, then pops the context.

lib/screens/latihan_screen.dart
Stateful widget handling the quiz logic. Renders options using glass_button.dart. Triggers HapticFeedback and audio effects on tap. Implements a 2-second delay using Future.delayed before loading the next question.

lib/screens/evaluasi_screen.dart
Reads AppState to display the final score and renders a ListView.builder for the rekapEvaluasi list. Provides a button to reset the state and return to the root menu.

lib/widgets/glass_button.dart
Reusable custom widget implementing the glassmorphism effect (using BackdropFilter, opacity, and borders) to keep screen files clean.

lib/widgets/audio_control.dart
A floating action button component that manages the audioplayers instance to toggle background music on and off.