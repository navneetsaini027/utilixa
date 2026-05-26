import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String? _validationMessage;
  bool _isSuccess = false;

  final Color backgroundColor = const Color(0xFF0F1113);
  final Color accentBlue = const Color(0xFF00D2FF);

  void _handleSignup() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    // Basic structural validation check
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPass.isEmpty) {
      setState(() {
        _isSuccess = false;
        _validationMessage = 'All parameter fields are mandatory.';
      });
      return;
    }

    if (password != confirmPass) {
      setState(() {
        _isSuccess = false;
        _validationMessage = 'Passwords do not match.';
      });
      return;
    }

    // Mock confirmation behavior for local interface pipeline
    setState(() {
      _isSuccess = true;
      _validationMessage = 'Account created successfully! You can now log in.';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 1),
                    children: [
                      const TextSpan(text: "CREATE "),
                      TextSpan(text: "ACCOUNT", style: TextStyle(fontWeight: FontWeight.bold, color: accentBlue)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Join the global utility engine',
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 35),

                if (_validationMessage != null) ...[
                  Text(
                    _validationMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isSuccess ? Colors.greenAccent : Colors.redAccent, 
                      fontSize: 13, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Registration Input Matrix Configured with Dashboard architecture styling tokens
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
                      _buildSignupField(controller: _nameController, hint: 'Full Name', icon: Icons.badge_outlined),
                      const SizedBox(height: 16),
                      _buildSignupField(controller: _emailController, hint: 'Email Address', icon: Icons.mail_outline_rounded, inputType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildSignupField(controller: _phoneController, hint: 'Phone Number', icon: Icons.phone_android_rounded, inputType: TextInputType.phone),
                      const SizedBox(height: 16),
                      _buildSignupField(controller: _passwordController, hint: 'Password', icon: Icons.lock_outline_rounded, isObscure: true),
                      const SizedBox(height: 16),
                      _buildSignupField(controller: _confirmPasswordController, hint: 'Confirm Password', icon: Icons.lock_clock_outlined, isObscure: true),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // Register Action Trigger Button
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
                    onPressed: _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentBlue,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      'REGISTER NOW',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Back navigation link back down to base login terminal
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(color: accentBlue, fontWeight: FontWeight.bold),
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

  Widget _buildSignupField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isObscure = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4), size: 20),
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
    );
  }
}