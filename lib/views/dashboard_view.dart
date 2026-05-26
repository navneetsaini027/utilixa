import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../services/split_service.dart';
import 'group_details_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  int _currentTab = 0;

  String _userName = 'Navneet Saini';
  String _userEmail = 'navneet@gmail.com';
  String? _userPhotoUrl;
  String _currentDate = '';

  @override
  void initState() {
    super.initState();
    _currentDate = DateFormat('EEEE, MMM dd, yyyy').format(DateTime.now());
    _syncGoogleAccount();
  }

  // Pure Null-Safe execution using conditional member access directly
  void _syncGoogleAccount() async {
    GoogleSignInAccount? currentAccount = _googleSignIn.currentUser;
    if (currentAccount == null) {
      currentAccount = await _googleSignIn.signInSilently();
    }
    
    if (currentAccount != null) {
      setState(() {
        _userName = currentAccount?.displayName ?? 'Navneet Saini';
        _userEmail = currentAccount?.email ?? 'navneet@gmail.com';
        _userPhotoUrl = currentAccount?.photoUrl;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      await _googleSignIn.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (error) {
      print("Logout error: $error");
    }
  }

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    final membersController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF22252D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Create Split Group', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Group Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF6FE9CD))),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: membersController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Members (Comma separated)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF6FE9CD))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6FE9CD),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                List<String> mems = membersController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                setState(() {
                  SplitService.addGroup(nameController.text.trim(), mems);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Create', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showQuickSplitDialog() {
    final amountController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF22252D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Quick Split Bill', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Bill Description (e.g., Dinner)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6FE9CD)),
            onPressed: () {
              final amt = double.tryParse(amountController.text) ?? 0;
              final desc = descController.text.trim();
              if (amt > 0 && desc.isNotEmpty) {
                Navigator.pop(context);
                _showGroupSelectionForQuickSplit(desc, amt);
              }
            },
            child: const Text('Next', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showGroupSelectionForQuickSplit(String description, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF22252D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Select Target Group', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: SplitService.activeGroups.length,
            itemBuilder: (context, index) {
              final group = SplitService.activeGroups[index];
              return ListTile(
                leading: const Icon(Icons.group_rounded, color: Color(0xFF6FE9CD)),
                title: Text(group.name, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    SplitService.addExpense(group.id, description, amount, 'You');
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('₹$amount added to ${group.name} successfully!'),
                      backgroundColor: const Color(0xFF1C1F26),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181B22),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Hey, ',
                          style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: '$_userName!',
                              style: const TextStyle(color: Color(0xFF6FE9CD), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(_currentDate, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF22252D),
                    backgroundImage: _userPhotoUrl != null ? NetworkImage(_userPhotoUrl!) : null,
                    child: _userPhotoUrl == null ? Text(_userName[0].toUpperCase(), style: const TextStyle(color: Color(0xFF6FE9CD), fontWeight: FontWeight.bold)) : null,
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  _buildHomeTab(),
                  _buildSplitwiseLedgerTab(),
                  _buildSettingsTab(),
                  _buildAccountTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1F26),
          border: Border(top: BorderSide(color: Color(0xFF2C303B), width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavIcon(Icons.home_filled, 0),
            _buildBottomNavIcon(Icons.pie_chart_rounded, 1),
            _buildBottomNavIcon(Icons.settings_rounded, 2),
            _buildBottomNavIcon(Icons.person_rounded, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFB9F3E8), Color(0xFF76EDD3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_cloudy_rounded, color: Colors.white, size: 32),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Sunny Intervals', style: TextStyle(color: Color(0xFF1E3A34), fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Punjab, India', style: TextStyle(color: Color(0xFF3B6B60), fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const Text('32°', style: TextStyle(color: Color(0xFF1E3A34), fontSize: 36, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildWeatherMetrics(),
              )
            ],
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildSplitFeatureCard('Quick Split', 'Instant Bill Split', Icons.bolt_rounded, () => _showQuickSplitDialog()),
            _buildSplitFeatureCard('Active Groups', '${SplitService.activeGroups.length} Groups Live', Icons.group_rounded, () => setState(() => _currentTab = 1)),
            _buildSplitFeatureCard('Settle Requests', 'No pending alerts', Icons.handshake_rounded, () => setState(() => _currentTab = 1)),
            _buildSplitFeatureCard('Total Expenses', 'Track logs & history', Icons.analytics_rounded, () => setState(() => _currentTab = 2)),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSplitwiseLedgerTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Split Summary (G-Pay Style)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF6FE9CD), size: 28),
                onPressed: _showCreateGroupDialog,
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: SplitService.activeGroups.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final group = SplitService.activeGroups[index];
              final totalBalances = SplitService.calculateBalances(group);
              double userNet = totalBalances['You'] ?? 0.0;

              return Card(
                color: const Color(0xFF22252D),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF181B22),
                    child: Text(group.name[0].toUpperCase(), style: const TextStyle(color: Color(0xFF6FE9CD), fontWeight: FontWeight.bold)),
                  ),
                  title: Text(group.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text('Members: ${group.members.join(", ")}', style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        userNet >= 0 ? '+₹${userNet.toStringAsFixed(0)}' : '-₹${userNet.abs().toStringAsFixed(0)}',
                        style: TextStyle(
                          color: userNet >= 0 ? const Color(0xFF6FE9CD) : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        userNet >= 0 ? 'You get back' : 'You owe',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GroupDetailsView(group: group)),
                    ).then((_) => setState(() {}));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    final settingsItems = [
      {'title': 'Theme Settings', 'sub': 'Dark Mode & Custom Accents', 'icon': Icons.palette_rounded},
      {'title': 'Split History', 'sub': 'Review all past settlements', 'icon': Icons.history_toggle_off_rounded},
      {'title': 'Group Management', 'sub': 'Add, edit, or archive members', 'icon': Icons.group_add_rounded},
      {'title': 'Default Currency', 'sn': 'INR (₹) Settings', 'icon': Icons.currency_rupee_rounded},
      {'title': 'Payment Reminders', 'sub': 'Auto ping pending debts via UPI', 'icon': Icons.notifications_active_rounded},
    ];

    return ListView.builder(
      itemCount: settingsItems.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemBuilder: (context, index) {
        final item = settingsItems[index];
        return Card(
          color: const Color(0xFF22252D),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            leading: Icon(item['icon'] as IconData, color: const Color(0xFF6FE9CD)),
            title: Text(item['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text((item['sub'] ?? item['sn']) as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildAccountTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 55,
            backgroundColor: const Color(0xFF22252D),
            backgroundImage: _userPhotoUrl != null ? NetworkImage(_userPhotoUrl!) : null,
            child: _userPhotoUrl == null ? Text(_userName[0].toUpperCase(), style: const TextStyle(color: Color(0xFF6FE9CD), fontSize: 36, fontWeight: FontWeight.bold)) : null,
          ),
          const SizedBox(height: 16),
          Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(_userEmail, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 30),
          const Divider(color: Color(0xFF2C303B)),
          const Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.15),
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent, width: 1),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout Google Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<Widget> _buildWeatherMetrics() {
    final metrics = [
      {'val': '34°', 'label': 'Sensible'},
      {'val': '58%', 'label': 'Humidity'},
      {'val': '4.1', 'label': 'Wind m/s'},
      {'val': '1006hpa', 'label': 'Pressure'},
    ];
    return metrics.map((m) {
      return Column(
        children: [
          Text(m['val']!, style: const TextStyle(color: Color(0xFF1E3A34), fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 2),
          Text(m['label']!, style: const TextStyle(color: Color(0xFF4C7E73), fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      );
    }).toList();
  }

  Widget _buildSplitFeatureCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF22252D),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: const Color(0xFF6FE9CD), size: 28),
                const Icon(Icons.arrow_forward_rounded, color: Colors.grey, size: 16),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavIcon(IconData icon, int tabIndex) {
    bool isSelected = _currentTab == tabIndex;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = tabIndex),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF6FE9CD) : Colors.grey.shade600, size: 28),
          if (isSelected) ...[
            const SizedBox(height: 4),
            Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF6FE9CD), shape: BoxShape.circle))
          ]
        ],
      ),
    );
  }
}