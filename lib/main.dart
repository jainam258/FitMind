import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'login_screen.dart';
import 'student_dashboard.dart';
import 'parent_dashboard.dart';
import 'meal_log.dart';
import 'student_form.dart';
import 'intro_screen.dart';
import 'meal_plan_screen.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMind',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD9FF3F),
        scaffoldBackgroundColor: const Color(0xFF0D0D0E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD9FF3F),
          secondary: Color(0xFFB388FF),
          surface: Color(0xFF161B22),
          background: Color(0xFF0D0D0E),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/intro': (context) => const IntroScreen(),
        '/login': (context) => const LoginScreen(),
        '/student_dashboard': (context) => const StudentDashboard(),
        '/parent_dashboard': (context) => const ParentDashboard(),
        '/meal_log': (context) => const MealLog(),
        '/meal_plan_screen': (context) => const MealPlanScreen(),
        '/student_form': (context) => const StudentForm(),
      },
    );
  }
}

