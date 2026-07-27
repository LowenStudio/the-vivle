//
//  ComapctVerseCard.swift
//  The Vivle
//
//  Created by Lowen on 4/28/26.
//


//
//  CompactVerseCard.swift
//  The Vivle
//
//  Created by Lowen on 4/28/26.
//

import SwiftUI

struct CompactVerseCard: View {
    let verse: ScriptureVerse

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(verse.verseTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)

                Spacer()

                Text(verse.volumeTitle)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
            }

            Text("\(verse.bookTitle) \(verse.chapterNumber):\(verse.verseNumber)")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)

            Text(verse.scriptureText)
                .font(.system(size: 13))
                .foregroundColor(.primary.opacity(0.85))
                .lineSpacing(3)
                .lineLimit(3)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    CompactVerseCard(
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
    .padding()
}
