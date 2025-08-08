# Flutter Boilerplate

A comprehensive Flutter boilerplate project demonstrating modern app development practices with clean architecture, state management, internationalization, responsive design, and automated API client generation.

## 🚀 Features

- **Clean Architecture**: Repository pattern with MVVM architecture
- **State Management**: Riverpod for reactive state management
- **Multi-Flavor Support**: Development, Staging, and Production environments
- **Type-Safe Internationalization**: Generated LocaleKeys with Easy Localization (EN, RU, AZ)
- **Responsive Design**: Flutter ScreenUtil for adaptive layouts
- **Custom Theming**: Material 3 design with light/dark mode support
- **Type-Safe Navigation**: Go Router with enum-based route definitions
- **Form Handling**: Reactive Forms with comprehensive validation
- **API Integration**: Auto-generated Dio client from OpenAPI specification
- **Testing**: Comprehensive widget, unit, and integration tests

## 📁 Project Structure

Following Flutter's official architecture guidelines with feature-based organization:

```
lib/
├── app/                        # App-level constants and configurations
│   └── core/                   # Core app constants
│       └── constants/          # App constants
│           └── lang/           # Localization constants
│               └── locale_keys.g.dart  # Generated localization keys
├── ui/                         # Presentation layer
│   ├── core/                   # Shared UI components and theming
│   │   ├── themes/             # App theming system
│   │   │   ├── app_theme.dart          # Theme configuration
│   │   │   ├── theme_extensions.dart   # Theme utilities
│   │   │   └── theme_provider.dart     # Theme state management
│   │   └── widgets/            # Reusable UI components
│   │       └── language_selector.dart  # Language selection widget
│   └── features/               # Feature-based organization
│       ├── home/               # Home feature
│       │   ├── home_page.dart          # Home page widget
│       │   ├── widgets/                # Home-specific widgets
│       │   └── view_model/             # Home state management
│       ├── details/            # Details feature
│       │   ├── details_page.dart       # Details page widget
│       │   └── widgets/                # Details-specific widgets
│       ├── form/               # Form feature
│       │   ├── form_page.dart          # Reactive form demo
│       │   └── widgets/                # Form-specific widgets
│       └── api_demo/           # API demo feature
│           ├── api_demo_page.dart      # API integration demo
│           ├── widgets/                # API demo widgets
│           └── view_model/             # API demo state management
│               ├── user_provider.dart  # User state management
│               └── post_provider.dart  # Post state management
├── data/                       # Data layer
│   ├── repositories/           # Repository pattern implementation
│   │   ├── user_repository.dart        # User data operations
│   │   └── post_repository.dart        # Post data operations
│   └── services/               # API and external services
│       ├── api_client.dart             # Singleton API client
│       ├── api_exception.dart          # Exception handling
│       └── base_repository.dart        # Repository base class
├── config/                     # App configuration
│   ├── app/                    # App configuration
│   │   ├── app_config.dart             # Main app configuration
│   │   ├── flavor_config.dart          # Flavor configuration
│   │   └── flavor_values.dart          # Flavor-specific values
│   └── routing/                # Navigation configuration
│       ├── app_router.dart             # Go Router setup
│       └── routes_name.dart            # Type-safe route definitions
├── api/                        # API specifications
│   └── generated/              # Auto-generated API client
├── main.dart                   # Common application entry point
├── dev_application.dart        # Development flavor entry point
├── staging_application.dart    # Staging flavor entry point
└── prod_application.dart       # Production flavor entry point

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
├── generate_api.sh            # API client generation script
├── pre-commit                 # Pre-commit hook for lint checking
└── install-hooks.sh           # Hook installation script
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
- **flutter_lints**: Comprehensive linting rules (45+ rules configured)
- **integration_test**: Integration testing support

## 🌟 New Features & Improvements

### Multi-Flavor Support
The project now supports multiple build flavors for different environments:

- **Development** (`dev_application.dart`): Local development with debug features
- **Staging** (`staging_application.dart`): Pre-production testing environment  
- **Production** (`prod_application.dart`): Live production environment

Each flavor can have different configurations, API endpoints, and feature flags.

#### Running Different Flavors
```bash
# Development flavor (default)
flutter run -t lib/dev_application.dart

# Staging flavor
flutter run -t lib/staging_application.dart

# Production flavor  
flutter run -t lib/prod_application.dart
```

### Type-Safe Internationalization
Enhanced localization system with compile-time safety:

- **Generated Keys**: `LocaleKeys.home_title.tr()` instead of string literals
- **IDE Support**: Full autocomplete and refactoring support
- **Compile-time Safety**: Catch missing translations at build time
- **Nested Structure**: Organized translation keys (e.g., `form.validation.required`)

#### Usage Example
```dart
// Type-safe translation keys
Text(LocaleKeys.home_welcome.tr())
Text(LocaleKeys.form_validation_required.tr())

// Instead of error-prone strings
Text('home.welcome'.tr()) // ❌ No compile-time checking
```

### Type-Safe Navigation
Enum-based route definitions eliminate routing errors:

```dart
// Type-safe navigation
context.go(RouteNames.details.path)
context.go(RouteNames.apiDemo.path)

// Instead of string literals  
context.go('/details') // ❌ Typo-prone
```

### Enhanced Architecture
- **Flavor Configuration**: Centralized app configuration per environment
- **Generated Constants**: Auto-generated localization keys
- **Improved Structure**: Better separation of concerns with app-level constants

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

3. **Generate API client and build generated files**
   ```bash
   # Generate API client from OpenAPI spec
   ./scripts/generate_api.sh
   
   # Build generated JSON serialization files
   cd lib/api/generated && flutter packages pub run build_runner build
   cd ../../..
   ```

4. **Install pre-commit hooks** (recommended)
   ```bash
   ./scripts/install-hooks.sh
   ```

5. **Run linting and ensure code quality**
   ```bash
   flutter analyze
   ```

6. **Run the application**
   ```bash
   flutter run
   ```

## 🏗 Architecture Overview

Based on Flutter's official architecture guidelines, the project implements a layered architecture with feature-based organization:

### Architecture Layers

#### 1. **UI Layer** (`lib/ui/`)
- **Core Components** (`ui/core/`): Shared widgets, themes, and global UI state
- **Features** (`ui/features/`): Feature-specific UI components and view models
- Each feature contains: page widgets, feature-specific widgets, and view models

#### 2. **Data Layer** (`lib/data/`)
- **Repositories**: Implement the Repository pattern for data access
- **Services**: API clients, external service integrations
- **Models**: Data transfer objects and API response models

#### 3. **Domain Layer** (`lib/domain/`)
- **Models**: Business entities and domain-specific models
- **Business Logic**: Domain rules and use cases (when needed)

#### 4. **Configuration** (`lib/config/`)
- **Routing**: Navigation setup and route definitions
- **Environment**: App configuration and environment variables

### Key Patterns

#### Repository Pattern
```dart
abstract class IUserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUserById(int id);
}

class UserRepository extends BaseRepository implements IUserRepository {
  // Implementation with API calls
}
```

#### Feature-based MVVM
```dart
// Feature view model
final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UsersNotifier(repository);
});
```

#### Layer Separation
- **UI Layer**: Only UI components and view models (no business logic)
- **Data Layer**: Data access, API calls, and caching
- **Domain Layer**: Business rules and entities
- **Config Layer**: App-wide configuration and setup

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

## 🔧 Code Generation & Linting

### API Client Generation
```bash
# Generate from OpenAPI spec
./scripts/generate_api.sh

# Custom configuration
./scripts/generate_api.sh -i api/custom-spec.yaml -o lib/custom_api
```

### JSON Serialization
```bash
# Generate serialization code (run from API client directory)
cd lib/api/generated && flutter packages pub run build_runner build

# Watch for changes
cd lib/api/generated && flutter packages pub run build_runner watch
```

### Code Quality & Linting
The project includes comprehensive linting rules configured in `analysis_options.yaml`:

#### Flutter-Specific Rules
- `prefer_single_quotes`: Consistent string quoting
- `avoid_print`: Use proper logging instead of print statements
- `use_key_in_widget_constructors`: Widget performance optimization

#### Dart Quality Rules
- Type safety: `avoid_init_to_null`, `prefer_final_fields`
- Performance: `prefer_collection_literals`, `prefer_spread_collections`
- Readability: `prefer_adjacent_string_concatenation`, `slash_for_doc_comments`
- Error prevention: `unawaited_futures`, `hash_and_equals`

#### Running Lint Checks
```bash
# Analyze entire project
flutter analyze

# Auto-fix some issues
dart fix --apply

# Check specific file
flutter analyze lib/pages/home_page.dart
```

The project maintains a **99.7% lint compliance rate** with only auto-generated file warnings remaining.

### Pre-commit Hooks

The project includes a comprehensive pre-commit hook system:

#### Installation
```bash
# Install pre-commit hooks (run once per repository)
./scripts/install-hooks.sh
```

#### What the pre-commit hook does:
1. **Format Code**: Automatically runs `dart format` on staged Dart files
2. **Auto-fix Issues**: Applies `dart fix --apply` to resolve fixable lint issues
3. **Update Generated Files**: Rebuilds generated files if needed
4. **Lint Verification**: Runs `flutter analyze` and blocks commits if unfixable errors exist
5. **Re-stage Files**: Automatically adds fixed files back to staging

#### Features:
- ✅ **Only checks staged files** for fast performance
- ✅ **Colored output** with clear status messages
- ✅ **Automatic file formatting** and issue fixing
- ✅ **Generated file handling** for API clients
- ✅ **Graceful error handling** with helpful messages
- ✅ **Easy uninstallation** with backup restoration

#### Commands:
```bash
# Install hooks
./scripts/install-hooks.sh

# Uninstall hooks
./scripts/install-hooks.sh --uninstall

# View help
./scripts/install-hooks.sh --help
```

#### Manual Hook Testing:
```bash
# Test the pre-commit hook manually
./scripts/pre-commit
```

The hook ensures **100% lint compliance** before any commit reaches the repository, maintaining consistent code quality across the team.

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
- **Install pre-commit hooks**: Run `./scripts/install-hooks.sh` on first setup
- **Let hooks handle quality**: Pre-commit hooks automatically format and fix issues
- **Maintain code quality**: Hooks ensure 100% lint compliance

### Development Workflow with New Features

#### Working with Flavors
```bash
# Start development with debug features
flutter run -t lib/dev_application.dart

# Test staging configuration
flutter run -t lib/staging_application.dart --release

# Build for production
flutter build apk -t lib/prod_application.dart --release
```

#### Adding New Translations
1. **Add translations to JSON files**:
   ```json
   // assets/translations/en.json
   {
     "new_feature": {
       "title": "New Feature",
       "description": "This is a new feature"
     }
   }
   ```

2. **Generate LocaleKeys**:
   ```bash
   flutter packages pub run easy_localization:generate -S assets/translations -O lib/app/core/constants/lang
   ```

3. **Use type-safe keys**:
   ```dart
   Text(LocaleKeys.new_feature_title.tr())
   ```

#### Adding New Routes
1. **Define route in enum**:
   ```dart
   // lib/config/routing/routes_name.dart
   enum RouteNames {
     home('/'),
     newFeature('/new-feature'); // Add new route
   
     const RouteNames(this.path);
     final String path;
   }
   ```

2. **Use type-safe navigation**:
   ```dart
   context.go(RouteNames.newFeature.path)
   ```

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
cd lib/api/generated && flutter packages pub run build_runner build --delete-conflicting-outputs
cd ../../..
```

**Lint Errors**
```bash
# Check current lint status
flutter analyze

# Auto-fix some common issues
dart fix --apply

# For API client issues, regenerate files
cd lib/api/generated && flutter packages pub run build_runner clean
cd lib/api/generated && flutter packages pub run build_runner build
cd ../../..
```

**Translation Issues**
```bash
# Regenerate LocaleKeys (type-safe translation keys)
flutter packages pub run easy_localization:generate -S assets/translations -O lib/app/core/constants/lang

# Clean and regenerate if keys are missing
rm lib/app/core/constants/lang/locale_keys.g.dart
flutter packages pub run easy_localization:generate -S assets/translations -O lib/app/core/constants/lang
```

**Flavor Configuration Issues**
```bash
# Run with specific flavor if main.dart doesn't work
flutter run -t lib/dev_application.dart

# Check flavor configuration
flutter run -t lib/dev_application.dart --verbose
```

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Go Router Documentation](https://pub.dev/packages/go_router)
- [Easy Localization Guide](https://pub.dev/packages/easy_localization)
- [OpenAPI Generator](https://openapi-generator.tech/)

---

**Made with ❤️ using Flutter**