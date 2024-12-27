import '../models/currency.dart';

class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final bool isIncome;
  final Currency currency;
  final String categoryId;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.isIncome,
    required this.currency,
    required this.categoryId,
  });

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'isIncome': isIncome,
      'currency': currency.toString().split('.').last,
      'categoryId': categoryId,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      date: DateTime.parse(json['date']),
      isIncome: json['isIncome'],
      currency: Currency.values.firstWhere(
        (c) => c.toString().split('.').last == json['currency'],
        orElse: () => Currency.USD,
      ),
      categoryId: json['categoryId'],
    );
  }
}
