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
      appBar: AppBar(
        title: Text('Add Expense in ${widget.group.name}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description (e.g., Dinner, Petrol)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Amount (₹)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedPayer,
              decoration: const InputDecoration(
                labelText: 'Paid By',
                border: OutlineInputBorder(),
              ),
              items: widget.group.members.map((String member) {
                return DropdownMenuItem<String>(
                  value: member,
                  child: Text(member),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedPayer = value);
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                final desc = _descController.text.trim();
                final amt = double.tryParse(_amountController.text) ?? 0.0;
                
                if (desc.isNotEmpty && amt > 0) {
                  SplitService.addExpense(widget.group.id, desc, amt, _selectedPayer);
                  Navigator.pop(context, true); // Refresh flag return
                }
              },
              child: const Text('Save Expense & Split Equally', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}