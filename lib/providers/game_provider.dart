import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ethiomotion_words/models/word_category.dart';
import 'package:ethiomotion_words/l10n/strings.dart';

/// Manages game state: categories, current word, score, timer, results.
class GameProvider extends ChangeNotifier {
  // ── Language ─────────────────────────────────────────────────────────────
  AppLanguage _language = AppLanguage.english;
  AppLanguage get language => _language;

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  /// Shortcut to get a localized UI string.
  String tr(String key) => S.get(key, _language);

  // ── Category Data ────────────────────────────────────────────────────────
  List<WordCategory> _categories = [];
  List<WordCategory> get categories => _categories;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // ── Game State ───────────────────────────────────────────────────────────
  WordCategory? _selectedCategory;
  WordCategory? get selectedCategory => _selectedCategory;

  List<String> _shuffledWords = [];
  int _currentWordIndex = 0;
  String get currentWord =>
      _shuffledWords.isNotEmpty ? _shuffledWords[_currentWordIndex] : '';
  int get wordsRemaining =>
      _shuffledWords.length - _currentWordIndex - 1;
  int get totalWords => _shuffledWords.length;
  int get currentWordNumber => _currentWordIndex + 1;

  // ── Score ─────────────────────────────────────────────────────────────────
  int _correctCount = 0;
  int get correctCount => _correctCount;
  int _skipCount = 0;
  int get skipCount => _skipCount;

  final List<Map<String, dynamic>> _results = [];
  List<Map<String, dynamic>> get results => List.unmodifiable(_results);

  // ── Timer ─────────────────────────────────────────────────────────────────
  int _gameDuration = 60; // seconds
  int get gameDuration => _gameDuration;
  int _timeRemaining = 60;
  int get timeRemaining => _timeRemaining;

  bool _isGameActive = false;
  bool get isGameActive => _isGameActive;

  bool _isGameOver = false;
  bool get isGameOver => _isGameOver;

  // Cooldown to prevent rapid sensor triggers
  bool _isCooldown = false;
  bool get isCooldown => _isCooldown;

  // ── Sensitivity Settings ──────────────────────────────────────────────────
  // Tilt-down threshold (correct): higher = less sensitive, lower = more sensitive
  double _tiltDownThreshold = 6.0;
  double get tiltDownThreshold => _tiltDownThreshold;

  // Tilt-up threshold (skip): more negative = less sensitive, less negative = more sensitive
  double _tiltUpThreshold = -4.0;
  double get tiltUpThreshold => _tiltUpThreshold;

  // Sensitivity label for display
  String get sensitivityLabel {
    if (_tiltDownThreshold >= 7.0) return 'Low';
    if (_tiltDownThreshold >= 5.5) return 'Medium';
    if (_tiltDownThreshold >= 4.0) return 'High';
    return 'Very High';
  }

  void setTiltDownSensitivity(double value) {
    _tiltDownThreshold = value;
    notifyListeners();
  }

  void setTiltUpSensitivity(double value) {
    _tiltUpThreshold = value;
    notifyListeners();
  }

  /// Set both thresholds from a single sensitivity preset.
  /// [level]: 0 = Low, 1 = Medium (default), 2 = High, 3 = Very High
  void setSensitivityPreset(int level) {
    switch (level) {
      case 0: // Low sensitivity — requires strong tilt
        _tiltDownThreshold = 8.0;
        _tiltUpThreshold = -6.0;
        break;
      case 1: // Medium (default)
        _tiltDownThreshold = 6.0;
        _tiltUpThreshold = -4.0;
        break;
      case 2: // High — lighter tilt triggers
        _tiltDownThreshold = 4.5;
        _tiltUpThreshold = -3.0;
        break;
      case 3: // Very High — very light tilt triggers
        _tiltDownThreshold = 3.0;
        _tiltUpThreshold = -2.0;
        break;
    }
    notifyListeners();
  }

  int get sensitivityPresetIndex {
    if (_tiltDownThreshold >= 7.0) return 0;
    if (_tiltDownThreshold >= 5.5) return 1;
    if (_tiltDownThreshold >= 4.0) return 2;
    return 3;
  }

  // ── Asset paths ──────────────────────────────────────────────────────────
  static const List<String> _assetPaths = [
    'assets/words/ethiopian_food.json',
    'assets/words/ethiopian_cities.json',
    'assets/words/ethiopian_celebrities.json',
    'assets/words/ethiopian_history.json',
    'assets/words/animals.json',
    'assets/words/general_fun_words.json',
  ];

  GameProvider() {
    loadCategories();
  }

  // ── Load Categories from JSON ────────────────────────────────────────────
  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    final List<WordCategory> loaded = [];
    for (final path in _assetPaths) {
      try {
        final jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> data = json.decode(jsonString);
        loaded.add(WordCategory.fromJson(data));
      } catch (e) {
        debugPrint('Error loading $path: $e');
      }
    }
    _categories = loaded;
    _isLoading = false;
    notifyListeners();
  }

  // ── Game Setup ───────────────────────────────────────────────────────────
  void selectCategory(WordCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setGameDuration(int seconds) {
    _gameDuration = seconds;
    _timeRemaining = seconds;
    notifyListeners();
  }

  void startGame() {
    if (_selectedCategory == null) return;

    // Use language-appropriate word list
    _shuffledWords = List<String>.from(
      _selectedCategory!.wordsForLang(_language),
    );
    _shuffledWords.shuffle(Random());
    _currentWordIndex = 0;
    _correctCount = 0;
    _skipCount = 0;
    _results.clear();
    _timeRemaining = _gameDuration;
    _isGameActive = true;
    _isGameOver = false;
    _isCooldown = false;
    notifyListeners();
  }

  // ── Game Actions ─────────────────────────────────────────────────────────
  void markCorrect() {
    if (!_isGameActive || _isCooldown) return;

    _results.add({
      'word': currentWord,
      'correct': true,
    });
    _correctCount++;
    _startCooldown();
    _advanceWord();
  }

  void markSkip() {
    if (!_isGameActive || _isCooldown) return;

    _results.add({
      'word': currentWord,
      'correct': false,
    });
    _skipCount++;
    _startCooldown();
    _advanceWord();
  }

  void _advanceWord() {
    if (_currentWordIndex < _shuffledWords.length - 1) {
      _currentWordIndex++;
    } else {
      // No more words, end game
      endGame();
    }
    notifyListeners();
  }

  void _startCooldown() {
    _isCooldown = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 800), () {
      _isCooldown = false;
      notifyListeners();
    });
  }

  // ── Timer ─────────────────────────────────────────────────────────────────
  void tick() {
    if (!_isGameActive) return;
    if (_timeRemaining > 0) {
      _timeRemaining--;
      notifyListeners();
    }
    if (_timeRemaining <= 0) {
      endGame();
    }
  }

  void endGame() {
    _isGameActive = false;
    _isGameOver = true;
    notifyListeners();
  }

  // ── Reset ─────────────────────────────────────────────────────────────────
  void resetGame() {
    _selectedCategory = null;
    _shuffledWords.clear();
    _currentWordIndex = 0;
    _correctCount = 0;
    _skipCount = 0;
    _results.clear();
    _isGameActive = false;
    _isGameOver = false;
    _isCooldown = false;
    _timeRemaining = _gameDuration;
    notifyListeners();
  }
}
