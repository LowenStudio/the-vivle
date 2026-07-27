import Foundation

struct VerseFolder: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var verseIDs: Set<String>

    init(id: UUID = UUID(), name: String, verseIDs: Set<String> = []) {
        self.id = id
        self.name = name
        self.verseIDs = verseIDs
    }
}
