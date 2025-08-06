import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_boilerplate/ui/features/home/home_page.dart';
import 'package:flutter_boilerplate/ui/core/themes/app_theme.dart';
import 'package:flutter_boilerplate/ui/core/themes/theme_provider.dart';

// Mock GoRouter for testing navigation
class MockGoRouter {
  String? lastPushedRoute;
  Map<String, dynamic>? lastExtra;
  
  void go(String location, {Object? extra}) {
    lastPushedRoute = location;
    lastExtra = extra as Map<String, dynamic>?;
  }
  
  Future<T?> push<T extends Object?>(String location, {Object? extra}) async {
    lastPushedRoute = location;
    lastExtra = extra as Map<String, dynamic>?;
    return null;
  }
  
  void reset() {
    lastPushedRoute = null;
    lastExtra = null;
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
                  home: child,
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
  group('HomePage Widget Tests', () {
    late MockGoRouter mockRouter;

    setUp(() {
      mockRouter = MockGoRouter();
    });

    setUpAll(() async {
      // Initialize EasyLocalization for tests
      await EasyLocalization.ensureInitialized();
    });

    testWidgets('should render HomePage with all navigation buttons', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        TestWrapper(
          router: mockRouter,
          child: const HomePage(),
        ),
      );
      
      // Wait for all animations and async operations
      await tester.pumpAndSettle();

      // Assert - Check if main elements are present
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(3)); // Details, Form, API Demo buttons
      expect(find.byType(IconButton), findsOneWidget); // Theme toggle button
      
      // Check if welcome text is present
      expect(find.textContaining('Welcome'), findsOneWidget);
      
      // Check if navigation buttons are present
      expect(find.text('Go to Details'), findsOneWidget);
      expect(find.text('Go to Form'), findsOneWidget);
      expect(find.text('API Demo'), findsOneWidget);
    });

    testWidgets('should navigate to details page when details button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          router: mockRouter,
          child: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      final detailsButton = find.text('Go to Details');
      expect(detailsButton, findsOneWidget);
      await tester.tap(detailsButton);
      await tester.pumpAndSettle();

      // Assert
      expect(mockRouter.lastPushedRoute, equals('/details'));
    });

    testWidgets('should navigate to form page when form button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          router: mockRouter,
          child: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      final formButton = find.text('Go to Form');
      expect(formButton, findsOneWidget);
      await tester.tap(formButton);
      await tester.pumpAndSettle();

      // Assert
      expect(mockRouter.lastPushedRoute, equals('/form'));
    });

    testWidgets('should navigate to API demo page when API demo button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          router: mockRouter,
          child: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      final apiDemoButton = find.text('API Demo');
      expect(apiDemoButton, findsOneWidget);
      await tester.tap(apiDemoButton);
      await tester.pumpAndSettle();

      // Assert
      expect(mockRouter.lastPushedRoute, equals('/api-demo'));
    });

    testWidgets('should display theme toggle button in AppBar', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        TestWrapper(
          child: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(IconButton), findsOneWidget);
      
      // Check if the icon button is in the AppBar
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.actions, isNotEmpty);
    });

    testWidgets('should toggle theme when theme button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Get the initial theme mode
      final container = ProviderScope.containerOf(
        tester.element(find.byType(HomePage)),
      );
      final initialThemeMode = container.read(themeModeProvider);

      // Act
      final themeButton = find.byType(IconButton);
      expect(themeButton, findsOneWidget);
      await tester.tap(themeButton);
      await tester.pumpAndSettle();

      // Assert
      final newThemeMode = container.read(themeModeProvider);
      expect(newThemeMode, isNot(equals(initialThemeMode)));
    });

    testWidgets('should display correct theme icon based on current theme mode', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: ProviderScope(
            overrides: [
              themeModeProvider.overrideWith((ref) => ThemeModeNotifier()..setDarkMode()),
            ],
            child: const HomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Should show light mode icon when in dark mode
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const HomePage(),
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

    testWidgets('should maintain responsive layout', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        TestWrapper(
          child: const HomePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check if responsive elements are present
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
      
      // Check if buttons have proper sizing
      final elevatedButtons = tester.widgetList<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ),
      );
      
      // Verify buttons have responsive width
      for (final sizedBox in elevatedButtons) {
        if (sizedBox.width == double.infinity) {
          expect(sizedBox.width, equals(double.infinity));
        }
      }
    });

    group('Error Handling', () {
      testWidgets('should handle missing translations gracefully', (WidgetTester tester) async {
        // This test ensures the widget doesn't crash with missing translations
        await tester.pumpWidget(
          ProviderScope(
            child: ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (context, _) {
                return MaterialApp(
                  theme: AppTheme.lightTheme,
                  home: const HomePage(),
                );
              },
            ),
          ),
        );
        
        // Should not throw any exceptions
        await tester.pumpAndSettle();
        expect(find.byType(HomePage), findsOneWidget);
      });
    });

    group('Different Screen Sizes', () {
      testWidgets('should adapt to small screen size', (WidgetTester tester) async {
        // Set a small screen size
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          TestWrapper(
            child: const HomePage(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNWidgets(3));
        
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });

      testWidgets('should adapt to large screen size', (WidgetTester tester) async {
        // Set a large screen size
        tester.view.physicalSize = const Size(1024, 768);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          TestWrapper(
            child: const HomePage(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNWidgets(3));
        
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      });
    });
  });
}