import Foundation

struct ScriptureVerse: Identifiable, Equatable {
    let volumeTitle: String
    let bookTitle: String
    let bookShortTitle: String
    let chapterNumber: Int
    let verseNumber: Int
    let verseTitle: String
    let verseShortTitle: String
    let scriptureText: String

    var id: String { verseShortTitle }

    enum CodingKeys: String, CodingKey {
        case volumeTitle = "volume_title"
        case bookTitle = "book_title"
        case bookShortTitle = "book_short_title"
        case chapterNumber = "chapter_number"
        case verseNumber = "verse_number"
        case verseTitle = "verse_title"
        case verseShortTitle = "verse_short_title"
        case scriptureText = "scripture_text"
    }
}
