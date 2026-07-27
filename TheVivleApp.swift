import SwiftUI

@main
struct TheVivleApp: App {
    @AppStorage("app_theme") private var appTheme = AppTheme.system.rawValue

    private var selectedTheme: AppTheme {
        AppTheme(rawValue: appTheme) ?? .system
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(selectedTheme.colorScheme)
        }
    }
}
