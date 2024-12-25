import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];
  Currency _selectedCurrency = Currency.USD;

  // Exchange rates (simplified - in real app, these should come from an API)
  final Map<Currency, Map<Currency, double>> _exchangeRates = {
    Currency.USD: {
      Currency.EUR: 0.91,
      Currency.GBP: 0.79,
      Currency.TRY: 29.05,
      Currency.USD: 1.0,
    },
    Currency.EUR: {
      Currency.USD: 1.10,
      Currency.GBP: 0.87,
      Currency.TRY: 31.93,
      Currency.EUR: 1.0,
    },
    Currency.GBP: {
      Currency.USD: 1.27,
      Currency.EUR: 1.15,
      Currency.TRY: 36.70,
      Currency.GBP: 1.0,
    },
    Currency.TRY: {
      Currency.USD: 0.034,
      Currency.EUR: 0.031,
      Currency.GBP: 0.027,
      Currency.TRY: 1.0,
    },
  };

  List<Transaction> get transactions => [..._transactions];
  Currency get selectedCurrency => _selectedCurrency;

  void setCurrency(Currency currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  double _convertCurrency(double amount, Currency from, Currency to) {
    return amount * (_exchangeRates[from]?[to] ?? 1.0);
  }

  double get totalBalance {
    return _transactions.fold(0, (sum, transaction) {
      double convertedAmount = _convertCurrency(
        transaction.amount,
        transaction.currency,
        _selectedCurrency,
      );
      return sum + (transaction.isIncome ? convertedAmount : -convertedAmount);
    });
  }

  Map<Currency, double> get totalBalanceByCurrency {
    final Map<Currency, double> balances = {
      for (var currency in Currency.values) currency: 0.0
    };

    for (var transaction in _transactions) {
      final amount = transaction.isIncome ? transaction.amount : -transaction.amount;
      balances[transaction.currency] = balances[transaction.currency]! + amount;
    }

    return balances;
  }

  double get totalIncome {
    return _transactions
        .where((transaction) => transaction.isIncome)
        .fold(0, (sum, transaction) {
      double convertedAmount = _convertCurrency(
        transaction.amount,
        transaction.currency,
        _selectedCurrency,
      );
      return sum + convertedAmount;
    });
  }

  double get totalExpenses {
    return _transactions
        .where((transaction) => !transaction.isIncome)
        .fold(0, (sum, transaction) {
      double convertedAmount = _convertCurrency(
        transaction.amount,
        transaction.currency,
        _selectedCurrency,
      );
      return sum + convertedAmount;
    });
  }

  void addTransaction(
    double amount,
    String description,
    bool isIncome,
    Currency currency,
  ) {
    final transaction = Transaction(
      id: DateTime.now().toString(),
      amount: amount,
      description: description,
      date: DateTime.now(),
      isIncome: isIncome,
      currency: currency ?? _selectedCurrency,
    );

    _transactions.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }
}
