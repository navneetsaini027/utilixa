import 'package:flutter/material.dart';
import '../services/split_service.dart';
import '../models/split_models.dart';

class AddExpenseView extends StatefulWidget {
  final SplitGroup group;
  const AddExpenseView({super.key, required this.group});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedPayer = 'You';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181B22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1F26),
        foregroundColor: Colors.white,
        title: const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF2C303B))),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF6FE9CD))),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Total Amount (₹)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF2C303B))),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF6FE9CD))),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF22252D),
              value: _selectedPayer,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Paid By',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF2C303B))),
              ),
              items: widget.group.members.map((String member) {
                return DropdownMenuItem<String>(
                  value: member,
                  child: Text(member, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedPayer = value);
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FE9CD),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                final desc = _descController.text.trim();
                final amt = double.tryParse(_amountController.text) ?? 0.0;
                if (desc.isNotEmpty && amt > 0) {
                  SplitService.addExpense(widget.group.id, desc, amt, _selectedPayer);
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Save Expense', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}