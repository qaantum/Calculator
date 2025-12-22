# Native Migration Guide

This document outlines the migration from Flutter/Dart to native Android (Kotlin) and iOS (Swift).

## Why Native?

- **Security**: Eliminate JavaScript/Dart runtime dependencies
- **Performance**: Native code runs faster and uses less memory
- **Platform Integration**: Better access to platform-specific features
- **Maintenance**: Easier to maintain platform-specific code
- **Size**: Smaller app size without Flutter framework

## Project Structure

### Android Native
Located in `android-native/`
- Kotlin with Jetpack Compose
- Material Design 3
- MVVM architecture

### iOS Native
Located in `ios-native/`
- Swift with SwiftUI
- Native iOS design patterns
- MVVM architecture

## Migration Strategy

### Phase 1: Foundation ✅
- [x] Create native project structures
- [x] Set up navigation
- [x] Create home screen
- [x] Implement standard calculator as proof of concept

### Phase 2: Core Calculators (In Progress)
- [ ] Migrate math calculators (22 calculators)
- [ ] Migrate finance calculators (35 calculators)
- [ ] Migrate health calculators (17 calculators)

### Phase 3: Specialized Calculators
- [ ] Electronics calculators (6 calculators)
- [ ] Converters (9 calculators)
- [ ] Science/Physics calculators (6 calculators)
- [ ] Text tools (6 calculators)
- [ ] Other utilities (14 calculators)

### Phase 4: Polish
- [ ] Add unit tests
- [ ] Performance optimization
- [ ] UI/UX improvements
- [ ] Remove Flutter dependencies

## Calculator Migration Pattern

Each calculator follows this pattern:

### Android (Kotlin)
1. **Calculator Logic** (`calculators/CalculatorName.kt`)
   - Pure Kotlin class with calculation logic
   - No UI dependencies

2. **UI Screen** (`ui/screens/CalculatorNameScreen.kt`)
   - Jetpack Compose UI
   - Uses ViewModel pattern

### iOS (Swift)
1. **Calculator Logic** (`Calculators/CalculatorName.swift`)
   - Pure Swift class
   - ObservableObject for state management

2. **UI View** (`Views/CalculatorNameView.swift`)
   - SwiftUI view
   - Uses @StateObject for calculator instance

## Example: Standard Calculator

See `StandardCalculator` implementation in both platforms as a reference for migrating other calculators.

## Building

### Android
```bash
cd android-native
./gradlew build
```

### iOS
Open `ios-native/CalculatorHub.xcodeproj` in Xcode and build.

## Testing

Run tests for each calculator to ensure calculations match the original Flutter implementation.

## Notes

- Calculator logic is platform-agnostic and can be shared conceptually
- UI follows platform design guidelines (Material Design for Android, Human Interface Guidelines for iOS)
- All calculations are verified against original Flutter implementation

