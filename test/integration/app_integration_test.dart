import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_boilerplate/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    setUpAll(() async {
      // Initialize EasyLocalization for integration tests
      await EasyLocalization.ensureInitialized();
    });

    testWidgets('complete app navigation flow', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        ProviderScope(
          child: EasyLocalization(
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
              Locale('az'),
            ],
            path: 'assets/translations',
            fallbackLocale: const Locale('en'),
            child: const MyApp(),
          ),
        ),
      );

      // Wait for the app to fully load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're on the home page
      expect(find.text('Welcome to the Home Page!'), findsOneWidget);
      expect(find.text('Go to Details'), findsOneWidget);
      expect(find.text('Go to Form'), findsOneWidget);
      expect(find.text('API Demo'), findsOneWidget);

      // Test theme toggle
      final themeButton = find.byIcon(Icons.brightness_auto);
      if (themeButton.evaluate().isNotEmpty) {
        await tester.tap(themeButton);
        await tester.pumpAndSettle();
        
        // Should now show light mode icon (switched to light mode)
        expect(find.byIcon(Icons.dark_mode), findsOneWidget);
      }

      // Navigate to Details page
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();

      // Verify we're on the details page
      expect(find.text('This is the Details Page!'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);

      // Navigate back to home
      await tester.tap(find.text('Back to Home'));
      await tester.pumpAndSettle();

      // Verify we're back on home page
      expect(find.text('Welcome to the Home Page!'), findsOneWidget);

      // Navigate to Form page
      await tester.tap(find.text('Go to Form'));
      await tester.pumpAndSettle();

      // Verify we're on the form page
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);

      // Fill out the form with valid data
      await tester.enterText(find.byType(TextFormField).first, 'Integration Test User');
      await tester.pumpAndSettle();

      // Find email field (second TextFormField)
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(1), 'test@integration.com');
      await tester.pumpAndSettle();

      // Find age field (third TextFormField)
      await tester.enterText(textFields.at(2), '25');
      await tester.pumpAndSettle();

      // Select country from dropdown
      await tester.tap(find.text('Country'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Germany').last);
      await tester.pumpAndSettle();

      // Select gender radio button
      await tester.tap(find.text('Male'));
      await tester.pumpAndSettle();

      // Check terms checkbox
      await tester.tap(find.text('I agree to the terms and conditions'));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify success message (snackbar)
      expect(find.textContaining('successfully'), findsOneWidget);

      // Wait for snackbar to disappear
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate back to home
      await tester.tap(find.text('Back to Home'));
      await tester.pumpAndSettle();

      // Navigate to API Demo page
      await tester.tap(find.text('API Demo'));
      await tester.pumpAndSettle();

      // Wait for API calls to complete
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify we're on the API demo page
      expect(find.text('Users'), findsOneWidget);
      expect(find.text('Posts'), findsOneWidget);

      // Check if users are loaded (this might fail if no internet connection)
      final userCards = find.byType(Card);
      if (userCards.evaluate().isNotEmpty) {
        // Tap on a user to view their posts
        await tester.tap(userCards.first);
        await tester.pumpAndSettle();

        // Switch to Posts tab
        await tester.tap(find.text('Posts'));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Should show posts for the selected user
        expect(find.textContaining('Posts by User'), findsOneWidget);
      }

      // Navigate back to home using floating action button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify we're back on home page
      expect(find.text('Welcome to the Home Page!'), findsOneWidget);
    });

    testWidgets('form validation integration test', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        ProviderScope(
          child: EasyLocalization(
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
              Locale('az'),
            ],
            path: 'assets/translations',
            fallbackLocale: const Locale('en'),
            child: const MyApp(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to Form page
      await tester.tap(find.text('Go to Form'));
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.textContaining('fix the errors'), findsOneWidget);

      // Wait for error message to disappear
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Fill name field with too short value
      await tester.enterText(find.byType(TextFormField).first, 'A');
      await tester.pumpAndSettle();

      // Try to submit
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Should show minimum length error
      expect(find.textContaining('Minimum length'), findsOneWidget);

      // Fill with valid name
      await tester.enterText(find.byType(TextFormField).first, 'Valid Name');
      await tester.pumpAndSettle();

      // Fill email with invalid format
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(1), 'invalid-email');
      await tester.pumpAndSettle();

      // Try to submit
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Should show email validation error
      expect(find.textContaining('valid email'), findsOneWidget);
    });

    testWidgets('theme persistence integration test', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        ProviderScope(
          child: EasyLocalization(
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
              Locale('az'),
            ],
            path: 'assets/translations',
            fallbackLocale: const Locale('en'),
            child: const MyApp(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Toggle theme multiple times
      final themeButton = find.byType(IconButton).first;
      
      // Initial state should be system mode
      expect(find.byIcon(Icons.brightness_auto), findsOneWidget);

      // Toggle to light mode
      await tester.tap(themeButton);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);

      // Toggle to dark mode
      await tester.tap(themeButton);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.light_mode), findsOneWidget);

      // Toggle back to system mode
      await tester.tap(themeButton);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.brightness_auto), findsOneWidget);

      // Navigate to different pages and verify theme persists
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();
      
      // Theme should still be system mode
      expect(find.byIcon(Icons.brightness_auto), findsOneWidget);
    });

    testWidgets('responsive design integration test', (WidgetTester tester) async {
      // Test with different screen sizes
      final sizes = [
        const Size(320, 568), // iPhone 5
        const Size(375, 812), // iPhone X
        const Size(768, 1024), // iPad
      ];

      for (final size in sizes) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: EasyLocalization(
              supportedLocales: const [
                Locale('en'),
                Locale('ru'),
                Locale('az'),
              ],
              path: 'assets/translations',
              fallbackLocale: const Locale('en'),
              child: const MyApp(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify app loads correctly on different screen sizes
        expect(find.text('Welcome to the Home Page!'), findsOneWidget);
        expect(find.text('Go to Details'), findsOneWidget);
        expect(find.text('Go to Form'), findsOneWidget);
        expect(find.text('API Demo'), findsOneWidget);

        // Navigate to form page to test responsive form layout
        await tester.tap(find.text('Go to Form'));
        await tester.pumpAndSettle();

        // Verify form elements are present and accessible
        expect(find.text('Name'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Submit'), findsOneWidget);

        // Navigate back to home
        await tester.tap(find.text('Back to Home'));
        await tester.pumpAndSettle();
      }

      // Reset screen size
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });
  });
}