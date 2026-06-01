import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/materi_screen.dart';
import 'screens/latihan_screen.dart';
import 'screens/evaluasi_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChemistryApp());
}

/// The root application widget. Wires up state management via ChangeNotifierProvider
/// and establishes a dark, fluid global visual theme and routing tables.
class ChemistryApp extends StatelessWidget {
  const ChemistryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'Kimia Air - Asam Basa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.navyEnd,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentNeon,
            secondary: AppColors.accentNeon,
            surface: AppColors.navyStart,
            error: AppColors.incorrectCoral,
          ),
          fontFamily: 'Outfit',
        ),
        // Router Configuration
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/menu': (context) => const MenuScreen(),
          '/materi': (context) => const MateriScreen(),
          '/latihan': (context) => const LatihanScreen(),
          '/evaluasi': (context) => const EvaluasiScreen(),
        },
      ),
    );
  }
}
