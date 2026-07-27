import Foundation

enum VerseFolderStore {
    private static let key = "verse_folders"

    static func loadFolders() -> [VerseFolder] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let folders = try? JSONDecoder().decode([VerseFolder].self, from: data)
        else {
            return []
        }

        return folders
    }

    static func saveFolders(_ folders: [VerseFolder]) {
        guard let data = try? JSONEncoder().encode(folders) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
