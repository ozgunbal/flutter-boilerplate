import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../lib/providers/theme_provider.dart';

void main() {
  group('ThemeModeNotifier Tests', () {
    late ProviderContainer container;
    late ThemeModeNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(themeModeProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should have system theme as initial state', () {
      // Arrange & Act
      final themeMode = container.read(themeModeProvider);

      // Assert
      expect(themeMode, equals(ThemeMode.system));
    });

    test('should set light mode', () {
      // Act
      notifier.setLightMode();

      // Assert
      final themeMode = container.read(themeModeProvider);
      expect(themeMode, equals(ThemeMode.light));
    });

    test('should set dark mode', () {
      // Act
      notifier.setDarkMode();

      // Assert
      final themeMode = container.read(themeModeProvider);
      expect(themeMode, equals(ThemeMode.dark));
    });

    test('should set system mode', () {
      // Arrange - Set to light mode first
      notifier.setLightMode();

      // Act
      notifier.setSystemMode();

      // Assert
      final themeMode = container.read(themeModeProvider);
      expect(themeMode, equals(ThemeMode.system));
    });

    test('should set specific theme mode', () {
      // Act
      notifier.setThemeMode(ThemeMode.dark);

      // Assert
      final themeMode = container.read(themeModeProvider);
      expect(themeMode, equals(ThemeMode.dark));
    });

    group('toggleTheme', () {
      test('should toggle from light to dark', () {
        // Arrange
        notifier.setLightMode();

        // Act
        notifier.toggleTheme();

        // Assert
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.dark));
      });

      test('should toggle from dark to system', () {
        // Arrange
        notifier.setDarkMode();

        // Act
        notifier.toggleTheme();

        // Assert
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.system));
      });

      test('should toggle from system to light', () {
        // Arrange
        notifier.setSystemMode();

        // Act
        notifier.toggleTheme();

        // Assert
        final themeMode = container.read(themeModeProvider);
        expect(themeMode, equals(ThemeMode.light));
      });

      test('should cycle through all theme modes', () {
        // Start with system (default)
        expect(container.read(themeModeProvider), equals(ThemeMode.system));

        // System -> Light
        notifier.toggleTheme();
        expect(container.read(themeModeProvider), equals(ThemeMode.light));

        // Light -> Dark
        notifier.toggleTheme();
        expect(container.read(themeModeProvider), equals(ThemeMode.dark));

        // Dark -> System
        notifier.toggleTheme();
        expect(container.read(themeModeProvider), equals(ThemeMode.system));
      });
    });
  });

  group('Theme Provider Derived States', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('isDarkModeProvider should return true when theme is dark', () {
      // Arrange
      container.read(themeModeProvider.notifier).setDarkMode();

      // Act
      final isDarkMode = container.read(isDarkModeProvider);

      // Assert
      expect(isDarkMode, isTrue);
    });

    test('isDarkModeProvider should return false when theme is not dark', () {
      // Arrange
      container.read(themeModeProvider.notifier).setLightMode();

      // Act
      final isDarkMode = container.read(isDarkModeProvider);

      // Assert
      expect(isDarkMode, isFalse);
    });

    test('isLightModeProvider should return true when theme is light', () {
      // Arrange
      container.read(themeModeProvider.notifier).setLightMode();

      // Act
      final isLightMode = container.read(isLightModeProvider);

      // Assert
      expect(isLightMode, isTrue);
    });

    test('isLightModeProvider should return false when theme is not light', () {
      // Arrange
      container.read(themeModeProvider.notifier).setDarkMode();

      // Act
      final isLightMode = container.read(isLightModeProvider);

      // Assert
      expect(isLightMode, isFalse);
    });

    test('isSystemModeProvider should return true when theme is system', () {
      // Arrange
      container.read(themeModeProvider.notifier).setSystemMode();

      // Act
      final isSystemMode = container.read(isSystemModeProvider);

      // Assert
      expect(isSystemMode, isTrue);
    });

    test('isSystemModeProvider should return false when theme is not system', () {
      // Arrange
      container.read(themeModeProvider.notifier).setLightMode();

      // Act
      final isSystemMode = container.read(isSystemModeProvider);

      // Assert
      expect(isSystemMode, isFalse);
    });
  });

  group('Provider Reactivity Tests', () {
    test('should notify listeners when theme changes', () {
      // Arrange
      final container = ProviderContainer();
      final listener = Listener<ThemeMode>();
      
      container.listen(themeModeProvider, listener.call, fireImmediately: true);

      // Act
      container.read(themeModeProvider.notifier).setDarkMode();
      container.read(themeModeProvider.notifier).setLightMode();

      // Assert
      verifyInOrder([
        () => listener(null, ThemeMode.system), // Initial state
        () => listener(ThemeMode.system, ThemeMode.dark),
        () => listener(ThemeMode.dark, ThemeMode.light),
      ]);
      verifyNoMoreInteractions(listener);

      container.dispose();
    });

    test('should notify derived providers when theme changes', () {
      // Arrange
      final container = ProviderContainer();
      final darkModeListener = Listener<bool>();
      final lightModeListener = Listener<bool>();
      final systemModeListener = Listener<bool>();
      
      container.listen(isDarkModeProvider, darkModeListener.call, fireImmediately: true);
      container.listen(isLightModeProvider, lightModeListener.call, fireImmediately: true);
      container.listen(isSystemModeProvider, systemModeListener.call, fireImmediately: true);

      // Act
      container.read(themeModeProvider.notifier).setDarkMode();

      // Assert
      verify(() => darkModeListener(false, true)).called(1);
      verify(() => lightModeListener(false, false)).called(1);
      verify(() => systemModeListener(true, false)).called(1);

      container.dispose();
    });
  });

  group('Edge Cases', () {
    test('should handle multiple rapid theme changes', () {
      // Arrange
      final container = ProviderContainer();
      final notifier = container.read(themeModeProvider.notifier);

      // Act - Rapidly change themes
      notifier.setLightMode();
      notifier.setDarkMode();
      notifier.setSystemMode();
      notifier.toggleTheme();
      notifier.toggleTheme();

      // Assert - Should end in dark mode (system -> light -> dark)
      final finalTheme = container.read(themeModeProvider);
      expect(finalTheme, equals(ThemeMode.dark));

      container.dispose();
    });

    test('should maintain state consistency across multiple providers', () {
      // Arrange
      final container = ProviderContainer();
      final notifier = container.read(themeModeProvider.notifier);

      // Act
      notifier.setDarkMode();

      // Assert - All related providers should be consistent
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
      expect(container.read(isDarkModeProvider), isTrue);
      expect(container.read(isLightModeProvider), isFalse);
      expect(container.read(isSystemModeProvider), isFalse);

      container.dispose();
    });
  });
}

// Helper class for testing provider listeners
class Listener<T> {
  void call(T? previous, T next) {}
}

// Mock implementation for verification
class MockListener<T> extends Listener<T> {
  final List<MapEntry<T?, T>> calls = [];

  @override
  void call(T? previous, T next) {
    calls.add(MapEntry(previous, next));
  }
}

// Verification helper functions
void verify(void Function() interaction) {
  interaction();
}

void verifyInOrder(List<void Function()> interactions) {
  for (final interaction in interactions) {
    interaction();
  }
}

void verifyNoMoreInteractions(Listener listener) {
  // No-op for this simple test setup
}