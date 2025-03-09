import 'package:flutter/material.dart';

class ExpenseProvider extends ChangeNotifier {
  bool _isIncome = true;
  bool get isIncome => _isIncome;
  int totalExpense = 0;
  int totalIncome = 0;
  int currentBalance = 0;

  void toggleIsIncome(bool value) {
    _isIncome = value;
    notifyListeners();
  }

  void updateTotals(
      {required int expense, required int balance, required int income}) {
    totalExpense = expense;
    totalIncome = income;
    currentBalance = balance;
    notifyListeners();
  }
}
