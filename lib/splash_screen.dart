import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
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
          () {
        Navigator.pushReplacementNamed(
          context,
          "/intro",
        );
      },
    );
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
              mainAxisAlignment:
              MainAxisAlignment.center,
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
                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                        child: Image.asset(
                          "assets/images/logo3.png",
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) =>
                          const Icon(
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
                    fontWeight:
                    FontWeight.w900,
                    letterSpacing: 8,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "TRACK • TRAIN • TRANSFORM",
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(0.6),
                    fontSize: 12,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 50),

                const SizedBox(
                  width: 150,
                  child:
                  LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor:
                    Color(0xFF0D0D0D),
                    valueColor:
                    AlwaysStoppedAnimation(
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