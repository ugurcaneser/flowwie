import 'package:flowwie/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/animated_fab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return '\$';
      case Currency.EUR:
        return '€';
      case Currency.GBP:
        return '£';
      case Currency.TRY:
        return '₺';
    }
  }

  Widget _buildSummaryItem({
    required String label,
    required String amount,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        Text(
          amount,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Balance',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Consumer<TransactionProvider>(
                            builder: (context, provider, _) {
                              return Row(
                                children: [
                                  Text(
                                    '${getCurrencySymbol(provider.selectedCurrency)}${provider.totalBalance.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  DropdownButton<Currency>(
                                    value: provider.selectedCurrency,
                                    items: Currency.values.map((currency) {
                                      return DropdownMenuItem(
                                        value: currency,
                                        child: Text(currency
                                            .toString()
                                            .split('.')
                                            .last),
                                      );
                                    }).toList(),
                                    onChanged: (Currency? newCurrency) {
                                      if (newCurrency != null) {
                                        provider.setCurrency(newCurrency);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Consumer<TransactionProvider>(
                            builder: (context, provider, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildSummaryItem(
                                    label: 'Income',
                                    amount:
                                        '${getCurrencySymbol(provider.selectedCurrency)}${provider.totalIncome.toStringAsFixed(2)}',
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 30),
                                  _buildSummaryItem(
                                    label: 'Expenses',
                                    amount:
                                        '${getCurrencySymbol(provider.selectedCurrency)}${provider.totalExpenses.toStringAsFixed(2)}',
                                    color: Colors.black,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 16,
                      ),
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
                                .removeTransaction(transaction.id);
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
                                      transaction.currency,
                                      transaction.categoryId,
                                      transaction.date,
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
                                backgroundColor: Colors.white,
                                child: Icon(
                                  transaction.isIncome
                                      ? Icons.add
                                      : Icons.remove,
                                  color: Colors.black,
                                ),
                              ),
                              title: Text(transaction.description),
                              subtitle: Text(
                                transaction.date.toString().split(' ')[0],
                              ),
                              trailing: Text(
                                '${getCurrencySymbol(transaction.currency)}${transaction.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.black,
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
      ),
      floatingActionButton: const AnimatedFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
