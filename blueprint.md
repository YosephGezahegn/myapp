# EthioMotion Words - Project Blueprint

## Project Overview
EthioMotion Words is a modern Flutter mobile game inspired by Ethiopian culture. Players guess words using motion controls, where the phone detects head movements via device sensors to determine correct or skipped answers, similar to the "Heads Up" game.

## Style, Design, and Features Implemented

### Initial Version (Current State)
*   **App Name:** EthioMotion Words
*   **Dependencies:**
    *   `cupertino_icons`: For iOS style icons.
    *   `confetti`: For confetti animations.
    *   `sensors_plus`: For motion detection.
    *   `google_fonts`: For custom typography.
    *   `provider`: For state management.
    *   `json_annotation` and `json_serializable`: For local word storage (JSON parsing).
*   **Assets:** Configured paths for local JSON word categories.
    *   `assets/words/ethiopian_food.json`
    *   `assets/words/ethiopian_cities.json`
    *   `assets/words/ethiopian_celebrities.json`
    *   `assets/words/ethiopian_history.json`
    *   `assets/words/animals.json`
    *   `assets/words/general_fun_words.json`
*   **Project Structure:** Basic Flutter project structure with `lib/main.dart` and `test/widget_test.dart`.
*   **Theming:** Initial `ThemeData` setup using `ColorScheme.fromSeed` and `GoogleFonts`. Support for light and dark themes with a toggle.

## Current Requested Change: Implement Core Features

### Plan Overview
The goal is to implement the core features of the EthioMotion Words game, including:
1.  **Word Data Models and Loading:** Create data models for categories and words, and implement logic to load them from local JSON assets.
2.  **Splash Screen:** Design and implement a splash screen with Ethiopian flag colors.
3.  **Theming:** Refine the app's theme using Ethiopian-inspired colors and Amharic-style typography.
4.  **Home Screen:** Create the main entry point for the game.
5.  **Category Selection Screen:** Allow players to choose a word category.
6.  **Gameplay Screen:** Implement the core game loop, displaying words, managing the timer, and processing motion controls.
7.  **Motion Control Logic:** Integrate `sensors_plus` to detect device tilts for correct/skip actions.
8.  **Results Screen:** Display game statistics (correct, skipped, total score).
9.  **Animations:** Add basic card slide and confetti animations.
10. **State Management:** Set up `Provider` for managing game state.

### Actionable Steps
1.  **Create Word Category JSON files:** Populate the `assets/words/` directory with the specified JSON files.
2.  **Create `lib/models/word_category.dart`:** Define a Dart class for `WordCategory` using `json_annotation`.
3.  **Implement `lib/services/word_service.dart`:** Create a service to load word categories from JSON assets.
4.  **Update `lib/main.dart`:**
    *   Implement the Splash Screen.
    *   Set up the main app widget with `ChangeNotifierProvider` for state management.
    *   Define the Ethiopian theme using `ColorScheme.fromSeed` (green, yellow, red) and `GoogleFonts`.
5.  **Create `lib/screens/splash_screen.dart`:** Implement the splash screen widget.
6.  **Create `lib/screens/home_screen.dart`:** Implement the home screen widget.
7.  **Create `lib/screens/category_selection_screen.dart`:** Implement the category selection screen widget.
8.  **Create `lib/screens/game_screen.dart`:** Implement the game screen widget, including word display, timer, and motion detection.
9.  **Create `lib/screens/results_screen.dart`:** Implement the results screen widget.
10. **Create `lib/providers/game_provider.dart`:** Implement a `ChangeNotifier` to manage the game state (current word, score, timer, etc.).
11. **Integrate Motion Sensors:** Within `GameScreen` and `GameProvider`, use `sensors_plus` to detect device tilt and update the game state accordingly.
12. **Add Animations:** Implement `ConfettiWidget` and `AnimatedSwitcher` for word transitions.
13. **Run `flutter analyze` and `flutter format .`** to ensure code quality.
14. **Test the application** to verify functionality.
