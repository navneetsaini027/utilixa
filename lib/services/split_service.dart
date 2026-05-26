import '../models/split_models.dart';

class SplitService {
  // Static state data (Bina UI touch kiye background data sync ke liye)
  static List<SplitGroup> activeGroups = [
    SplitGroup(
      id: '1',
      name: 'Roommates',
      members: ['You', 'Rahul', 'Sneha'],
      expenses: [],
    ),
    SplitGroup(
      id: '2',
      name: 'Trip to Mountains',
      members: ['You', 'Pakhu', 'Chachi'],
      expenses: [],
    ),
  ];

  // Naya group add karne ke liye function
  static void addGroup(String name, List<String> members) {
    activeGroups.add(
      SplitGroup(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        members: ['You', ...members],
        expenses: [],
      ),
    );
  }

  // Naya kharcha add karne ke liye function
  static void addExpense(String groupId, String description, double amount, String paidBy) {
    final groupIndex = activeGroups.indexWhere((g) => g.id == groupId);
    if (groupIndex != -1) {
      final group = activeGroups[groupIndex];
      final splitAmount = amount / group.members.length;
      
      Map<String, double> splitDetails = {};
      for (var member in group.members) {
        splitDetails[member] = splitAmount;
      }

      group.expenses.add(
        SplitExpense(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          description: description,
          amount: amount,
          paidBy: paidBy,
          dateTime: DateTime.now(),
          splitDetails: splitDetails,
        ),
      );
    }
  }

  // Settle Up balances calculate karne ke liye main logic matrix
  static Map<String, double> calculateBalances(SplitGroup group) {
    Map<String, double> balances = {};
    
    // Sabhi members ka balance starting me 0.0 set karein
    for (var member in group.members) {
      balances[member] = 0.0;
    }

    // Har expense ko process karke final udhaar nikalna
    for (var expense in group.expenses) {
      String payer = expense.paidBy;
      double totalAmount = expense.amount;
      double share = totalAmount / group.members.length;

      for (var member in group.members) {
        if (member == payer) {
          balances[member] = balances[member]! + (totalAmount - share);
        } else {
          balances[member] = balances[member]! - share;
        }
      }
    }
    return balances;
  }
}