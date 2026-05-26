import 'package:flutter/material.dart';
import '../models/split_models.dart';
import '../services/split_service.dart';
import 'add_expense_view.dart';

class GroupDetailsView extends StatefulWidget {
  final SplitGroup group;
  const GroupDetailsView({super.key, required this.group});

  @override
  State<GroupDetailsView> createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView> {
  late Map<String, double> balances;

  @override
  void initState() {
    super.initState();
    balances = SplitService.calculateBalances(widget.group);
  }

  void _refreshBalances() {
    setState(() {
      balances = SplitService.calculateBalances(widget.group);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181B22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1F26),
        foregroundColor: Colors.white,
        title: Text(widget.group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF22252D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Group Balance Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const Divider(color: Color(0xFF2C303B), height: 20),
                ...balances.entries.map((entry) {
                  final val = entry.value;
                  final isOwed = val >= 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontSize: 15, color: Colors.white70)),
                        Text(
                          isOwed ? 'Gets back ₹${val.toStringAsFixed(0)}' : 'Owes ₹${val.abs().toStringAsFixed(0)}',
                          style: TextStyle(
                            color: isOwed ? const Color(0xFF6FE9CD) : Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Expenses History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          Expanded(
            child: widget.group.expenses.isEmpty
                ? const Center(child: Text('No expenses added yet!', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: widget.group.expenses.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      final exp = widget.group.expenses[index];
                      return Card(
                        color: const Color(0xFF22252D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const Icon(Icons.receipt_long_rounded, color: Color(0xFF6FE9CD)),
                          title: Text(exp.description, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: Text('Paid by ${exp.paidBy}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          trailing: Text('₹${exp.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6FE9CD),
        onPressed: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseView(group: widget.group)),
          );
          if (updated == true) _refreshBalances();
        },
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('Add Expense', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}