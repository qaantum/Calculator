import SwiftUI

enum ThemeOption: String, CaseIterable, Identifiable {
    case light
    case dark
    case system

    var id: String { rawValue }

    var title: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }

    var description: String {
        switch self {
        case .light: return "Use a bright appearance ideal for well-lit environments."
        case .dark: return "Reduce eye strain with a dark, OLED-friendly theme."
        case .system: return "Automatically follow your device's appearance setting."
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

struct CryptatextPalette {
    let background: Color
    let foreground: Color
    let card: Color
    let primary: Color
    let onPrimary: Color
    let secondary: Color
    let onSecondary: Color
    let input: Color
    let border: Color
    let success: Color
    let warning: Color
    let destructive: Color
    let info: Color
    let muted: Color
    let mutedForeground: Color

    static let light = CryptatextPalette(
        background: Color(hex: 0xF5F7F8),
        foreground: Color(hex: 0x2D3A47),
        card: Color.white,
        primary: Color(hex: 0x2D3A47),
        onPrimary: Color(hex: 0xFAFAFA),
        secondary: Color(hex: 0xF4F5F7),
        onSecondary: Color(hex: 0x2D3A47),
        input: Color(hex: 0xEEF0F2),
        border: Color(hex: 0xE1E4E8),
        success: Color(hex: 0x28A745),
        warning: Color(hex: 0xE5A50A),
        destructive: Color(hex: 0xF44336),
        info: Color(hex: 0x1E88E5),
        muted: Color(hex: 0xEFF1F4),
        mutedForeground: Color(hex: 0x596677)
    )

    static let dark = CryptatextPalette(
        background: Color(hex: 0x111820),
        foreground: Color(hex: 0xDDE1E6),
        card: Color(hex: 0x1A242E),
        primary: Color(hex: 0xB3FFF3),
        onPrimary: Color(hex: 0x111820),
        secondary: Color(hex: 0x243240),
        onSecondary: Color(hex: 0xDDE1E6),
        input: Color(hex: 0x293947),
        border: Color(hex: 0x243240),
        success: Color(hex: 0x218838),
        warning: Color(hex: 0xF0A30A),
        destructive: Color(hex: 0xD32F2F),
        info: Color(hex: 0x64B5F6),
        muted: Color(hex: 0x1F2A36),
        mutedForeground: Color(hex: 0x9BA7B4)
    )

    static func palette(for colorScheme: ColorScheme) -> CryptatextPalette {
        colorScheme == .dark ? .dark : .light
    }
}

private struct CryptatextPaletteKey: EnvironmentKey {
    static let defaultValue: CryptatextPalette = .light
}

extension EnvironmentValues {
    var cryptatextPalette: CryptatextPalette {
        get { self[CryptatextPaletteKey.self] }
        set { self[CryptatextPaletteKey.self] = newValue }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

