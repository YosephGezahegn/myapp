import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:ethiomotion_words/main.dart';
import 'package:ethiomotion_words/providers/game_provider.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameProvider(),
        child: const EthioMotionApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('EthioMotion'), findsOneWidget);
    expect(find.text('WORDS'), findsOneWidget);

    // Verify that the PLAY button is present
    expect(find.text('PLAY'), findsOneWidget);

    // Verify that How to Play button is present
    expect(find.text('How to Play'), findsOneWidget);
  });
}
