import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { rawValue }

    var title: String { rawValue }

    func title(for language: AppLanguage) -> String {
        switch (self, language) {
        case (.system, .english):
            return "System"
        case (.system, .spanish):
            return "Sistema"
        case (.light, .english):
            return "Light"
        case (.light, .spanish):
            return "Claro"
        case (.dark, .english):
            return "Dark"
        case (.dark, .spanish):
            return "Oscuro"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
