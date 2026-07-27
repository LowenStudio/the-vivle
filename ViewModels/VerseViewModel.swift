import Foundation
import Combine
import WidgetKit

@MainActor
final class VerseViewModel: ObservableObject {
    @Published private(set) var verses: [ScriptureVerse] = []
    @Published private(set) var currentVerse: ScriptureVerse? {
        didSet {
            saveCurrentVerseForWidget()
            scheduleMorningNotificationForCurrentVerse()
        }
    }
    @Published private(set) var likedVerseIDs: Set<String> = LikedVerseStore.loadLikedVerseIDs()
    @Published private(set) var remainingTimeText = ""

    private var refreshTask: Task<Void, Never>?
    private var verseHistory: [ScriptureVerse] = []

    var isCurrentVerseLiked: Bool {
        guard let currentVerse else { return false }
        return likedVerseIDs.contains(currentVerse.id)
    }

    var likedVerses: [ScriptureVerse] {
        verses.filter { likedVerseIDs.contains($0.id) }
    }

    func searchVerses(query: String) -> [ScriptureVerse] {
        let cleanedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanedQuery.isEmpty else {
            return []
        }

        if let referenceSearch = parseReferenceSearch(cleanedQuery) {
            return searchByReference(referenceSearch)
        }

        let normalizedQuery = cleanedQuery.normalizedForSearch

        let matches = verses.lazy.filter { verse in
            verse.searchText.contains(normalizedQuery)
        }

        return uniqueVerses(from: matches, limit: 80)
    }

    func searchVerseContent(query: String) -> [ScriptureVerse] {
        let cleanedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanedQuery.isEmpty else {
            return []
        }

        let normalizedQuery = cleanedQuery.normalizedForSearch

        let matches = verses.lazy.filter { verse in
            verse.scriptureText.normalizedForSearch.contains(normalizedQuery)
        }

        return uniqueVerses(from: matches, limit: 80)
    }

    private struct ReferenceSearch {
        let bookTitle: String
        let chapterNumber: Int?
        let verseNumber: Int?
    }

    private func parseReferenceSearch(_ query: String) -> ReferenceSearch? {
        let normalized = query
            .replacingOccurrences(of: ":", with: " ")
            .split(separator: " ")
            .map(String.init)

        guard let last = normalized.last else { return nil }

        if normalized.count >= 3,
           let verseNumber = Int(last),
           let chapterNumber = Int(normalized[normalized.count - 2]) {
            let bookTitle = normalized.dropLast(2).joined(separator: " ")
            return ReferenceSearch(bookTitle: bookTitle, chapterNumber: chapterNumber, verseNumber: verseNumber)
        }

        if normalized.count >= 2,
           let chapterNumber = Int(last) {
            let bookTitle = normalized.dropLast().joined(separator: " ")
            return ReferenceSearch(bookTitle: bookTitle, chapterNumber: chapterNumber, verseNumber: nil)
        }

        return nil
    }

    private func searchByReference(_ search: ReferenceSearch) -> [ScriptureVerse] {
        let normalizedBookTitle = search.bookTitle.normalizedForSearch

        let matches = verses.lazy.filter { verse in
            let bookMatches = verse.bookTitle.normalizedForSearch == normalizedBookTitle
                || verse.bookShortTitle.normalizedForSearch == normalizedBookTitle

            guard bookMatches else { return false }

            if let chapterNumber = search.chapterNumber,
               chapterNumber > 0,
               verse.chapterNumber != chapterNumber {
                return false
            }

            if let verseNumber = search.verseNumber,
               verse.verseNumber != verseNumber {
                return false
            }

            return true
        }

        return uniqueVerses(from: matches, limit: 80)
    }

    private func uniqueVerses<S: Sequence>(from sequence: S, limit: Int) -> [ScriptureVerse] where S.Element == ScriptureVerse {
        var seenIDs = Set<String>()
        var uniqueResults: [ScriptureVerse] = []
        uniqueResults.reserveCapacity(limit)

        for verse in sequence {
            guard seenIDs.insert(verse.id).inserted else { continue }
            uniqueResults.append(verse)

            if uniqueResults.count == limit {
                break
            }
        }

        return uniqueResults
    }

    func start() {
        loadVersesIfNeeded()
        loadCurrentHourlyVerse()
        updateRemainingTimeText()
        startHourlyRefresh()
    }

    func stop() {
        refreshTask?.cancel()
        refreshTask = nil
    }

    func shuffleVerse() {
        if let currentVerse {
            verseHistory.append(currentVerse)
        }

        currentVerse = VerseSelector.randomVerse(from: verses, excluding: currentVerse)
    }

    func showNextVerse() {
        shuffleVerse()
    }

    func showPreviousVerse() {
        guard let previousVerse = verseHistory.popLast() else { return }
        currentVerse = previousVerse
    }

    func toggleLikeForCurrentVerse() {
        guard let currentVerse else { return }
        toggleLike(for: currentVerse)
    }

    func unlike(_ verse: ScriptureVerse) {
        likedVerseIDs.remove(verse.id)
        LikedVerseStore.saveLikedVerseIDs(likedVerseIDs)
    }

    func toggleLike(for verse: ScriptureVerse) {
        if likedVerseIDs.contains(verse.id) {
            likedVerseIDs.remove(verse.id)
        } else {
            likedVerseIDs.insert(verse.id)
        }

        LikedVerseStore.saveLikedVerseIDs(likedVerseIDs)
    }

    private func saveCurrentVerseForWidget() {
        guard let currentVerse else { return }
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.lowen.thevivle") else { return }

        sharedDefaults.set(currentVerse.verseTitle, forKey: "widgetVerseTitle")
        sharedDefaults.set(currentVerse.verseShortTitle, forKey: "widgetVerseReference")
        sharedDefaults.set(currentVerse.scriptureText, forKey: "widgetVerseText")
        sharedDefaults.synchronize()

        WidgetCenter.shared.reloadAllTimelines()
    }

    private func scheduleMorningNotificationForCurrentVerse() {
        guard let currentVerse else { return }

        NotificationManager.shared.scheduleMorningVerseNotification(
            verseText: currentVerse.scriptureText,
            reference: currentVerse.verseShortTitle
        )
    }

    private func loadVersesIfNeeded() {
        guard verses.isEmpty else { return }
        verses = VerseLoader.loadVerses()
    }

    private func loadCurrentHourlyVerse() {
        currentVerse = VerseSelector.verse(from: verses)
    }

    private func updateRemainingTimeText() {
        let seconds = Int(VerseSelector.secondsUntilNextHour())
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60

        if minutes > 0 {
            remainingTimeText = "Next in \(minutes)m"
        } else {
            remainingTimeText = "Next in \(remainingSeconds)s"
        }
    }

    private func startHourlyRefresh() {
        refreshTask?.cancel()

        refreshTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)

                guard !Task.isCancelled else { return }

                await MainActor.run {
                    guard let self else { return }

                    self.updateRemainingTimeText()

                    let components = Calendar.current.dateComponents([.minute, .second], from: Date())
                    if components.minute == 0 && components.second == 0 {
                        self.loadCurrentHourlyVerse()
                    }
                }
            }
        }
    }
}

private extension String {
    var normalizedForSearch: String {
        folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private extension ScriptureVerse {
    var searchText: String {
        [
            volumeTitle,
            bookTitle,
            bookShortTitle,
            verseTitle,
            verseShortTitle,
            "\(bookTitle) \(chapterNumber):\(verseNumber)",
            "\(bookShortTitle) \(chapterNumber):\(verseNumber)",
            scriptureText
        ]
        .joined(separator: " ")
        .normalizedForSearch
    }
}
