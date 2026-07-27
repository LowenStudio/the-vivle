import Foundation

enum VerseSelector {
    static func verse(for date: Date = Date(), from verses: [ScriptureVerse]) -> ScriptureVerse? {
        guard !verses.isEmpty else { return nil }

        let hourIndex = Calendar.current.dateComponents(
            [.hour],
            from: Date(timeIntervalSince1970: 0),
            to: date
        ).hour ?? 0

        let verseIndex = seededIndex(for: hourIndex, count: verses.count)
        return verses[verseIndex]
    }

    private static func seededIndex(for hourIndex: Int, count: Int) -> Int {
        let seed = abs(hourIndex)
        let mixed = (seed &* 1_103_515_245 &+ 12_345) & 0x7fffffff
        return mixed % count
    }

    static func secondsUntilNextHour(from date: Date = Date()) -> TimeInterval {
        let calendar = Calendar.current

        guard let nextHour = calendar.nextDate(
            after: date,
            matching: DateComponents(minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) else {
            return 3600
        }

        return max(1, nextHour.timeIntervalSince(date))
    }

    static func randomVerse(
        from verses: [ScriptureVerse],
        excluding currentVerse: ScriptureVerse?
    ) -> ScriptureVerse? {
        guard !verses.isEmpty else { return nil }

        guard verses.count > 1, let currentVerse else {
            return verses.randomElement()
        }

        var nextVerse = verses.randomElement()

        while nextVerse?.id == currentVerse.id {
            nextVerse = verses.randomElement()
        }

        return nextVerse
    }
}
