import SwiftUI

private enum AppRoute {
    case landing
    case onboarding
    case home
}

struct ContentView: View {
    @State private var route: AppRoute = UserDefaults.standard.bool(forKey: UserDefaultsKey.hasCompletedOnboarding) ? .home : .landing

    @AppStorage(UserDefaultsKey.appTheme) private var appTheme = AppTheme.system.rawValue

    private var selectedTheme: AppTheme {
        AppTheme(rawValue: appTheme) ?? .system
    }

    var body: some View {
        Group {
            switch route {
            case .landing:
                LandingView {
                    route = .onboarding
                }

            case .onboarding:
                OnboardingView {
                    NotificationManager.shared.requestPermission()
                    route = .home
                }

            case .home:
                HomeView()
            }
        }
        .preferredColorScheme(selectedTheme.colorScheme)
    }
}

#Preview {
    ContentView()
}
