import 'dart:async';
import 'package:flutter/material.dart';
import 'login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller setup (Yeh 2.5 seconds tak animation chalayega)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward(); // Animation shuru karein

    // Exact 3 Seconds ka timer - jiske baad automatic Login Screen khulegi
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF0F1113); // Carbon Theme
    final Color accentBlue = const Color(0xFF00D2FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated App Icon (Matching Home/Login template)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: accentBlue.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Icon(Icons.grid_view_rounded, color: accentBlue, size: 60),
                ),
                const SizedBox(height: 28),
                
                // Animated Brand Name
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 2),
                    children: [
                      const TextSpan(text: "UTI"),
                      TextSpan(text: "LIXA", style: TextStyle(fontWeight: FontWeight.bold, color: accentBlue)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'GLOBAL UTILITY FRAMEWORK',
                  style: TextStyle(
                    fontSize: 12, 
                    color: Colors.white.withOpacity(0.3), 
                    fontWeight: FontWeight.w600, 
                    letterSpacing: 2
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