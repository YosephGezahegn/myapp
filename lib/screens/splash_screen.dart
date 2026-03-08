import 'package:flutter/material.dart';
import 'package:ethio_motion_words/theme.dart'; // Import your theme
import 'package:ethio_motion_words/screens/home_screen.dart'; // Import the home screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home screen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ethiopianRed, // Ethiopian flag colors
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: ethiopianYellow,
                borderRadius: BorderRadius.circular(75),
              ),
              child: Center(
                child: Text(
                  'EW',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: ethiopianGreen, fontSize: 60),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'EthioMotion Words',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
