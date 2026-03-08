import 'package:flutter/material.dart';

class WordCategory {
  final String category;
  final List<String> words;
  final IconData icon;
  final Color color;

  const WordCategory({
    required this.category,
    required this.words,
    required this.icon,
    required this.color,
  });

  factory WordCategory.fromJson(Map<String, dynamic> json) {
    return WordCategory(
      category: json['category'] as String,
      words: (json['words'] as List<dynamic>).cast<String>(),
      icon: _iconFromString(json['icon'] as String? ?? 'category'),
      color: _colorFromHex(json['color'] as String? ?? '#009A44'),
    );
  }

  static IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'location_city':
        return Icons.location_city;
      case 'star':
        return Icons.star;
      case 'history_edu':
        return Icons.history_edu;
      case 'pets':
        return Icons.pets;
      case 'celebration':
        return Icons.celebration;
      default:
        return Icons.category;
    }
  }

  static Color _colorFromHex(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}