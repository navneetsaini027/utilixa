import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Clock aur Date ke liye
import 'package:provider/provider.dart';
import '../viewmodels/app_state_viewmodel.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0; // Bottom nav index

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Real-time Date format
    final String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF0F1113), // Exact Deep Carbon Background from Image
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // 1. HEADER SECTION (Greeting & Profile)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 24, color: Colors.white),
                          children: [
                            TextSpan(text: "Hey, "),
                            TextSpan(text: "User!", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00D2FF))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                      ),
                    ],
                  ),
                  // Top Right Menu Grid Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 26),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 2. FEATURED SUMMARY CARD (Replaces Weather Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Cloud Syncing", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text("Secure, Global Framework", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                          ],
                        ),
                        const Text("28°", style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w300)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Mini Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMiniStat("98%", "Accuracy", Icons.shutter_speed_rounded, Colors.greenAccent),
                        _buildMiniStat("65%", "Storage", Icons.cloud_done_rounded, Colors.blueAccent),
                        _buildMiniStat("100%", "Security", Icons.security_rounded, Colors.orangeAccent),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 3. HORIZONTAL TABS (All Tools, Finance, etc.)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTab("All Tools", true),
                    _buildTab("Financial", false),
                    _buildTab("Quick Utilities", false),
                    _buildTab("Analytics", false),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 4. SMART FEATURE GRID (Device Style Cards)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildSmartCard(
                    title: "Group Expense",
                    status: "4 Active Splits",
                    icon: Icons.group_add_rounded,
                    color: Colors.tealAccent,
                    isOn: true,
                  ),
                  _buildSmartCard(
                    title: "Ledger Book",
                    status: "2 Pending",
                    icon: Icons.account_balance_wallet_rounded,
                    color: Colors.blueAccent,
                    isOn: false,
                  ),
                  _buildSmartCard(
                    title: "Quick Math",
                    status: "Calculator",
                    icon: Icons.calculate_rounded,
                    color: Colors.orangeAccent,
                    isOn: true,
                  ),
                  _buildSmartCard(
                    title: "Analytics",
                    status: "Offline",
                    icon: Icons.bar_chart_rounded,
                    color: Colors.purpleAccent,
                    isOn: false,
                  ),
                ],
              ),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
      
      // 5. MODERN FLOATING BOTTOM NAVIGATION
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Mini Stat Builder for the Top Card
  Widget _buildMiniStat(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
      ],
    );
  }

  // Tab Builder
  Widget _buildTab(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF00D2FF) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Smart Feature Card Builder (The "AC/TV" style cards)
  Widget _buildSmartCard({required String title, required String status, required IconData icon, required Color color, required bool isOn}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOn ? color.withOpacity(0.1) : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isOn ? color.withOpacity(0.3) : Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: isOn ? color : Colors.white38, size: 32),
              Icon(Icons.wifi, color: isOn ? color : Colors.white12, size: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(status, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isOn ? "ON" : "OFF", style: TextStyle(color: isOn ? Colors.white : Colors.white24, fontWeight: FontWeight.bold, fontSize: 12)),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: isOn,
                  activeColor: color,
                  onChanged: (val) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Modern Bottom Navigation Bar
  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C1E),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_filled, 0),
          _navIcon(Icons.history_rounded, 1),
          _navIcon(Icons.settings_suggest_rounded, 2),
          _navIcon(Icons.person_outline_rounded, 3),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Icon(icon, color: isSelected ? const Color(0xFF00D2FF) : Colors.white24, size: 28),
    );
  }
}