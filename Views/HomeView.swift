//
//  HomeView.swift
//  The Vivle
//
//  Created by Lowen on 4/28/26.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @StateObject private var viewModel = VerseViewModel()
    @State private var dragOffset: CGFloat = 0
    @State private var showCopiedMessage = false
    @AppStorage(UserDefaultsKey.appTheme) private var appTheme = AppTheme.system.rawValue
    @AppStorage("selectedLanguage") private var selectedLanguage = AppLanguage.english.rawValue

    private var name: String {
        UserDefaults.standard.string(forKey: UserDefaultsKey.userName) ?? "User"
    }

    private var selectedTheme: AppTheme {
        AppTheme(rawValue: appTheme) ?? .system
    }

    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: selectedLanguage) ?? .english
    }

    private var copiedText: String {
        switch currentLanguage {
        case .english:
            return "Copied"
        case .spanish:
            return "Copiado"
        }
    }

    private var headerTitle: String {
        switch currentLanguage {
        case .english:
            return "For \(name)"
        case .spanish:
            return "Para \(name)"
        }
    }

    private var searchAccessibilityText: String {
        switch currentLanguage {
        case .english:
            return "Search scripture"
        case .spanish:
            return "Buscar en las Escrituras"
        }
    }

    private var likedVersesAccessibilityText: String {
        switch currentLanguage {
        case .english:
            return "Liked verses"
        case .spanish:
            return "Versículos guardados"
        }
    }

    private var settingsAccessibilityText: String {
        switch currentLanguage {
        case .english:
            return "Settings"
        case .spanish:
            return "Ajustes"
        }
    }

    private var swipeInstructionText: String {
        switch currentLanguage {
        case .english:
            return "Swipe up or down"
        case .spanish:
            return "Desliza hacia arriba o abajo"
        }
    }

    private var copyInstructionText: String {
        switch currentLanguage {
        case .english:
            return "Press long to copy the verse"
        case .spanish:
            return "Mantén presionado para copiar el versículo"
        }
    }

    private var noVerseAvailableText: String {
        switch currentLanguage {
        case .english:
            return "No verse available. Confirm that the verses JSON file is included in the app target."
        case .spanish:
            return "No hay versículo disponible. Confirma que el archivo JSON de versículos esté incluido en el objetivo de la app."
        }
    }

    private var likedText: String {
        switch currentLanguage {
        case .english:
            return "Liked"
        case .spanish:
            return "Guardado"
        }
    }

    private var likeText: String {
        switch currentLanguage {
        case .english:
            return "Like"
        case .spanish:
            return "Guardar"
        }
    }

    private var localizedRemainingTimeText: String {
        guard !viewModel.remainingTimeText.isEmpty else { return "" }

        switch currentLanguage {
        case .english:
            return viewModel.remainingTimeText
        case .spanish:
            return viewModel.remainingTimeText
                .replacingOccurrences(of: "Next in", with: "Próximo en")
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Spacer().frame(height: 40)

                header
                    .zIndex(1)

                ZStack(alignment: .bottom) {
                    verseSection
                        .clipped()

                    if showCopiedMessage {
                        Text(copiedText)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(.systemBackground))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.primary.opacity(0.9))
                            .cornerRadius(20)
                            .padding(.bottom, 8)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }

                Spacer()
            }
            .padding(24)
            .background(Color(.systemBackground))
            .onAppear {
                viewModel.start()
            }
            .onDisappear {
                viewModel.stop()
            }
        }
        .preferredColorScheme(selectedTheme.colorScheme)
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(headerTitle)
                .font(.system(size: 28, weight: .semibold))

            Spacer()

            HStack(spacing: 18) {
                NavigationLink {
                    SearchView(viewModel: viewModel)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                }
                .accessibilityLabel(searchAccessibilityText)

                NavigationLink {
                    FavoritesView(viewModel: viewModel)
                } label: {
                    Image(systemName: "heart")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                }
                .accessibilityLabel(likedVersesAccessibilityText)

                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                }
                .accessibilityLabel(settingsAccessibilityText)
            }
        }
    }

    private var verseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(swipeInstructionText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)

                Spacer()

                if !localizedRemainingTimeText.isEmpty {
                    Text(localizedRemainingTimeText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray.opacity(0.8))
                }
            }
            Text(copyInstructionText)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray.opacity(0.75))

            if let currentVerse = viewModel.currentVerse {
                GeometryReader { proxy in
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(currentVerse.verseTitle)
                                .font(.system(size: 20, weight: .semibold))

                            Text("\(currentVerse.volumeTitle) • \(currentVerse.bookTitle) \(currentVerse.chapterNumber):\(currentVerse.verseNumber)")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.gray)

                            Text(currentVerse.scriptureText)
                                .font(.system(size: 18))
                                .lineSpacing(4)
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .contentShape(Rectangle())
                        .offset(y: dragOffset)
                        .simultaneousGesture(doubleTapToLikeGesture)
                        .simultaneousGesture(longPressToCopyGesture(for: currentVerse))
                        .simultaneousGesture(verseSwipeGesture)

                        Spacer(minLength: 24)

                        verseActionButtons
                    }
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height, alignment: .topLeading)
                }
                .frame(minHeight: 320)
                .clipped()
            } else {
                Text(noVerseAvailableText)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }
        }
    }

    private var verseActionButtons: some View {
        Button(action: viewModel.toggleLikeForCurrentVerse) {
            HStack(spacing: 8) {
                Image(systemName: viewModel.isCurrentVerseLiked ? "heart.fill" : "heart")
                Text(viewModel.isCurrentVerseLiked ? likedText : likeText)
            }
        }
        .font(.system(size: 15, weight: .medium))
        .foregroundColor(.primary)
        .padding(.top, 8)
        .buttonStyle(.plain)
    }

    private var doubleTapToLikeGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                if !viewModel.isCurrentVerseLiked {
                    viewModel.toggleLikeForCurrentVerse()
                }
            }
    }

    private func longPressToCopyGesture(for verse: ScriptureVerse) -> some Gesture {
        LongPressGesture(minimumDuration: 0.5)
            .onEnded { _ in
                UIPasteboard.general.string = """
                \(verse.verseTitle)

                \(verse.scriptureText)
                """

                withAnimation(.easeInOut(duration: 0.2)) {
                    showCopiedMessage = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showCopiedMessage = false
                    }
                }
            }
    }

    private var verseSwipeGesture: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in
                var transaction = Transaction()
                transaction.disablesAnimations = true

                withTransaction(transaction) {
                    dragOffset = max(min(value.translation.height * 0.42, 96), -96)
                }
            }
            .onEnded { value in
                if value.translation.height < -60 {
                    viewModel.showNextVerse()
                } else if value.translation.height > 60 {
                    viewModel.showPreviousVerse()
                }

                withAnimation(.interactiveSpring(response: 0.34, dampingFraction: 0.86, blendDuration: 0.12)) {
                    dragOffset = 0
                }
            }
    }
}

#Preview {
    HomeView()
}
