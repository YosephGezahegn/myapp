import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ethiomotion_words/models/word_category.dart';

/// Manages game state: categories, current word, score, timer, results.
class GameProvider extends ChangeNotifier {
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

    _shuffledWords = List<String>.from(_selectedCategory!.words);
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
