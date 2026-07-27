import Foundation

enum VerseLoader {
    static func loadVerses() -> [ScriptureVerse] {
        guard let url = Bundle.main.url(forResource: "Verses", withExtension: "json") else {
            print("Could not find verses file in the app bundle.")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let keyedVerses = try JSONDecoder().decode([String: String].self, from: data)
            return try makeVerses(from: keyedVerses)
        } catch {
            print("Failed to load verses: \(error)")
            return []
        }
    }

    static func makeVerses(from keyedVerses: [String: String]) throws -> [ScriptureVerse] {
        let parsed = try keyedVerses.map { reference, text -> ScriptureVerse in
            let parts = reference.split(separator: " ")
            guard let chapterAndVerse = parts.last?.split(separator: ":"),
                  chapterAndVerse.count == 2,
                  let chapter = Int(chapterAndVerse[0]),
                  let verse = Int(chapterAndVerse[1]),
                  parts.count > 1 else {
                throw VerseLoadingError.invalidReference(reference)
            }

            let book = parts.dropLast().joined(separator: " ")
            guard let bookIndex = BibleCanon.bookIndex[book] else {
                throw VerseLoadingError.unknownBook(book)
            }

            let testament = bookIndex < 39 ? "Old Testament" : "New Testament"
            let cleanText = text
                .replacingOccurrences(of: "# ", with: "")
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            return ScriptureVerse(
                volumeTitle: testament,
                bookTitle: book,
                bookShortTitle: BibleCanon.shortTitles[book] ?? book,
                chapterNumber: chapter,
                verseNumber: verse,
                verseTitle: reference,
                verseShortTitle: reference,
                scriptureText: cleanText
            )
        }

        return parsed.sorted {
            let leftBook = BibleCanon.bookIndex[$0.bookTitle] ?? .max
            let rightBook = BibleCanon.bookIndex[$1.bookTitle] ?? .max
            return (leftBook, $0.chapterNumber, $0.verseNumber)
                < (rightBook, $1.chapterNumber, $1.verseNumber)
        }
    }
}

enum VerseLoadingError: Error, Equatable {
    case invalidReference(String)
    case unknownBook(String)
}

private enum BibleCanon {
    static let books = [
        "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy",
        "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings",
        "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah",
        "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes",
        "Solomon's Song", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel",
        "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah",
        "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi",
        "Matthew", "Mark", "Luke", "John", "Acts", "Romans",
        "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians",
        "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians",
        "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James",
        "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"
    ]

    static let bookIndex = Dictionary(uniqueKeysWithValues: books.enumerated().map { ($1, $0) })

    static let shortTitles = [
        "Genesis": "Gen", "Exodus": "Exod", "Leviticus": "Lev",
        "Numbers": "Num", "Deuteronomy": "Deut", "Joshua": "Josh",
        "Judges": "Judg", "1 Samuel": "1 Sam", "2 Samuel": "2 Sam",
        "1 Kings": "1 Kgs", "2 Kings": "2 Kgs", "1 Chronicles": "1 Chr",
        "2 Chronicles": "2 Chr", "Psalms": "Ps", "Proverbs": "Prov",
        "Ecclesiastes": "Eccl", "Solomon's Song": "Song", "Isaiah": "Isa",
        "Jeremiah": "Jer", "Lamentations": "Lam", "Ezekiel": "Ezek",
        "Daniel": "Dan", "Matthew": "Matt", "Mark": "Mark", "Luke": "Luke",
        "John": "John", "Acts": "Acts", "Romans": "Rom",
        "1 Corinthians": "1 Cor", "2 Corinthians": "2 Cor",
        "Galatians": "Gal", "Ephesians": "Eph", "Philippians": "Phil",
        "Colossians": "Col", "1 Thessalonians": "1 Thess",
        "2 Thessalonians": "2 Thess", "1 Timothy": "1 Tim",
        "2 Timothy": "2 Tim", "Philemon": "Phlm", "Hebrews": "Heb",
        "James": "Jas", "1 Peter": "1 Pet", "2 Peter": "2 Pet",
        "1 John": "1 John", "2 John": "2 John", "3 John": "3 John",
        "Revelation": "Rev"
    ]
}
