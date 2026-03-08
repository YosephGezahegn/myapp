import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confetti App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Confetti Funnny'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _confettiLevel = 20.0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    developer.log('Confetti App Initialized', name: 'app.lifecycle');
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    developer.log('Counter incremented to $_counter', name: 'app.interaction');
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Row(
              children: [
                // Improved Vertical Slider Container
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                            value: _confettiLevel,
                            min: 1,
                            max: 100,
                            divisions: 20,
                            label: _confettiLevel.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _confettiLevel = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const Icon(Icons.star_border, color: Colors.grey),
                      const SizedBox(height: 8),
                      const Text('Level',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Celebrations:',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 8,
                          shadowColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20.0),
                            child: Text(
                              '$_counter',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Intensity: ${_confettiLevel.round()}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.large(
            onPressed: _incrementCounter,
            tooltip: 'Celebrate!',
            child: const Icon(Icons.celebration, size: 40),
          ),
        ),
        // Confetti overlap
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            maxBlastForce: 10,
            minBlastForce: 5,
            emissionFrequency: 0.1,
            numberOfParticles: _confettiLevel.round(),
            gravity: 0.2,
            shouldLoop: false,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.yellow,
              Colors.green,
              Colors.purple,
              Colors.orange,
              Colors.pink,
            ],
          ),
        ),
      ],
    );
  }
}
