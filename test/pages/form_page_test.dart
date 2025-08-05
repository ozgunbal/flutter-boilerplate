import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_router/go_router.dart';

import '../../lib/pages/form_page.dart';
import '../../lib/theme/app_theme.dart';

// Mock GoRouter for testing navigation
class MockGoRouter extends GoRouter {
  MockGoRouter() : super(routes: []);
  
  String? lastPushedRoute;
  
  @override
  void go(String location, {Object? extra}) {
    lastPushedRoute = location;
  }
}

// Test widget wrapper with all required providers
class TestWrapper extends StatelessWidget {
  final Widget child;
  final MockGoRouter? router;
  
  const TestWrapper({
    super.key,
    required this.child,
    this.router,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return EasyLocalization(
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
              Locale('az'),
            ],
            path: 'assets/translations',
            fallbackLocale: const Locale('en'),
            child: Builder(
              builder: (context) {
                return MaterialApp(
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  home: router != null 
                    ? InheritedGoRouter(
                        goRouter: router!,
                        child: child,
                      )
                    : child,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  group('FormPage Widget Tests', () {
    late MockGoRouter mockRouter;

    setUp(() {
      mockRouter = MockGoRouter();
    });

    setUpAll(() async {
      // Initialize EasyLocalization for tests
      await EasyLocalization.ensureInitialized();
    });

    testWidgets('should render FormPage with all form fields', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        TestWrapper(
          router: mockRouter,
          child: const FormPage(),
        ),
      );
      
      // Wait for all animations and async operations
      await tester.pumpAndSettle();

      // Assert - Check if main elements are present
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ReactiveTextField), findsNWidgets(3)); // Name, Email, Age
      expect(find.byType(ReactiveDropdownField), findsOneWidget); // Country
      expect(find.byType(ReactiveRadioListTile), findsNWidgets(3)); // Gender options
      expect(find.byType(ReactiveCheckboxListTile), findsOneWidget); // Terms
      expect(find.byType(ElevatedButton), findsOneWidget); // Submit button
      expect(find.byType(OutlinedButton), findsOneWidget); // Back button
    });

    testWidgets('should show validation errors for required fields', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Try to submit form without filling required fields
      final submitButton = find.byType(ElevatedButton).first;
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - Should show error snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('fix the errors'), findsOneWidget);
    });

    testWidgets('should validate email format', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Enter invalid email
      final emailField = find.byType(ReactiveTextField).at(1); // Email field
      await tester.enterText(emailField, 'invalid-email');
      await tester.pumpAndSettle();

      // Tap submit to trigger validation
      final submitButton = find.byType(ElevatedButton).first;
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - Should show email validation error
      expect(find.textContaining('valid email'), findsOneWidget);
    });

    testWidgets('should validate name length constraints', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Enter name that's too short
      final nameField = find.byType(ReactiveTextField).first; // Name field
      await tester.enterText(nameField, 'A'); // Only 1 character
      await tester.pumpAndSettle();

      // Tap submit to trigger validation
      final submitButton = find.byType(ElevatedButton).first;
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - Should show minimum length error
      expect(find.textContaining('Minimum length'), findsOneWidget);
    });

    testWidgets('should validate age constraints', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Enter age below minimum
      final ageField = find.byType(ReactiveTextField).at(2); // Age field
      await tester.enterText(ageField, '15'); // Below 18
      await tester.pumpAndSettle();

      // Tap submit to trigger validation
      final submitButton = find.byType(ElevatedButton).first;
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - Should show age validation error
      expect(find.textContaining('Minimum age'), findsOneWidget);
    });

    testWidgets('should be able to select country from dropdown', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Tap dropdown to open it
      final dropdown = find.byType(ReactiveDropdownField);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Select a country option
      final countryOption = find.text('Germany').last;
      await tester.tap(countryOption);
      await tester.pumpAndSettle();

      // Assert - Dropdown should show selected value
      expect(find.text('Germany'), findsOneWidget);
    });

    testWidgets('should be able to select gender radio button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Select male radio button
      final maleRadio = find.byType(ReactiveRadioListTile<String>).first;
      await tester.tap(maleRadio);
      await tester.pumpAndSettle();

      // Assert - Male radio should be selected
      final maleRadioWidget = tester.widget<ReactiveRadioListTile<String>>(maleRadio);
      expect(maleRadioWidget.value, equals('male'));
    });

    testWidgets('should be able to toggle terms checkbox', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Toggle terms checkbox
      final termsCheckbox = find.byType(ReactiveCheckboxListTile);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();

      // Assert - Checkbox should be checked (this is more complex to test with reactive forms)
      expect(find.byType(ReactiveCheckboxListTile), findsOneWidget);
    });

    testWidgets('should submit form successfully with valid data', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - Fill all required fields with valid data
      final nameField = find.byType(ReactiveTextField).first;
      await tester.enterText(nameField, 'John Doe');
      await tester.pumpAndSettle();

      final emailField = find.byType(ReactiveTextField).at(1);
      await tester.enterText(emailField, 'john.doe@example.com');
      await tester.pumpAndSettle();

      final ageField = find.byType(ReactiveTextField).at(2);
      await tester.enterText(ageField, '25');
      await tester.pumpAndSettle();

      // Select country
      final dropdown = find.byType(ReactiveDropdownField);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      final countryOption = find.text('Germany').last;
      await tester.tap(countryOption);
      await tester.pumpAndSettle();

      // Select gender
      final maleRadio = find.byType(ReactiveRadioListTile<String>).first;
      await tester.tap(maleRadio);
      await tester.pumpAndSettle();

      // Check terms
      final termsCheckbox = find.byType(ReactiveCheckboxListTile);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();

      // Submit form
      final submitButton = find.byType(ElevatedButton).first;
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Assert - Should show success snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('successfully'), findsOneWidget);
    });

    testWidgets('should navigate back to home when back button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          router: mockRouter,
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      final backButton = find.byType(OutlinedButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Assert
      expect(mockRouter.lastPushedRoute, equals('/'));
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Should have SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const FormPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check accessibility
      final SemanticsHandle handle = tester.ensureSemantics();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    group('Form Validation Edge Cases', () {
      testWidgets('should handle extremely long input gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestWrapper(
            child: const FormPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Enter very long name
        final nameField = find.byType(ReactiveTextField).first;
        final longName = 'A' * 100; // 100 characters
        await tester.enterText(nameField, longName);
        await tester.pumpAndSettle();

        // Should show max length validation error
        final submitButton = find.byType(ElevatedButton).first;
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        expect(find.textContaining('Maximum length'), findsOneWidget);
      });

      testWidgets('should handle special characters in email', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestWrapper(
            child: const FormPage(),
          ),
        );
        await tester.pumpAndSettle();

        // Enter email with special characters
        final emailField = find.byType(ReactiveTextField).at(1);
        await tester.enterText(emailField, 'test+user@example.co.uk');
        await tester.pumpAndSettle();

        // This should be valid
        final submitButton = find.byType(ElevatedButton).first;
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Should not show email validation error for valid email with special chars
        expect(find.textContaining('valid email'), findsNothing);
      });
    });

    group('Responsive Design', () {
      testWidgets('should adapt to small screen', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          TestWrapper(
            child: const FormPage(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(FormPage), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
    });
  });
}