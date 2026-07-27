//
//  FavoritesView.swift
//  The Vivle
//
//  Created by Lowen on 4/28/26.
//


//
//  FavoritesView.swift
//  The Vivle
//
//  Created by Lowen on 4/28/26.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: VerseViewModel
    @AppStorage("selectedLanguage") private var selectedLanguage = AppLanguage.english.rawValue

    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: selectedLanguage) ?? .english
    }

    private var navigationTitleText: String {
        switch currentLanguage {
        case .english:
            return "Liked Verses"
        case .spanish:
            return "Versículos guardados"
        }
    }

    private var emptyTitleText: String {
        switch currentLanguage {
        case .english:
            return "No Liked Verses"
        case .spanish:
            return "No hay versículos guardados"
        }
    }

    private var emptyDescriptionText: String {
        switch currentLanguage {
        case .english:
            return "Like a verse from the home page and it will appear here."
        case .spanish:
            return "Guarda un versículo desde la página principal y aparecerá aquí."
        }
    }

    private var unlikeText: String {
        switch currentLanguage {
        case .english:
            return "Unlike"
        case .spanish:
            return "Quitar"
        }
    }

    var body: some View {
        Group {
            if viewModel.likedVerses.isEmpty {
                emptyState
            } else {
                likedVerseList
            }
        }
        .navigationTitle(navigationTitleText)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: "heart")
                .font(.system(size: 28, weight: .regular))
                .foregroundColor(.gray)

            Text(emptyTitleText)
                .font(.system(size: 22, weight: .semibold))

            Text(emptyDescriptionText)
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 24)

            Spacer()
        }
        .padding(24)
    }

    private var likedVerseList: some View {
        List {
            ForEach(viewModel.likedVerses) { verse in
                NavigationLink {
                    VerseDetailView(verse: verse)
                } label: {
                    CompactVerseCard(verse: verse)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 24, bottom: 6, trailing: 24))
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.unlike(verse)
                    } label: {
                        Label(unlikeText, systemImage: "heart.slash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        FavoritesView(viewModel: VerseViewModel())
    }
}
