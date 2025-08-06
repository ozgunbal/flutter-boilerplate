import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_boilerplate/ui/core/themes/app_theme.dart';

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

// Test widget wrapper with all required providers and dependencies
class TestWrapper extends StatelessWidget {
  final Widget child;
  final MockGoRouter? router;
  final List<Override>? overrides;
  final ThemeMode? themeMode;
  final Locale? locale;
  
  const TestWrapper({
    super.key,
    required this.child,
    this.router,
    this.overrides,
    this.themeMode,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides ?? [],
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
            startLocale: locale,
            child: Builder(
              builder: (context) {
                return MaterialApp(
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode ?? ThemeMode.system,
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

// Simplified test wrapper for unit tests that don't need full app context
class SimpleTestWrapper extends StatelessWidget {
  final Widget child;
  final List<Override>? overrides;
  
  const SimpleTestWrapper({
    super.key,
    required this.child,
    this.overrides,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: child,
      ),
    );
  }
}

// Test utilities for common testing scenarios
class TestUtils {
  // Wait for all animations and async operations to complete
  static Future<void> pumpAndSettleWithDelay(
    WidgetTester tester, [
    Duration delay = const Duration(milliseconds: 100),
  ]) async {
    await tester.pumpAndSettle();
    await Future.delayed(delay);
    await tester.pumpAndSettle();
  }
  
  // Find button by text with case-insensitive matching
  static Finder findButtonByText(String text) {
    final elevatedButton = find.widgetWithText(ElevatedButton, text);
    final outlinedButton = find.widgetWithText(OutlinedButton, text);
    final textButton = find.widgetWithText(TextButton, text);
    
    if (elevatedButton.evaluate().isNotEmpty) return elevatedButton;
    if (outlinedButton.evaluate().isNotEmpty) return outlinedButton;
    return textButton;
  }
  
  // Find text field by label
  static Finder findTextFieldByLabel(String label) {
    final directMatch = find.widgetWithText(TextFormField, label);
    if (directMatch.evaluate().isNotEmpty) return directMatch;
    
    return find.ancestor(
      of: find.text(label),
      matching: find.byType(TextFormField),
    );
  }
  
  // Enter text in field with label
  static Future<void> enterTextInField(
    WidgetTester tester,
    String label,
    String text,
  ) async {
    final field = findTextFieldByLabel(label);
    await tester.enterText(field, text);
    await tester.pumpAndSettle();
  }
  
  // Tap button and wait for response
  static Future<void> tapButtonAndWait(
    WidgetTester tester,
    String buttonText,
  ) async {
    final button = findButtonByText(buttonText);
    await tester.tap(button);
    await pumpAndSettleWithDelay(tester);
  }
  
  // Check if snackbar with message is displayed
  static void expectSnackBarWithMessage(String message) {
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining(message), findsOneWidget);
  }
  
  // Check accessibility guidelines
  static Future<void> checkAccessibility(WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  }
  
  // Set screen size for responsive testing
  static void setScreenSize(
    WidgetTester tester,
    Size size, [
    double devicePixelRatio = 1.0,
  ]) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = devicePixelRatio;
  }
  
  // Reset screen size after responsive testing
  static void resetScreenSize(WidgetTester tester) {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }
}

// Common screen sizes for responsive testing
class TestScreenSizes {
  static const Size iphone5 = Size(320, 568);
  static const Size iphoneSE = Size(375, 667);
  static const Size iphoneX = Size(375, 812);
  static const Size iphone12Pro = Size(390, 844);
  static const Size ipadMini = Size(768, 1024);
  static const Size ipadPro = Size(1024, 1366);
  static const Size desktop = Size(1440, 900);
}

// Custom matchers for testing
class TestMatchers {
  // Check if widget has specific text style
  static Matcher hasTextStyle(TextStyle expectedStyle) {
    return predicate<Widget>((widget) {
      if (widget is Text) {
        final actualStyle = widget.style;
        return actualStyle?.fontSize == expectedStyle.fontSize &&
               actualStyle?.fontWeight == expectedStyle.fontWeight &&
               actualStyle?.color == expectedStyle.color;
      }
      return false;
    }, 'has text style matching $expectedStyle');
  }
  
  // Check if widget has specific decoration
  static Matcher hasDecoration(Decoration expectedDecoration) {
    return predicate<Widget>((widget) {
      if (widget is Container) {
        return widget.decoration == expectedDecoration;
      }
      return false;
    }, 'has decoration matching $expectedDecoration');
  }
}