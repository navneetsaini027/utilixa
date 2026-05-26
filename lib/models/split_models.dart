import 'package:flutter/material.dart';

// Splitwise Group Model
class SplitGroup {
  final String id;
  final String name;
  final List<String> members;
  final List<SplitExpense> expenses;

  SplitGroup({
    required this.id,
    required this.name,
    required this.members,
    required this.expenses,
  });
}

// Splitwise Expense Model
class SplitExpense {
  final String id;
  final String description;
  final double amount;
  final String paidBy; // Member name or ID who paid
  final DateTime dateTime;
  final Map<String, double> splitDetails; // Member -> Owed Amount

  SplitExpense({
    required this.id,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.dateTime,
    required this.splitDetails,
  });
}