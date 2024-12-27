import 'dart:convert';

class Category {
  final String id;
  final String name;
  final bool isIncome;
  final String? iconName;

  Category({
    required this.id,
    required this.name,
    required this.isIncome,
    this.iconName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isIncome': isIncome,
      'iconName': iconName,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      isIncome: json['isIncome'],
      iconName: json['iconName'],
    );
  }
}
