import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/currency.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  Currency _selectedCurrency = Currency.TRY;
  static const String _transactionsKey = 'transactions';
  static const String _currencyKey = 'selected_currency';

  TransactionProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsJson = prefs.getString(_transactionsKey);
    final String? currencyString = prefs.getString(_currencyKey);

    if (transactionsJson != null) {
      final List<dynamic> decodedList = json.decode(transactionsJson);
      _transactions = decodedList.map((item) => Transaction.fromJson(item)).toList();
    }

    if (currencyString != null) {
      _selectedCurrency = Currency.values.firstWhere(
        (c) => c.toString() == currencyString,
        orElse: () => Currency.TRY,
      );
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String transactionsJson = json.encode(
      _transactions.map((t) => t.toJson()).toList(),
    );
    await prefs.setString(_transactionsKey, transactionsJson);
    await prefs.setString(_currencyKey, _selectedCurrency.toString());
  }

  // Exchange rates (simplified - in real app, these should come from an API)
  final Map<Currency, Map<Currency, double>> _exchangeRates = {
    Currency.USD: {
      Currency.EUR: 0.91234,
      Currency.GBP: 0.78901,
      Currency.TRY: 29.05432,
      Currency.USD: 1.0,
    },
    Currency.EUR: {
      Currency.USD: 1.09615,
      Currency.GBP: 0.86478,
      Currency.TRY: 31.93267,
      Currency.EUR: 1.0,
    },
    Currency.GBP: {
      Currency.USD: 1.26743,
      Currency.EUR: 1.15636,
      Currency.TRY: 36.70123,
      Currency.GBP: 1.0,
    },
    Currency.TRY: {
      Currency.USD: 0.034418,
      Currency.EUR: 0.031316,
      Currency.GBP: 0.027247,
      Currency.TRY: 1.0,
    },
  };

  List<Transaction> get transactions => [..._transactions];
  Currency get selectedCurrency => _selectedCurrency;

  void setCurrency(Currency currency) {
    _selectedCurrency = currency;
    _saveData();
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
    String categoryId,
    [DateTime? date]
  ) {
    final transaction = Transaction(
      id: DateTime.now().toString(),
      amount: amount,
      description: description,
      date: date ?? DateTime.now(),
      isIncome: isIncome,
      currency: currency,
      categoryId: categoryId,
    );
    _transactions.add(transaction);
    _saveData();
    notifyListeners();
  }

  void removeTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    _saveData();
    notifyListeners();
  }
}
