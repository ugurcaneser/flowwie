import 'package:flowwie/models/currency.dart';
import 'package:flowwie/providers/category_provider.dart';
import 'package:flowwie/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/animated_fab.dart';
import '../screens/transaction_detail_screen.dart';
import '../widgets/tap_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showTapIndicator = true;

  @override
  void initState() {
    super.initState();
    // Hide indicator after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showTapIndicator = false;
        });
      }
    });
  }

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

  IconData getIconData(String? iconName) {
    if (iconName == null) return Icons.help_outline;

    // Map string names to Material Icons
    final iconMap = {
      'house': Icons.home_work,
      'car': Icons.directions_car,
      'utensils': Icons.restaurant_menu,
      'shoppingCart': Icons.shopping_cart,
      'creditCard': Icons.credit_card,
      'plane': Icons.flight,
      'heartbeat': Icons.favorite,
      'graduationCap': Icons.school,
      'gamepad': Icons.games,
      'gift': Icons.card_giftcard,
      'question': Icons.help_outline,
      'money': Icons.payments,
      'wallet': Icons.account_balance_wallet,
      'investment': Icons.trending_up,
      'bagShopping': Icons.shopping_bag,
      'food': Icons.restaurant,
      'bus': Icons.directions_bus_filled,
      'health': Icons.medical_services,
      'education': Icons.school,
      'entertainment': Icons.games,
      'bills': Icons.receipt_long,
      'fileInvoiceDollar': Icons.receipt_long,
      'chartLine': Icons.show_chart,
      'chart-line': Icons.show_chart,
      'other': Icons.more_horiz,
    };

    return iconMap[iconName.toLowerCase()] ?? Icons.help_outline;
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
      body: Stack(
        children: [
          SafeArea(
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
                                color: Colors.black,
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
                                        Provider.of<TransactionProvider>(
                                                context,
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
                              child: Container(
                                color: Colors.white,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TransactionDetailScreen(
                                                transaction: transaction),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Consumer<CategoryProvider>(
                                      builder:
                                          (context, categoryProvider, child) {
                                        Category? category;

                                        category = categoryProvider.categories
                                            .cast<Category?>()
                                            .firstWhere(
                                              (cat) =>
                                                  cat?.id ==
                                                  transaction.categoryId,
                                              orElse: () => null,
                                            );

                                        category ??= Category(
                                          id: 'default',
                                          name: 'Unknown',
                                          iconName: 'question',
                                          isIncome: false,
                                        );

                                        return Icon(
                                          getIconData(category.iconName),
                                          color: Colors.black,
                                          size: 20,
                                        );
                                      },
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
          if (_showTapIndicator)
            TapIndicator(
              onDismiss: () => setState(() => _showTapIndicator = false),
            ),
        ],
      ),
      floatingActionButton: const AnimatedFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
