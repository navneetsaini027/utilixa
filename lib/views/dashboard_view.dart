import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'quick_split_view.dart';
import 'profile_tab_view.dart'; // Seamless binding injection

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  List<Widget> _getPages() {
    return [
      _buildHomeScreenContent(), 
      _buildPlaceholderPage('Analytics Hub Monitoring', Icons.pie_chart_rounded), 
      _buildPlaceholderPage('Control Settings Matrix', Icons.settings_suggest_rounded), 
      const ProfileTabView(), // Mapped directly to real live data view layer 🚀
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181B22),
      body: SafeArea(
        child: _getPages()[_selectedIndex],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: const Color(0xFF181B22)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF181B22),
          selectedItemColor: const Color(0xFF5CE1E6),
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 28), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline, size: 28), label: 'Analytics'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined, size: 28), label: 'Settings'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 28), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeScreenContent() {
    final String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Hey, ',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w400, color: Colors.white),
                      children: [
                        TextSpan(
                          text: _currentUser?.displayName ?? 'Navneet Saini!',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF5CE1E6)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
              // Real Logged-in Google user display avatar module sync
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF5CE1E6), width: 1.5),
                ),
                child: ClipOval(
                  child: _currentUser?.photoURL != null
                      ? Image.network(_currentUser!.photoURL!, fit: BoxFit.cover)
                      : const Icon(Icons.account_circle, size: 48, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              _buildFeatureCard(
                icon: Icons.flash_on,
                title: 'Quick Split',
                subtitle: 'Instant Bill Split',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QuickSplitView()));
                },
              ),
              _buildFeatureCard(icon: Icons.group, title: 'Active Groups', subtitle: 'Real-time sync groups', onTap: () {}),
              _buildFeatureCard(icon: Icons.handshake, title: 'Settle Requests', subtitle: 'No pending alerts', onTap: () {}),
              _buildFeatureCard(icon: Icons.bar_chart, title: 'Total Expenses', subtitle: 'Track logs & history', onTap: () {}),
              _buildFeatureCard(icon: Icons.notifications_active, title: 'Recent Activities', subtitle: 'Track split logs', onTap: () {}),
              _buildFeatureCard(icon: Icons.history, title: 'Settle Up History', subtitle: 'View past clearings', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: const Color(0xFF21252E), borderRadius: BorderRadius.circular(24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 28, color: const Color(0xFF5CE1E6)),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Container(
      color: const Color(0xFF181B22),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: const Color(0xFF5CE1E6)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}