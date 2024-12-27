import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/currency.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isIncome;

  const AddTransactionScreen({
    Key? key,
    required this.isIncome,
  }) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Currency _selectedCurrency = Currency.TRY;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categories = Provider.of<CategoryProvider>(context, listen: false)
          .getCategoriesByType(widget.isIncome);
      if (categories.isNotEmpty) {
        setState(() {
          _selectedCategoryId = categories.first.id;
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  IconData? getIconData(String? iconName) {
    if (iconName == null) return null;
    try {
      return IconData(int.parse(iconName), fontFamily: 'MaterialIcons');
    } catch (e) {
      return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isIncome ? 'Gelir Ekle' : 'Harcama Ekle',
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context),
            tooltip: 'Yeni Kategori Ekle',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: Provider.of<CategoryProvider>(context)
                      .getCategoriesByType(widget.isIncome)
                      .map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Row(
                        children: [
                          if (category.iconName != null)
                            Icon(getIconData(category.iconName) ?? Icons.category),
                          const SizedBox(width: 8),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir kategori seçin';
                    }
                    return null;
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategoryId = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Miktar',
                          prefixText: getCurrencySymbol(_selectedCurrency),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir miktar girin';
                          }
                          if (double.tryParse(value.replaceAll(',', '.')) == null) {
                            return 'Geçerli bir sayı girin';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<Currency>(
                        value: _selectedCurrency,
                        decoration: const InputDecoration(
                          labelText: 'Para Birimi',
                          border: OutlineInputBorder(),
                        ),
                        items: Currency.values.map((Currency currency) {
                          return DropdownMenuItem<Currency>(
                            value: currency,
                            child: Text(currency.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (Currency? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCurrency = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Açıklama',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir açıklama girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final provider = Provider.of<TransactionProvider>(context, listen: false);
                      provider.addTransaction(
                        double.parse(_amountController.text.replaceAll(',', '.')),
                        _descriptionController.text,
                        widget.isIncome,
                        _selectedCurrency,
                        _selectedCategoryId!,
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isIncome ? Colors.green : Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Kaydet',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.isIncome ? 'Yeni Gelir Kategorisi' : 'Yeni Harcama Kategorisi'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Kategori Adı',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen bir kategori adı girin';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
                categoryProvider.addCategory(
                  nameController.text,
                  widget.isIncome,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
