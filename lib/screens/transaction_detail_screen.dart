import 'package:flutter/material.dart';
import '../models/transaction.dart'; // Transaction modelini uygun şekilde içe aktarın

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Transaction Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${transaction.isIncome ? 'Income' : 'Expense'}',
                style: const TextStyle(fontSize: 16)),
            Text('Description: ${transaction.description}',
                style: const TextStyle(fontSize: 16)),
            Text('Amount: ${transaction.amount}',
                style: const TextStyle(fontSize: 16)),
            Text(
                'Date: ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
