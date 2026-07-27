//
//  VerseDetailView.swift
//  The Vivle
//
//  Created by Lowen on 4/28/26.
//


//
//  VerseDetailView.swift
//  The Vivle
//
//  Created by Lowen on 4/28/26.
//

import SwiftUI

struct VerseDetailView: View {
    let verse: ScriptureVerse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(verse.verseTitle)
                    .font(.system(size: 28, weight: .semibold))

                Text("\(verse.volumeTitle) • \(verse.bookTitle) \(verse.chapterNumber):\(verse.verseNumber)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)

                Text(verse.scriptureText)
                    .font(.system(size: 20))
                    .lineSpacing(6)
                    .padding(.top, 8)

                Spacer()
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(verse.verseShortTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NavigationStack {
        VerseDetailView(
            verse: ScriptureVerse(
                volumeTitle: "New Testament",
                bookTitle: "John",
                bookShortTitle: "John",
                chapterNumber: 3,
                verseNumber: 16,
                verseTitle: "John 3:16",
                verseShortTitle: "John 3:16",
                scriptureText: "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life."
            )
        )
    }
}
