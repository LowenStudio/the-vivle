//
//  SearchView.swift
//  The Vivle
//
//  Created by Lowen on 4/29/26.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: VerseViewModel
    @AppStorage("selectedLanguage") private var selectedLanguage = AppLanguage.english.rawValue

    @State private var bookTitle = ""
    @State private var chapterNumber = ""
    @State private var verseNumber = ""
    @State private var keywordText = ""
    @State private var results: [ScriptureVerse] = []
    @State private var searchTask: Task<Void, Never>?

    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: selectedLanguage) ?? .english
    }

    private var navigationTitleText: String {
        switch currentLanguage {
        case .english:
            return "Search"
        case .spanish:
            return "Buscar"
        }
    }

    private var referenceTitleText: String {
        switch currentLanguage {
        case .english:
            return "Reference"
        case .spanish:
            return "Referencia"
        }
    }

    private var bookPlaceholderText: String {
        switch currentLanguage {
        case .english:
            return "Book"
        case .spanish:
            return "Libro"
        }
    }

    private var referenceExampleText: String {
        switch currentLanguage {
        case .english:
            return "Example: John 3:16"
        case .spanish:
            return "Ejemplo: Juan 3:16"
        }
    }

    private var keywordTitleText: String {
        switch currentLanguage {
        case .english:
            return "Keyword"
        case .spanish:
            return "Palabra clave"
        }
    }

    private var keywordPlaceholderText: String {
        switch currentLanguage {
        case .english:
            return "Search verse text"
        case .spanish:
            return "Buscar texto del versículo"
        }
    }

    private var keywordExampleText: String {
        switch currentLanguage {
        case .english:
            return "Example: faith, grace, love"
        case .spanish:
            return "Ejemplo: fe, gracia, amor"
        }
    }

    private var emptyTitleText: String {
        switch currentLanguage {
        case .english:
            return "Search Scripture"
        case .spanish:
            return "Buscar en las Escrituras"
        }
    }

    private var emptyDescriptionText: String {
        switch currentLanguage {
        case .english:
            return "Enter a reference, or search by words from the verse."
        case .spanish:
            return "Ingresa una referencia o busca palabras del versículo."
        }
    }

    private var noResultsTitleText: String {
        switch currentLanguage {
        case .english:
            return "No Results"
        case .spanish:
            return "Sin resultados"
        }
    }

    private var noResultsDescriptionText: String {
        switch currentLanguage {
        case .english:
            return "Check the reference, or try fewer keyword words."
        case .spanish:
            return "Revisa la referencia o intenta con menos palabras."
        }
    }

    private var hasSearchInput: Bool {
        hasReferenceInput || hasKeywordInput
    }

    private var hasReferenceInput: Bool {
        !bookTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !chapterNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !verseNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var hasKeywordInput: Bool {
        !keywordText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var searchQuery: String {
        let book = bookTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let chapter = chapterNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let verse = verseNumber.trimmingCharacters(in: .whitespacesAndNewlines)

        if !book.isEmpty, !chapter.isEmpty, !verse.isEmpty {
            return "\(book) \(chapter):\(verse)"
        }

        if !book.isEmpty, !chapter.isEmpty {
            return "\(book) \(chapter)"
        }

        if !book.isEmpty {
            return "\(book) 0"
        }

        return ""
    }

    var body: some View {
        VStack(spacing: 0) {
            searchForm
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 14)

            Divider()

            Group {
                if !hasSearchInput {
                    emptyState
                } else if results.isEmpty {
                    noResultsState
                } else {
                    resultsList
                }
            }
        }
        .navigationTitle(navigationTitleText)
        .onChange(of: bookTitle) { _, _ in
            scheduleSearch()
        }
        .onChange(of: chapterNumber) { _, newValue in
            let cleanedValue = numbersOnly(newValue)
            if chapterNumber != cleanedValue {
                chapterNumber = cleanedValue
            }
            scheduleSearch()
        }
        .onChange(of: verseNumber) { _, newValue in
            let cleanedValue = numbersOnly(newValue)
            if verseNumber != cleanedValue {
                verseNumber = cleanedValue
            }
            scheduleSearch()
        }
        .onChange(of: keywordText) { _, _ in
            scheduleSearch()
        }
        .onDisappear {
            searchTask?.cancel()
        }
    }

    private var searchForm: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(referenceTitleText)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.secondary)

            HStack(spacing: 8) {
                TextField(bookPlaceholderText, text: $bookTitle)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                TextField("3", text: $chapterNumber)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
                    .frame(width: 52)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(":")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.secondary)

                TextField("16", text: $verseNumber)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
                    .frame(width: 52)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Text(referenceExampleText)
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                Text(keywordTitleText)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.top, 10)

                TextField(keywordPlaceholderText, text: $keywordText)
                    .disableAutocorrection(true)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(keywordExampleText)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
    }

    private var resultsList: some View {
        List(results) { verse in
            NavigationLink {
                SearchVerseDetailView(viewModel: viewModel, verse: verse)
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(referenceText(for: verse))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(verse.scriptureText)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .lineSpacing(3)
                }
                .padding(.vertical, 6)
            }
        }
        .listStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 34, weight: .medium))
                .foregroundColor(.secondary)

            Text(emptyTitleText)
                .font(.system(size: 20, weight: .semibold))

            Text(emptyDescriptionText)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
    }

    private var noResultsState: some View {
        VStack(spacing: 14) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 34, weight: .medium))
                .foregroundColor(.secondary)

            Text(noResultsTitleText)
                .font(.system(size: 20, weight: .semibold))

            Text(noResultsDescriptionText)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
    }

    private func scheduleSearch() {
        searchTask?.cancel()

        guard hasSearchInput else {
            results = []
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 220_000_000)

            guard !Task.isCancelled else { return }

            let keywordQuery = keywordText.trimmingCharacters(in: .whitespacesAndNewlines)
            let foundResults: [ScriptureVerse]

            if !keywordQuery.isEmpty {
                foundResults = viewModel.searchVerseContent(query: keywordQuery)
            } else {
                foundResults = viewModel.searchVerses(query: searchQuery)
            }

            await MainActor.run {
                results = foundResults
            }
        }
    }

    private func numbersOnly(_ value: String) -> String {
        value.filter { $0.isNumber }
    }

    private func referenceText(for verse: ScriptureVerse) -> String {
        "\(verse.bookTitle) \(verse.chapterNumber):\(verse.verseNumber)"
    }
}

#Preview {
    SearchView(viewModel: VerseViewModel())
}

private struct SearchVerseDetailView: View {
    @ObservedObject var viewModel: VerseViewModel
    @AppStorage("selectedLanguage") private var selectedLanguage = AppLanguage.english.rawValue
    let verse: ScriptureVerse

    private var isLiked: Bool {
        viewModel.likedVerseIDs.contains(verse.id)
    }

    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: selectedLanguage) ?? .english
    }

    private var navigationTitleText: String {
        switch currentLanguage {
        case .english:
            return "Verse"
        case .spanish:
            return "Versículo"
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

    private var likeVerseText: String {
        switch currentLanguage {
        case .english:
            return "Like Verse"
        case .spanish:
            return "Guardar versículo"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(verse.verseTitle)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.primary)

                        Text("\(verse.volumeTitle) • \(verse.bookTitle) \(verse.chapterNumber):\(verse.verseNumber)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }

                    Text(verse.scriptureText)
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                        .lineSpacing(6)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .padding(.bottom, 20)
            }

            Button {
                viewModel.toggleLike(for: verse)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))

                    Text(isLiked ? likedText : likeVerseText)
                        .font(.system(size: 15, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(Color.primary)
                .foregroundColor(Color(.systemBackground))
                .cornerRadius(14)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .navigationTitle(navigationTitleText)
        .navigationBarTitleDisplayMode(.inline)
    }
}
