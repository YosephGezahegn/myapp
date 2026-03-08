import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:ethiomotion_words/theme.dart';
import 'package:ethiomotion_words/providers/game_provider.dart';
import 'package:ethiomotion_words/screens/category_selection_screen.dart';
import 'package:ethiomotion_words/screens/home_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    // Restore portrait orientation & disable wakelock
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WakelockPlus.disable();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final results = provider.results;
    final total = provider.correctCount + provider.skipCount;
    final percentage = total > 0 ? (provider.correctCount / total * 100) : 0;

    String emoji;
    String message;
    if (percentage >= 80) {
      emoji = '🏆';
      message = 'Outstanding!';
    } else if (percentage >= 60) {
      emoji = '🎉';
      message = 'Well Done!';
    } else if (percentage >= 40) {
      emoji = '👍';
      message = 'Good Try!';
    } else {
      emoji = '💪';
      message = 'Keep Practicing!';
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF1B2838),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                const SizedBox(height: 24),

                // ── Header ─────────────────────────────────────────────
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.selectedCategory?.category ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white54,
                      ),
                ),
                const SizedBox(height: 24),

                // ── Score Summary ──────────────────────────────────────
                _buildScoreSummary(context, provider, percentage),
                const SizedBox(height: 16),

                // ── Results List ───────────────────────────────────────
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(8),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Word Results',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final result = results[index];
                              final isCorrect = result['correct'] as bool;
                              return _buildResultTile(
                                  result['word'] as String, isCorrect, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Action Buttons ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          'Play Again',
                          Icons.replay,
                          ethiopianGreen,
                          () {
                            provider.resetGame();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CategorySelectionScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          'Home',
                          Icons.home,
                          ethiopianYellow,
                          () {
                            provider.resetGame();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSummary(
      BuildContext context, GameProvider provider, num percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildScoreCircle(
            '${provider.correctCount}',
            'Correct',
            correctColor,
          ),
          _buildScoreCircle(
            '${percentage.round()}%',
            'Accuracy',
            ethiopianYellow,
          ),
          _buildScoreCircle(
            '${provider.skipCount}',
            'Skipped',
            skipColor,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCircle(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withAlpha(100),
                color.withAlpha(40),
              ],
            ),
            border: Border.all(color: color.withAlpha(120), width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color.withAlpha(180),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildResultTile(String word, bool isCorrect, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCorrect
            ? correctColor.withAlpha(15)
            : skipColor.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? correctColor.withAlpha(40)
              : skipColor.withAlpha(40),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCorrect
                  ? correctColor.withAlpha(40)
                  : skipColor.withAlpha(40),
            ),
            child: Icon(
              isCorrect ? Icons.check : Icons.close,
              color: isCorrect ? correctColor : skipColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              word,
              style: TextStyle(
                color: Colors.white.withAlpha(220),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            isCorrect ? 'Correct' : 'Skipped',
            style: TextStyle(
              color: isCorrect ? correctColor : skipColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withAlpha(180)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(60),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
