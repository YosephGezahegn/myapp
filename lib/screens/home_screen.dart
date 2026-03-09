import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethiomotion_words/theme.dart';
import 'package:ethiomotion_words/l10n/strings.dart';
import 'package:ethiomotion_words/providers/game_provider.dart';
import 'package:ethiomotion_words/screens/category_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
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
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D1B2A),
                  Color(0xFF1B2838),
                  Color(0xFF0D1B2A),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // ── Language Selector ─────────────────────────────
                          _buildLanguageSelector(provider),
                          const SizedBox(height: 30),

                          // ── Logo ──────────────────────────────────────────
                          ScaleTransition(
                            scale: _scaleAnim,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    ethiopianGreen,
                                    ethiopianYellow,
                                    ethiopianRed,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ethiopianGreen.withAlpha(100),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF0D1B2A),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '🇪🇹',
                                      style: TextStyle(fontSize: 64),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // ── Title ─────────────────────────────────────────
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                ethiopianGreen,
                                ethiopianYellow,
                                ethiopianRed,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              provider.tr('appTitle'),
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider.tr('appSubtitle'),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white54,
                                  letterSpacing: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: ethiopianYellow.withAlpha(60),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              provider.tr('appTagline'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: ethiopianYellow.withAlpha(200),
                                    letterSpacing: 1,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 60),

                          // ── Play Button ───────────────────────────────────
                          _buildPlayButton(context, provider),
                          const SizedBox(height: 20),

                          // ── How to Play ───────────────────────────────────
                          TextButton.icon(
                            onPressed: () => _showHowToPlay(context, provider),
                            icon: Icon(
                              Icons.help_outline,
                              color: Colors.white.withAlpha(150),
                            ),
                            label: Text(
                              provider.tr('howToPlay'),
                              style: TextStyle(
                                color: Colors.white.withAlpha(150),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector(GameProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, color: Colors.white.withAlpha(150), size: 18),
          const SizedBox(width: 8),
          ...AppLanguage.values.map((lang) {
            final isActive = provider.language == lang;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () => provider.setLanguage(lang),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [ethiopianGreen, Color(0xFF00C853)])
                        : null,
                    color: isActive ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${lang.flag} ${lang.nativeName}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white54,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, GameProvider provider) {
    if (provider.isLoading) {
      return const CircularProgressIndicator(color: ethiopianYellow);
    }
    return GestureDetector(
      onTap: () {
        provider.resetGame();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const CategorySelectionScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [ethiopianGreen, Color(0xFF00C853)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: ethiopianGreen.withAlpha(100),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(
              provider.tr('play'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHowToPlay(BuildContext context, GameProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B2838),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              provider.tr('howToPlay'),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 20),
            _howToPlayStep('1', provider.tr('step1Title'),
                provider.tr('step1Desc'), Icons.category),
            _howToPlayStep('2', provider.tr('step2Title'),
                provider.tr('step2Desc'), Icons.phone_android),
            _howToPlayStep('3', provider.tr('step3Title'),
                provider.tr('step3Desc'), Icons.people),
            _howToPlayStep('4', provider.tr('step4Title'),
                provider.tr('step4Desc'), Icons.screen_rotation),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _howToPlayStep(
      String number, String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [ethiopianGreen, ethiopianYellow],
              ),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white.withAlpha(150),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
