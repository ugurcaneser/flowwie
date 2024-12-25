class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.isIncome,
  });
}
