import 'dart:convert';
import 'package:flutter/foundation.dart' as foundation;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';

class CategoryProvider with foundation.ChangeNotifier {
  List<Category> _categories = [];
  static const String _categoriesKey = 'categories';

  CategoryProvider() {
    _loadDefaultCategories();
    _loadCategories();
  }

  List<Category> get categories => [..._categories];

  List<Category> getCategoriesByType(bool isIncome) {
    return _categories.where((cat) => cat.isIncome == isIncome).toList();
  }

  void _loadDefaultCategories() {
    if (_categories.isEmpty) {
      // Default expense categories
      final defaultExpenses = [
        Category(
          id: 'exp_food',
          name: 'Food & Drink',
          isIncome: false,
          iconName: 'utensils',
        ),
        Category(
          id: 'exp_transport',
          name: 'Transport',
          isIncome: false,
          iconName: 'bus',
        ),
        Category(
          id: 'exp_shopping',
          name: 'Shopping',
          isIncome: false,
          iconName: 'bagShopping',
        ),
        Category(
          id: 'exp_bills',
          name: 'Bills',
          isIncome: false,
          iconName: 'fileInvoiceDollar',
        ),
        Category(
          id: 'exp_entertainment',
          name: 'Entertainment',
          isIncome: false,
          iconName: 'gamepad',
        ),
      ];

      // Default income categories
      final defaultIncomes = [
        Category(
          id: 'inc_salary',
          name: 'Salary',
          isIncome: true,
          iconName: 'wallet',
        ),
        Category(
          id: 'inc_freelance',
          name: 'Freelance',
          isIncome: true,
          iconName: 'house',
        ),
        Category(
          id: 'inc_investment',
          name: 'Investment',
          isIncome: true,
          iconName: 'chart-line',
        ),
      ];

      _categories = [...defaultExpenses, ...defaultIncomes];
      _saveCategories();
    }
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? categoriesJson = prefs.getString(_categoriesKey);

    if (categoriesJson != null) {
      final List<dynamic> decodedList = json.decode(categoriesJson);
      _categories = decodedList.map((item) => Category.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(_categories.map((e) => e.toJson()).toList());
    await prefs.setString(_categoriesKey, encodedData);
    notifyListeners();
  }

  Future<void> addCategory(String name, bool isIncome,
      {String? iconName}) async {
    final newCategory = Category(
      id: DateTime.now().toString(),
      name: name,
      isIncome: isIncome,
      iconName: iconName,
    );

    _categories.add(newCategory);
    await _saveCategories();
  }

  Future<void> removeCategory(String id) async {
    _categories.removeWhere((category) => category.id == id);
    await _saveCategories();
  }
}
