import SwiftUI

extension Color {
    static let teal1 = Color(red: 0.85, green: 0.95, blue: 0.95)  // Soft mint background
    static let teal2 = Color(red: 0.70, green: 0.90, blue: 0.90)  // Accent
    static let teal3 = Color(red: 0.50, green: 0.80, blue: 0.80)  // Darker accent
    static let textDark = Color(red: 0.15, green: 0.15, blue: 0.18)
    static let textLight = Color.white.opacity(0.9)
}

extension ShapeStyle where Self == Color {
    static var teal1: Color { .teal1 }
    static var teal2: Color { .teal2 }
    static var teal3: Color { .teal3 }
}
