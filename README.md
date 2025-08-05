# Flutter Boilerplate

A comprehensive Flutter boilerplate project demonstrating modern app development practices with clean architecture, state management, internationalization, responsive design, and automated API client generation.

## 🚀 Features

- **Clean Architecture**: Repository pattern with MVVM architecture
- **State Management**: Riverpod for reactive state management
- **Internationalization**: Easy Localization with 3 languages (EN, RU, AZ)
- **Responsive Design**: Flutter ScreenUtil for adaptive layouts
- **Custom Theming**: Material 3 design with light/dark mode support
- **Navigation**: Go Router for declarative navigation
- **Form Handling**: Reactive Forms with comprehensive validation
- **API Integration**: Auto-generated Dio client from OpenAPI specification
- **Testing**: Comprehensive widget, unit, and integration tests

## 📁 Project Structure

```
lib/
├── api/                        # API specifications and generated clients
│   └── generated/              # Auto-generated API client from OpenAPI
├── core/                       # Core functionality and utilities
│   └── api/                    # Base API classes and error handling
│       ├── api_client.dart     # Singleton API client with Dio
│       ├── api_exception.dart  # Custom exception handling
│       └── base_repository.dart # Abstract repository base class
├── navigation/                 # App routing configuration
│   └── app_router.dart         # Go Router setup and routes
├── pages/                      # UI screens/pages
│   ├── home_page.dart          # Home page with navigation
│   ├── details_page.dart       # Details page
│   ├── form_page.dart          # Reactive form demonstration
│   └── api_demo_page.dart      # API integration demo
├── providers/                  # Riverpod state management
│   ├── theme_provider.dart     # Theme mode management
│   ├── user_provider.dart      # User state management
│   └── post_provider.dart      # Post state management
├── repositories/               # Data layer with repository pattern
│   ├── user_repository.dart    # User data operations
│   └── post_repository.dart    # Post data operations
└── theme/                      # App theming and styling
    ├── app_theme.dart          # Theme configuration
    └── theme_extensions.dart   # Theme utility extensions

test/                           # Test suite
├── integration/                # Integration tests
├── pages/                      # Widget tests for pages
├── providers/                  # Unit tests for providers
└── test_helpers/               # Test utilities and helpers

assets/
└── translations/               # Internationalization files
    ├── en.json                 # English translations
    ├── ru.json                 # Russian translations
    └── az.json                 # Azerbaijani translations

api/                           # API specifications
├── openapi.json               # OpenAPI 3.0 specification
└── openapi-config.json        # Generator configuration

scripts/
└── generate_api.sh            # API client generation script
```

## 📦 Dependencies

### Core Dependencies
- **flutter**: SDK for building natively compiled applications
- **flutter_riverpod**: Reactive state management solution
- **go_router**: Declarative routing solution
- **easy_localization**: Internationalization and localization
- **flutter_screenutil**: Responsive design utilities
- **reactive_forms**: Reactive form handling with validation
- **dio**: HTTP client for API communication

### Generated Dependencies
- **json_annotation**: JSON serialization annotations
- **json_serializable**: Code generation for JSON serialization
- **build_runner**: Code generation tool

### Development Dependencies
- **flutter_test**: Testing framework
- **flutter_lints**: Recommended linting rules
- **integration_test**: Integration testing support

## 🛠 Setup and Installation

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Java 8+ (for OpenAPI generator)
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_boilerplate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate API client** (optional)
   ```bash
   ./scripts/generate_api.sh
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 🏗 Architecture Overview

### Repository Pattern
The app implements the Repository pattern to separate data logic from business logic:

```dart
abstract class IUserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUserById(int id);
  // ... other methods
}

class UserRepository extends BaseRepository implements IUserRepository {
  // Implementation with API calls
}
```

### MVVM with Riverpod
View Models are implemented as Riverpod providers:

```dart
final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UsersNotifier(repository);
});
```

### State Management
- **Theme Management**: Global theme state with system/light/dark modes
- **Form State**: Reactive forms with real-time validation
- **API State**: Loading, error, and success states for API calls

## 🌍 Internationalization

The app supports 3 languages with Easy Localization:

- **English (en)**: Default language
- **Russian (ru)**: Cyrillic support
- **Azerbaijani (az)**: Latin script

Translation files are located in `assets/translations/` and follow a hierarchical structure:

```json
{
  "home": {
    "title": "Home",
    "welcome": "Welcome to the Home Page!"
  }
}
```

Usage in code:
```dart
Text('home.title'.tr())
```

## 🎨 Theming

The app implements Material 3 design with:

- **Light Theme**: Modern light color scheme
- **Dark Theme**: OLED-friendly dark colors
- **System Theme**: Follows device theme settings
- **Custom Components**: Styled buttons, forms, and cards

Theme switching is managed through Riverpod:
```dart
ref.read(themeModeProvider.notifier).toggleTheme();
```

## 📱 Responsive Design

Flutter ScreenUtil ensures consistent layouts across devices:

- **Design Base**: 375x812 (iPhone X)
- **Adaptive Sizing**: `.w`, `.h`, `.sp` extensions
- **Screen Support**: Phones, tablets, and foldables

Example usage:
```dart
Container(
  width: 200.w,          // Responsive width
  height: 100.h,         // Responsive height
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16.sp), // Responsive font
  ),
)
```

## 🔗 API Integration

### OpenAPI Code Generation

The project uses OpenAPI Generator to create type-safe API clients:

1. **Define API**: Create/update `api/openapi.json`
2. **Generate Client**: Run `./scripts/generate_api.sh`
3. **Use in Repository**: Inject generated client

### Example API Usage

```dart
class UserRepository extends BaseRepository implements IUserRepository {
  late final UsersApi _usersApi;
  
  @override
  Future<List<User>> getUsers() async {
    return handleApiCall(() async {
      final response = await _usersApi.getUsers();
      return extractListData<User>(response);
    });
  }
}
```

## 📝 Form Handling

Reactive Forms provide powerful form management:

### Features
- **Real-time Validation**: Immediate feedback
- **Type Safety**: Strongly typed form controls
- **Complex Validation**: Custom validators and rules
- **Accessibility**: Screen reader support

### Example Form Control
```dart
FormGroup buildForm() => fb.group({
  'email': FormControl<String>(
    validators: [Validators.required, Validators.email],
  ),
  'age': FormControl<int>(
    validators: [Validators.min(18), Validators.max(100)],
  ),
});
```

## 🧪 Testing

Comprehensive testing strategy covering:

### Widget Tests
- **UI Interactions**: Button taps, form input
- **Navigation**: Route transitions and state
- **Responsive**: Multiple screen sizes
- **Accessibility**: Screen reader compliance

### Unit Tests
- **State Management**: Provider logic and state changes
- **Business Logic**: Repository and service methods
- **Utilities**: Helper functions and extensions

### Integration Tests
- **User Flows**: Complete user journeys
- **API Integration**: Real network requests
- **State Persistence**: Data consistency

### Running Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/pages/home_page_test.dart

# Integration tests
flutter test test/integration/

# With coverage
flutter test --coverage
```

## 🔧 Code Generation

### API Client Generation
```bash
# Generate from OpenAPI spec
./scripts/generate_api.sh

# Custom configuration
./scripts/generate_api.sh -i api/custom-spec.yaml -o lib/custom_api
```

### JSON Serialization
```bash
# Generate serialization code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

## 🚀 Building and Deployment

### Development Build
```bash
flutter run --debug
```

### Release Build
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📊 Performance Optimization

- **Tree Shaking**: Unused code elimination
- **Image Optimization**: Responsive image loading
- **State Management**: Efficient rebuilds with Riverpod
- **Lazy Loading**: On-demand widget creation
- **Caching**: API response caching

## 🔒 Security Considerations

- **API Security**: Token-based authentication support
- **Input Validation**: Client and server-side validation
- **Error Handling**: Secure error messages
- **Dependencies**: Regular security audits

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart style guide
- Write tests for new features
- Update documentation
- Use conventional commits

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Troubleshooting

### Common Issues

**API Generation Fails**
```bash
# Check Java installation
java -version

# Download generator manually
./scripts/generate_api.sh --download-only
```

**Build Errors**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Translation Issues**
```bash
# Regenerate translation files
flutter packages pub run easy_localization:generate -S assets/translations
```

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Go Router Documentation](https://pub.dev/packages/go_router)
- [Easy Localization Guide](https://pub.dev/packages/easy_localization)
- [OpenAPI Generator](https://openapi-generator.tech/)

---

**Made with ❤️ using Flutter**