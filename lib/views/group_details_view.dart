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
      appBar: AppBar(
        title: Text(widget.group.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Group Balance Status:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                ...balances.entries.map((entry) {
                  final val = entry.value;
                  final isOwed = val >= 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontSize: 15)),
                        Text(
                          isOwed ? 'Gets back ₹${val.toStringAsFixed(2)}' : 'Owes ₹${val.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isOwed ? Colors.green : Colors.red,
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
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(alignment: Alignment.centerLeft, child: Text('Expenses History:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ),

          Expanded(
            child: widget.group.expenses.isEmpty
                ? const Center(child: Text('No expenses added yet!'))
                : ListView.builder(
                    itemCount: widget.group.expenses.length,
                    itemBuilder: (context, index) {
                      final exp = widget.group.expenses[index];
                      return ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text(exp.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Paid by ${exp.paidBy} on ${exp.dateTime.hour}:${exp.dateTime.minute}'),
                        trailing: Text('₹${exp.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseView(group: widget.group)),
          );
          if (updated == true) _refreshBalances();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}