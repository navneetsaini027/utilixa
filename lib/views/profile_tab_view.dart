import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_view.dart'; // Handles immediate verification route block redirect

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Clear secure sessions simultaneously from device core cache modules
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;
      
      // Forces stack redirection back to clean sign-in configuration wall
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginView()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session clearance error code block: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dynamic Verified User Image Frame Avatar Matrix
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF5CE1E6), width: 2.5),
              ),
              child: ClipOval(
                child: user?.photoURL != null
                    ? Image.network(user!.photoURL!, fit: BoxFit.cover)
                    : const Icon(Icons.account_circle, size: 90, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            user?.displayName ?? 'Anonymous User',
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            user?.email ?? 'No synchronized Google active account data linked.',
            style: const TextStyle(color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(height: 50),
          
          // REAL WORKING LOGOUT BUTTON CONFIGURATION 👇
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE06C75).withOpacity(0.2),
                side: const BorderSide(color: Color(0xFFE06C75), width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.power_settings_new_rounded, color: Color(0xFFE06C75)),
              label: const Text('Disconnect Account (Logout)', style: TextStyle(color: Color(0xFFE06C75), fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}