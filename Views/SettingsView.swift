import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultsKey.userName) private var userName = "User"
    @AppStorage(UserDefaultsKey.appTheme) private var appTheme = AppTheme.system.rawValue
    @AppStorage("selectedLanguage") private var selectedLanguage = AppLanguage.english.rawValue

    private var selectedTheme: AppTheme {
        AppTheme(rawValue: appTheme) ?? .system
    }

    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: selectedLanguage) ?? .english
    }

    private var settingsTitleText: String {
        switch currentLanguage {
        case .english: return "Settings"
        case .spanish: return "Ajustes"
        }
    }

    private var profileTitleText: String {
        switch currentLanguage {
        case .english: return "Profile"
        case .spanish: return "Perfil"
        }
    }

    private var nameText: String {
        switch currentLanguage {
        case .english: return "Name"
        case .spanish: return "Nombre"
        }
    }

    private var firstNamePlaceholderText: String {
        switch currentLanguage {
        case .english: return "First name"
        case .spanish: return "Nombre"
        }
    }


    private var appThemeText: String {
        switch currentLanguage {
        case .english: return "App Theme"
        case .spanish: return "Tema de la app"
        }
    }

    private var languageText: String {
        switch currentLanguage {
        case .english: return "Language"
        case .spanish: return "Idioma"
        }
    }

    private var appLanguageText: String {
        switch currentLanguage {
        case .english: return "App Language"
        case .spanish: return "Idioma de la app"
        }
    }

    private var contentLegalText: String {
        switch currentLanguage {
        case .english: return "Content & Legal"
        case .spanish: return "Contenido y legal"
        }
    }

    private var aboutTitleText: String {
        switch currentLanguage {
        case .english: return "About The Vivle"
        case .spanish: return "Acerca de The Vivle"
        }
    }

    private var aboutSubtitleText: String {
        switch currentLanguage {
        case .english: return "Open app information and acknowledgements."
        case .spanish: return "Abre información de la app y reconocimientos."
        }
    }

    private var aboutContentText: [String] {
        switch currentLanguage {
        case .english:
            return [
                "The Vivle is a simple Christian Bible companion for daily reading and reflection.",
                "Read, search, save, and revisit verses from all 66 books of the Old and New Testaments.",
                "The Vivle is designed for Christians across traditions and is not affiliated with or endorsed by any church or denomination."
            ]
        case .spanish:
            return [
                "The Vivle es una sencilla app cristiana de la Biblia para la lectura y reflexión diaria.",
                "Lee, busca, guarda y vuelve a visitar versículos de los 66 libros del Antiguo y Nuevo Testamento.",
                "The Vivle está diseñada para cristianos de distintas tradiciones y no está afiliada ni respaldada por ninguna iglesia o denominación."
            ]
        }
    }

    private var openAboutPageText: String {
        switch currentLanguage {
        case .english: return "Open About Page"
        case .spanish: return "Abrir página Acerca de"
        }
    }

    private var privacyTitleText: String {
        switch currentLanguage {
        case .english: return "Privacy"
        case .spanish: return "Privacidad"
        }
    }

    private var privacySubtitleText: String {
        switch currentLanguage {
        case .english: return "Open the app privacy policy."
        case .spanish: return "Abre la política de privacidad de la app."
        }
    }

    private var privacyContentText: [String] {
        switch currentLanguage {
        case .english:
            return [
                "The Vivle does not require an account or login.",
                "Saved verses, app theme, profile details, and widget values are stored locally on your device.",
                "The Vivle does not collect or sell personal data. Your reading activity remains on your device."
            ]
        case .spanish:
            return [
                "The Vivle no requiere una cuenta ni inicio de sesión.",
                "Los versículos guardados, el tema de la app, los datos de perfil y los valores de widgets se almacenan localmente en tu dispositivo.",
                "The Vivle no recopila ni vende datos personales. Tu actividad de lectura permanece en tu dispositivo."
            ]
        }
    }

    private var openPrivacyPolicyText: String {
        switch currentLanguage {
        case .english: return "Open Privacy Policy"
        case .spanish: return "Abrir Política de Privacidad"
        }
    }

    private var termsTitleText: String {
        switch currentLanguage {
        case .english: return "Terms of Use"
        case .spanish: return "Términos de uso"
        }
    }

    private var termsSubtitleText: String {
        switch currentLanguage {
        case .english: return "Open app terms and conditions."
        case .spanish: return "Abre los términos y condiciones de la app."
        }
    }

    private var termsContentText: [String] {
        switch currentLanguage {
        case .english:
            return [
                "These Terms of Use apply to your use of The Vivle.",
                "The Vivle is provided as a Bible reading and reflection app for personal, non-commercial use.",
                "The app and its content are provided as available, without a guarantee that they will meet every theological, pastoral, or study need."
            ]
        case .spanish:
            return [
                "Estos Términos de uso se aplican al uso de The Vivle.",
                "The Vivle se ofrece como una app de lectura y reflexión bíblica para uso personal y no comercial.",
                "La app y su contenido se proporcionan tal como están, sin garantía de satisfacer todas las necesidades teológicas, pastorales o de estudio."
            ]
        }
    }

    private var openTermsText: String {
        switch currentLanguage {
        case .english: return "Open Terms of Use"
        case .spanish: return "Abrir Términos de uso"
        }
    }

    private var scriptureSourceTitleText: String {
        switch currentLanguage {
        case .english: return "Scripture Source"
        case .spanish: return "Fuente de las Escrituras"
        }
    }

    private var scriptureSourceSubtitleText: String {
        switch currentLanguage {
        case .english: return "Review scripture text source and acknowledgements."
        case .spanish: return "Revisa la fuente del texto de las Escrituras y los reconocimientos."
        }
    }

    private var scriptureSourceContentText: [String] {
        switch currentLanguage {
        case .english:
            return [
                "Bible text: King James Version, standard 1769 text.",
                "The complete Protestant canon is included: 66 books and 31,102 verses.",
                "Source dataset: github.com/farskipper/kjv, released into the public domain under the Unlicense.",
                "Square brackets used by the source to mark supplied words and paragraph markers are removed for cleaner reading; the wording is otherwise preserved."
            ]
        case .spanish:
            return [
                "Texto bíblico: versión King James, texto estándar de 1769 en inglés.",
                "Se incluye el canon protestante completo: 66 libros y 31.102 versículos.",
                "Datos de origen: github.com/farskipper/kjv, de dominio público bajo la licencia Unlicense.",
                "Se eliminan los corchetes de palabras añadidas y los marcadores de párrafo para facilitar la lectura; el resto del texto se conserva."
            ]
        }
    }

    private var supportTitleText: String {
        switch currentLanguage {
        case .english: return "Support"
        case .spanish: return "Soporte"
        }
    }

    private var supportSubtitleText: String {
        switch currentLanguage {
        case .english: return "Open support and contact information."
        case .spanish: return "Abre información de soporte y contacto."
        }
    }

    private var supportContentText: [String] {
        switch currentLanguage {
        case .english:
            return [
                "For questions, bug reports, or support requests, contact lowen1456558@gmail.com.",
                "When reporting a problem, include your device model, iOS version, a short description of the issue, and steps to reproduce it if possible.",
                "The Vivle is an independent Christian Bible app."
            ]
        case .spanish:
            return [
                "Para preguntas, informes de errores o solicitudes de soporte, contacta a lowen1456558@gmail.com.",
                "Al informar un problema, incluye el modelo de tu dispositivo, la versión de iOS, una breve descripción del problema y los pasos para reproducirlo si es posible.",
                "The Vivle es una app bíblica cristiana independiente."
            ]
        }
    }

    private var openSupportPageText: String {
        switch currentLanguage {
        case .english: return "Open Support Page"
        case .spanish: return "Abrir página de soporte"
        }
    }

    private var versionLabelText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

        switch currentLanguage {
        case .english: return "Version \(version) (\(build))"
        case .spanish: return "Versión \(version) (\(build))"
        }
    }

    private var appVersionText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                profileSection
                // upgradeSection
                themeSection
                languageSection
                contentLegalSection

                Spacer(minLength: 40)

                Text(versionLabelText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 12)
            }
            .padding(24)
        }
        .background(Color(.systemBackground))
        .navigationTitle(settingsTitleText)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(selectedTheme.colorScheme)
    }

    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(profileTitleText)

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(nameText)
                        .settingsLabelStyle()

                    TextField(firstNamePlaceholderText, text: $userName)
                        .textContentType(.givenName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .padding(12)
                        .background(Color(.tertiarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
    }

    /*
    private var upgradeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Upgrade")

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.primary)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("The Vivle Pro")
                            .font(.system(size: 18, weight: .semibold))

                        Text("Unlock deeper study tools, expanded personalization, and more ways to keep scripture close throughout the day.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineSpacing(3)
                    }
                }

                Button {
                    // Connect this to StoreKit later.
                } label: {
                    Text("Upgrade to Pro")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(Color(.systemBackground))
                        .cornerRadius(12)
                }
            }
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
    }
    */

    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(appThemeText)

            Picker(appThemeText, selection: $appTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.title(for: currentLanguage)).tag(theme.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
    }

    private var languageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(languageText)

            Picker(appLanguageText, selection: $selectedLanguage) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.title).tag(language.rawValue)
                }
            }
            .pickerStyle(.navigationLink)
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
    }

    private var contentLegalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(contentLegalText)

            VStack(spacing: 0) {
                NavigationLink {
                    LegalDetailView(
                        title: aboutTitleText,
                        systemImage: "info.circle",
                        content: aboutContentText,
                        linkTitle: openAboutPageText,
                        linkURL: URL(string: "https://lowenstudio.github.io/the-vivle/about.html")
                    )
                } label: {
                    legalRow(
                        title: aboutTitleText,
                        subtitle: aboutSubtitleText,
                        systemImage: "info.circle"
                    )
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, 44)

                NavigationLink {
                    LegalDetailView(
                        title: privacyTitleText,
                        systemImage: "lock.shield",
                        content: privacyContentText,
                        linkTitle: openPrivacyPolicyText,
                        linkURL: URL(string: "https://lowenstudio.github.io/the-vivle/privacy.html")
                    )
                } label: {
                    legalRow(
                        title: privacyTitleText,
                        subtitle: privacySubtitleText,
                        systemImage: "lock.shield"
                    )
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, 44)

                NavigationLink {
                    LegalDetailView(
                        title: termsTitleText,
                        systemImage: "doc.text",
                        content: termsContentText
                    )
                } label: {
                    legalRow(
                        title: termsTitleText,
                        subtitle: termsSubtitleText,
                        systemImage: "doc.text"
                    )
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, 44)

                NavigationLink {
                    LegalDetailView(
                        title: scriptureSourceTitleText,
                        systemImage: "book.closed",
                        content: scriptureSourceContentText
                    )
                } label: {
                    legalRow(
                        title: scriptureSourceTitleText,
                        subtitle: scriptureSourceSubtitleText,
                        systemImage: "book.closed"
                    )
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading, 44)

                NavigationLink {
                    LegalDetailView(
                        title: supportTitleText,
                        systemImage: "questionmark.circle",
                        content: supportContentText,
                        linkTitle: openSupportPageText,
                        linkURL: URL(string: "https://lowenstudio.github.io/the-vivle/support.html")
                    )
                } label: {
                    legalRow(
                        title: supportTitleText,
                        subtitle: supportSubtitleText,
                        systemImage: "questionmark.circle"
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
    }

    private func legalRow(title: String, subtitle: String, systemImage: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 32, height: 32)
                .background(Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineSpacing(2)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray.opacity(0.7))
        }
        .padding(.vertical, 10)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.gray)
            .textCase(.uppercase)
            .tracking(0.8)
    }
}

private struct LegalDetailView: View {
    let title: String
    let systemImage: String
    let content: [String]
    let linkTitle: String?
    let linkURL: URL?

    init(title: String, systemImage: String, content: [String], linkTitle: String? = nil, linkURL: URL? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.content = content
        self.linkTitle = linkTitle
        self.linkURL = linkURL
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: systemImage)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 56, height: 56)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(content, id: \.self) { paragraph in
                        Text(paragraph)
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                }

                if let linkTitle, let linkURL {
                    Link(destination: linkURL) {
                        HStack(spacing: 8) {
                            Text(linkTitle)
                                .font(.system(size: 15, weight: .semibold))

                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(Color.primary)
                        .foregroundColor(Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .background(Color(.systemBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension Text {
    func settingsLabelStyle() -> some View {
        self
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.gray)
    }
}

#Preview {
    SettingsView()
}
