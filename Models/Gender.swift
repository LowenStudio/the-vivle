import Foundation

enum Gender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"

    var id: String { rawValue }

    func title(for language: AppLanguage) -> String {
        switch (self, language) {
        case (.male, .english):
            return "Male"
        case (.male, .spanish):
            return "Hombre"
        case (.female, .english):
            return "Female"
        case (.female, .spanish):
            return "Mujer"
        }
    }
}
