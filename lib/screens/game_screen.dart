import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:ethiomotion_words/theme.dart';
import 'package:ethiomotion_words/providers/game_provider.dart';
import 'package:ethiomotion_words/screens/result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // ── Sensor ───────────────────────────────────────────────────────────────
  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  double _currentZ = 0;
  bool _sensorAvailable = false;

  // ── Timer ────────────────────────────────────────────────────────────────
  Timer? _gameTimer;

  // ── Feedback Animation ───────────────────────────────────────────────────
  String? _feedbackText;
  Color? _feedbackColor;
  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;
  late Animation<double> _feedbackOpacity;

  // ── Word Animation ───────────────────────────────────────────────────────
  late AnimationController _wordController;
  late Animation<double> _wordScale;

  @override
  void initState() {
    super.initState();

    // ── Force landscape & keep screen awake ─────────────────────────────
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WakelockPlus.enable();

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _feedbackScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );
    _feedbackOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _feedbackController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _wordController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _wordScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _wordController, curve: Curves.easeOutBack),
    );
    _wordController.forward();

    _startTimer();
    _initSensor();
  }

  void _initSensor() {
    if (kIsWeb) {
      try {
        _accelerometerSub = accelerometerEventStream(
          samplingPeriod: const Duration(milliseconds: 100),
        ).listen(
          (event) => _onAccelerometerData(event),
          onError: (error) {
            debugPrint('Accelerometer not available on web: $error');
            setState(() => _sensorAvailable = false);
          },
        );
        setState(() => _sensorAvailable = true);
      } catch (e) {
        debugPrint('Accelerometer not available: $e');
        setState(() => _sensorAvailable = false);
      }
    } else {
      _accelerometerSub = accelerometerEventStream(
        samplingPeriod: const Duration(milliseconds: 100),
      ).listen(
        (event) {
          _onAccelerometerData(event);
          if (!_sensorAvailable) {
            setState(() => _sensorAvailable = true);
          }
        },
        onError: (error) {
          debugPrint('Accelerometer error: $error');
          setState(() => _sensorAvailable = false);
        },
      );
    }
  }

  void _onAccelerometerData(AccelerometerEvent event) {
    if (!mounted) return;
    _currentZ = event.z;

    final provider = Provider.of<GameProvider>(context, listen: false);
    if (!provider.isGameActive || provider.isCooldown) return;

    // Use provider's sensitivity thresholds instead of hardcoded values
    if (_currentZ > provider.tiltDownThreshold) {
      _onCorrect(provider);
    } else if (_currentZ < provider.tiltUpThreshold) {
      _onSkip(provider);
    }
  }

  void _onCorrect(GameProvider provider) {
    provider.markCorrect();
    _showFeedback('CORRECT! ✓', correctColor);
    _animateNewWord();
  }

  void _onSkip(GameProvider provider) {
    provider.markSkip();
    _showFeedback('SKIP ✗', skipColor);
    _animateNewWord();
  }

  void _showFeedback(String text, Color color) {
    setState(() {
      _feedbackText = text;
      _feedbackColor = color;
    });
    _feedbackController.reset();
    _feedbackController.forward();
  }

  void _animateNewWord() {
    _wordController.reset();
    _wordController.forward();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final provider = Provider.of<GameProvider>(context, listen: false);
      provider.tick();
      if (provider.isGameOver) {
        timer.cancel();
        _navigateToResults();
      }
    });
  }

  void _navigateToResults() {
    if (!mounted) return;
    // Restore portrait & disable wakelock before navigating away
    _restoreScreenSettings();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ResultScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _restoreScreenSettings() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WakelockPlus.disable();
  }

  @override
  void dispose() {
    _accelerometerSub?.cancel();
    _gameTimer?.cancel();
    _feedbackController.dispose();
    _wordController.dispose();
    // Safety net: restore screen settings on dispose
    _restoreScreenSettings();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        if (provider.isGameOver) {
          return const SizedBox.shrink();
        }

        final progress = provider.timeRemaining / provider.gameDuration;
        final isLowTime = provider.timeRemaining <= 10;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _feedbackColor != null &&
                        _feedbackController.status == AnimationStatus.forward
                    ? [
                        _feedbackColor!.withAlpha(60),
                        const Color(0xFF0D1B2A),
                      ]
                    : [
                        (provider.selectedCategory?.color ?? ethiopianGreen)
                            .withAlpha(80),
                        const Color(0xFF0D1B2A),
                      ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // ── Main Content ─────────────────────────────────────
                  Column(
                    children: [
                      _buildTimerBar(provider, progress, isLowTime),
                      const SizedBox(height: 8),
                      _buildScoreBar(provider),
                      Expanded(
                        child: Center(
                          child: ScaleTransition(
                            scale: _wordScale,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                provider.currentWord,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!_sensorAvailable) _buildManualButtons(provider),
                      _buildSensorStatus(),
                      const SizedBox(height: 16),
                    ],
                  ),

                  // ── Feedback Overlay ─────────────────────────────────
                  if (_feedbackText != null)
                    _AnimListenerWidget(
                      animation: _feedbackController,
                      builder: (context, _) {
                        return Positioned.fill(
                          child: IgnorePointer(
                            child: Opacity(
                              opacity: _feedbackOpacity.value,
                              child: Center(
                                child: Transform.scale(
                                  scale: _feedbackScale.value,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _feedbackColor?.withAlpha(200),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _feedbackText!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimerBar(
      GameProvider provider, double progress, bool isLowTime) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                provider.selectedCategory?.category ?? '',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isLowTime ? ethiopianRed : Colors.white,
                  fontSize: isLowTime ? 24 : 20,
                  fontWeight: FontWeight.w800,
                ),
                child: Text('${provider.timeRemaining}s'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withAlpha(20),
              valueColor: AlwaysStoppedAnimation<Color>(
                isLowTime ? ethiopianRed : ethiopianGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBar(GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _scoreChip(
              Icons.check_circle, '${provider.correctCount}', correctColor),
          const SizedBox(width: 16),
          _scoreChip(Icons.skip_next, '${provider.skipCount}', skipColor),
          const SizedBox(width: 16),
          _scoreChip(
              Icons.format_list_numbered,
              '${provider.currentWordNumber}/${provider.totalWords}',
              Colors.white54),
        ],
      ),
    );
  }

  Widget _scoreChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualButtons(GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _onSkip(provider),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: skipColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: skipColor.withAlpha(80)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.arrow_upward, color: skipColor, size: 28),
                    SizedBox(height: 4),
                    Text(
                      'SKIP',
                      style: TextStyle(
                        color: skipColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => _onCorrect(provider),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: correctColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: correctColor.withAlpha(80)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.arrow_downward, color: correctColor, size: 28),
                    SizedBox(height: 4),
                    Text(
                      'CORRECT',
                      style: TextStyle(
                        color: correctColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _sensorAvailable ? Icons.sensors : Icons.sensors_off,
            color: _sensorAvailable ? ethiopianGreen : Colors.white38,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            _sensorAvailable
                ? 'Motion sensor active'
                : 'Motion sensor unavailable — use buttons',
            style: TextStyle(
              color: _sensorAvailable
                  ? ethiopianGreen.withAlpha(180)
                  : Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lightweight widget that rebuilds when an Animation ticks.
class _AnimListenerWidget extends StatefulWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?) builder;

  const _AnimListenerWidget({
    required this.animation,
    required this.builder,
  });

  @override
  State<_AnimListenerWidget> createState() => _AnimListenerWidgetState();
}

class _AnimListenerWidgetState extends State<_AnimListenerWidget> {
  @override
  void initState() {
    super.initState();
    widget.animation.addListener(_onTick);
  }

  @override
  void dispose() {
    widget.animation.removeListener(_onTick);
    super.dispose();
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, null);
}
