import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuickSplitView extends StatefulWidget {
  const QuickSplitView({super.key});

  @override
  State<QuickSplitView> createState() => _QuickSplitViewState();
}

class _QuickSplitViewState extends State<QuickSplitView> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  int _currentStep = 1; // Stage Controller: 1 = Bill Data, 2 = Group Selection
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _handleNextStage() {
    if (_descController.text.trim().isEmpty || _amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all mandatory payment parameters.')),
      );
      return;
    }
    setState(() {
      _currentStep = 2; // Move to dynamic group picking stage
    });
  }

  Future<void> _finalizeTransaction(String groupId, String groupName) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      // Direct integration mapping directly inside Firebase Collections database Matrix
      await _firestore.collection('transactions').add({
        'description': _descController.text.trim(),
        'amount': double.tryParse(_amountController.text.trim()) ?? 0.0,
        'groupId': groupId,
        'groupName': groupName,
        'createdBy': currentUser.email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bill added successfully to group: $groupName')),
      );
      Navigator.pop(context); // Safe dismiss flow back to home grid
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase write failure: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181B22),
      appBar: AppBar(
        title: Text(_currentStep == 1 ? 'Quick Split Parameters' : 'Assign to Real Group'),
        backgroundColor: const Color(0xFF21252E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            if (_currentStep == 2) {
              setState(() => _currentStep = 1);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _currentStep == 1 ? _buildBillDataStage() : _buildGroupSelectionStage(),
      ),
    );
  }

  Widget _buildBillDataStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bill Description', style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: _descController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF21252E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            hintText: 'e.g., Dinner Petrol Trip',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Total Amount (₹)', style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF21252E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            hintText: '0.00',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5CE1E6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: _handleNextStage,
            child: const Text('Next (Select Group)', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupSelectionStage() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('groups').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5CE1E6))));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No active groups found in Firestore DB.', style: TextStyle(color: Colors.white)));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var group = snapshot.data!.docs[index];
            String groupName = group['name'] ?? 'Unnamed Group';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: const Color(0xFF21252E), borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title: Text(groupName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text('Members: ${(group['members'] as List).length}', style: const TextStyle(color: Colors.grey)),
                trailing: const Icon(Icons.add_box_rounded, color: Color(0xFF5CE1E6)),
                onTap: () => _finalizeTransaction(group.id, groupName),
              ),
            );
          },
        );
      },
    );
  }
}