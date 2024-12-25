import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_transaction_screen.dart';
import '../providers/transaction_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Flowwie',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₺${transactionProvider.totalBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSummaryItem(
                              label: 'Income',
                              amount:
                                  '₺${transactionProvider.totalIncome.toStringAsFixed(2)}',
                              color: Colors.green,
                            ),
                            _buildSummaryItem(
                              label: 'Expenses',
                              amount:
                                  '₺${transactionProvider.totalExpenses.toStringAsFixed(2)}',
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactionProvider.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction =
                          transactionProvider.transactions[index];
                      return Dismissible(
                        key: Key(transaction.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          Provider.of<TransactionProvider>(context,
                                  listen: false)
                              .deleteTransaction(transaction.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${transaction.description} is deleted.'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  Provider.of<TransactionProvider>(context,
                                          listen: false)
                                      .addTransaction(
                                    transaction.amount,
                                    transaction.description,
                                    transaction.isIncome,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: transaction.isIncome
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              child: Icon(
                                transaction.isIncome ? Icons.add : Icons.remove,
                                color: transaction.isIncome
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            title: Text(transaction.description),
                            subtitle: Text(
                              transaction.date.toString().split(' ')[0],
                            ),
                            trailing: Text(
                              '₺${transaction.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: transaction.isIncome
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              heroTag: 'income',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddTransactionScreen(isIncome: true),
                  ),
                );
              },
              label: const Text('Add Income'),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
            FloatingActionButton.extended(
              heroTag: 'expense',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddTransactionScreen(isIncome: false),
                  ),
                );
              },
              label: const Text('Add Expense'),
              icon: const Icon(Icons.remove),
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String amount,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}