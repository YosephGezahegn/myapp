import 'package:flutter/material.dart';
import 'package:ethiomotion_words/l10n/strings.dart';

class WordCategory {
  final String category;
  final String categoryAm;
  final String categoryOm;
  final List<String> words;
  final List<String> wordsAm;
  final List<String> wordsOm;
  final IconData icon;
  final Color color;

  const WordCategory({
    required this.category,
    required this.categoryAm,
    required this.categoryOm,
    required this.words,
    required this.wordsAm,
    required this.wordsOm,
    required this.icon,
    required this.color,
  });

  /// Returns the category name for the given language.
  String categoryForLang(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.amharic:
        return categoryAm.isNotEmpty ? categoryAm : category;
      case AppLanguage.oromiffa:
        return categoryOm.isNotEmpty ? categoryOm : category;
      case AppLanguage.english:
        return category;
    }
  }

  /// Returns the word list for the given language.
  List<String> wordsForLang(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.amharic:
        return wordsAm.isNotEmpty ? wordsAm : words;
      case AppLanguage.oromiffa:
        return wordsOm.isNotEmpty ? wordsOm : words;
      case AppLanguage.english:
        return words;
    }
  }

  factory WordCategory.fromJson(Map<String, dynamic> json) {
    return WordCategory(
      category: json['category'] as String,
      categoryAm: json['category_am'] as String? ?? '',
      categoryOm: json['category_om'] as String? ?? '',
      words: (json['words'] as List<dynamic>).cast<String>(),
      wordsAm: (json['words_am'] as List<dynamic>?)?.cast<String>() ?? [],
      wordsOm: (json['words_om'] as List<dynamic>?)?.cast<String>() ?? [],
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