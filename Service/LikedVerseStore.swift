import Foundation

enum LikedVerseStore {
    private static let key = "liked_verse_ids"
    private static let legacyFavoriteKey = "favorite_verse_ids"

    static func loadLikedVerseIDs() -> Set<String> {
        let saved = UserDefaults.standard.stringArray(forKey: key)

        if let saved {
            return Set(saved)
        }

        let legacySaved = UserDefaults.standard.stringArray(forKey: legacyFavoriteKey) ?? []
        let migrated = Set(legacySaved)

        if !migrated.isEmpty {
            saveLikedVerseIDs(migrated)
            UserDefaults.standard.removeObject(forKey: legacyFavoriteKey)
        }

        return migrated
    }

    static func saveLikedVerseIDs(_ likedVerseIDs: Set<String>) {
        UserDefaults.standard.set(Array(likedVerseIDs).sorted(), forKey: key)
    }
}
