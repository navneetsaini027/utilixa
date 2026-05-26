import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dashboard_view.dart';
import 'signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  String? _errorMessage;
  bool _isLoading = false;

  final Color backgroundColor = const Color(0xFF0F1113);
  final Color accentBlue = const Color(0xFF00D2FF);

  // Class-level clean instantiation fallback for target compilers
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == 'admin@utilixa.com' && password == 'admin123') {
      setState(() { _errorMessage = null; });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid credentials. Hint: admin@utilixa.com / admin123';
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Accessing standard sign-in channel mapping directly
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardView()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Google Authentication failed. Please try again.';
      });
      print('Google Sign-In Error: $error');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Icon(Icons.grid_view_rounded, color: accentBlue, size: 45),
                ),
                const SizedBox(height: 24),
                
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 1),
                    children: [
                      const TextSpan(text: "UTI"),
                      TextSpan(text: "LIXA", style: TextStyle(fontWeight: FontWeight.bold, color: accentBlue)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'GLOBAL UTILITY FRAMEWORK',
                  style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w600, letterSpacing: 1.5),
                ),
                const SizedBox(height: 45),

                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                ],

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "SIGN IN", 
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'User Name',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
                          prefixIcon: Icon(Icons.person_outline_rounded, color: Colors.white.withOpacity(0.4), size: 20),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.02),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: accentBlue.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
                          prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.white.withOpacity(0.4), size: 20),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.02),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: accentBlue.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Remember session',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                          ),
                          Transform.scale(
                            scale: 0.75,
                            child: Switch(
                              value: _rememberMe,
                              activeColor: accentBlue,
                              onChanged: (val) {
                                setState(() { _rememberMe = val; });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                _isLoading 
                ? const CircularProgressIndicator(color: Color(0xFF00D2FF))
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: accentBlue.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 4))
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentBlue,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text(
                            'LOG IN',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withOpacity(0.04),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: OutlinedButton(
                          onPressed: _handleGoogleSignIn,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            foregroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.g_mobiledata_rounded, size: 30, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                'CONTINUE WITH GOOGLE',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.9), letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 28),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupView()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                      children: [
                        const TextSpan(text: "New to the platform? "),
                        TextSpan(
                          text: "Sign Up Here",
                          style: TextStyle(color: accentBlue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                      ],
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