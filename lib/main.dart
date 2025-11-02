import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';

final ThemeProvider themeProvider = ThemeProvider();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await themeProvider.loadTheme();
  runApp(const VoiceNotesApp());
}

class VoiceNotesApp extends StatelessWidget {
  const VoiceNotesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'Voice Notes',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            primaryColor: Colors.lightBlue,
            scaffoldBackgroundColor: Colors.white,
            brightness: Brightness.light,
            useMaterial3: true,
            colorScheme: ColorScheme.light(
              primary: Colors.lightBlue,
              secondary: Colors.lightBlue.shade300,
              surface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.lightBlue,
            primaryColor: Colors.lightBlue,
            scaffoldBackgroundColor: const Color(0xFF121212),
            brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: ColorScheme.dark(
              primary: Colors.lightBlue,
              secondary: Colors.lightBlue.shade300,
              surface: const Color(0xFF1E1E1E),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF1E1E1E),
              foregroundColor: Colors.lightBlue.shade100,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
