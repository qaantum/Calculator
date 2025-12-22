# Calculator Hub - Native iOS (Swift)

This is the native iOS version of Calculator Hub, built with Swift and SwiftUI.

## Project Structure

```
ios-native/
└── CalculatorHub/
    ├── CalculatorHubApp.swift      # App entry point
    ├── ContentView.swift           # Root view
    ├── Models/
    │   └── CalculatorItem.swift    # Calculator model
    ├── Data/
    │   └── CalculatorData.swift   # Calculator data
    ├── Views/
    │   ├── HomeView.swift          # Home screen
    │   └── StandardCalculatorView.swift
    └── Calculators/
        └── StandardCalculator.swift # Calculator logic
```

## Features

- **100% Native Swift**: No Flutter/Dart dependencies
- **SwiftUI**: Modern declarative UI framework
- **MVVM Architecture**: Clean architecture pattern
- **iOS 15+**: Supports latest iOS features

## Building

1. Open `CalculatorHub.xcodeproj` in Xcode
2. Select a simulator or device
3. Build and run (⌘R)

## Migration Status

- ✅ Project structure created
- ✅ Basic navigation setup
- ✅ Home screen with calculator list
- ✅ Standard calculator implemented
- ⏳ Migrating remaining calculators (100+ calculators)

## Next Steps

1. Migrate calculator logic from Dart to Swift
2. Create UI views for each calculator
3. Add unit tests
4. Optimize performance

