import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'student_dashboard.dart';
import 'parent_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Timer(
      const Duration(seconds: 3),
      _navigateAfterSplash,
    );
  }

  Future<void> _navigateAfterSplash() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final role = doc.get("role") ?? "student";
          if (role == "parent") {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ParentDashboard()),
              );
            }
          } else {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const StudentDashboard()),
              );
            }
          }
          return;
        }
      } catch (e) {
        debugPrint("Error checking user role: $e");
      }
    }

    // Check SharedPreferences for last intro date
    final prefs = await SharedPreferences.getInstance();
    final String? lastIntroDate = prefs.getString('last_intro_date');
    
    final DateTime now = DateTime.now();
    final String today = '${now.year}-${now.month}-${now.day}';

    if (lastIntroDate != today) {
      // Haven't shown intro today. Update date and show intro.
      await prefs.setString('last_intro_date', today);
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, "/intro");
      }
    } else {
      // Already shown today. Skip to login.
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B0F14),
              Color(0xFF0D0D0D),
              Color(0xFF0B0F14),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                child: child,
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFD9FF3F,
                        ).withOpacity(0.25),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 105,
                      height: 105,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF151A22,
                        ),
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                        child: Image.asset(
                          "assets/images/logo3.png",
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.fitness_center,
                            color: Color(
                              0xFFD9FF3F,
                            ),
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  "FITMIND",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "TRACK • TRAIN • TRANSFORM",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 50),
                const SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: Color(0xFF0D0D0D),
                    valueColor: AlwaysStoppedAnimation(
                      Color(0xFFD9FF3F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
