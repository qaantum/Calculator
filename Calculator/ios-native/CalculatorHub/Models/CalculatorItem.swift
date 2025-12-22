import Foundation

struct CalculatorItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let route: String
    let category: String
}

