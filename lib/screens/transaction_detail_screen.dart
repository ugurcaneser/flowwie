import 'package:flutter/material.dart';
import '../models/transaction.dart'; // Transaction modelini uygun şekilde içe aktarın

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kind: ${transaction.isIncome ? 'Income' : 'Expense'}',
                style: const TextStyle(fontSize: 20)),
            Text('Description: ${transaction.description}',
                style: const TextStyle(fontSize: 20)),
            Text('Amount: ${transaction.amount}',
                style: const TextStyle(fontSize: 20)),
            Text('Date: ${transaction.date}',
                style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
