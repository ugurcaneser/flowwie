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
            iconName: '0xe56c'),
        Category(
            id: 'exp_transport',
            name: 'Transport',
            isIncome: false,
            iconName: '0xe1d5'),
        Category(
            id: 'exp_shopping',
            name: 'Shopping',
            isIncome: false,
            iconName: '0xe59c'),
        Category(
            id: 'exp_bills',
            name: 'Bills',
            isIncome: false,
            iconName: '0xe536'),
        Category(
            id: 'exp_health',
            name: 'Health',
            isIncome: false,
            iconName: '0xe3f3'),
      ];

      // Default income categories
      final defaultIncomes = [
        Category(
            id: 'inc_salary',
            name: 'Salary',
            isIncome: true,
            iconName: '0xe850'),
        Category(
            id: 'inc_freelance',
            name: 'Freelance',
            isIncome: true,
            iconName: '0xe943'),
        Category(
            id: 'inc_investment',
            name: 'Investment',
            isIncome: true,
            iconName: '0xe8e4'),
        Category(
            id: 'inc_gift', name: 'Gift', isIncome: true, iconName: '0xe8f6'),
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
