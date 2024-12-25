import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => [..._transactions];

  double get totalBalance {
    return _transactions.fold(0, (sum, transaction) {
      return sum + (transaction.isIncome ? transaction.amount : -transaction.amount);
    });
  }

  double get totalIncome {
    return _transactions
        .where((transaction) => transaction.isIncome)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((transaction) => !transaction.isIncome)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  void addTransaction(
    double amount,
    String description,
    bool isIncome,
  ) {
    final transaction = Transaction(
      id: DateTime.now().toString(),
      amount: amount,
      description: description,
      date: DateTime.now(),
      isIncome: isIncome,
    );

    _transactions.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }
}
