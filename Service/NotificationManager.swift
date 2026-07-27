

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private let morningVerseNotificationIdentifier = "morningVerseNotification"

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error:", error.localizedDescription)
                return
            }

            print("Notification permission granted:", granted)
        }
    }

    func scheduleMorningVerseNotification(verseText: String, reference: String) {
        let center = UNUserNotificationCenter.current()

        center.removePendingNotificationRequests(
            withIdentifiers: [morningVerseNotificationIdentifier]
        )

        let content = UNMutableNotificationContent()
        content.title = "Good morning"
        content.body = "\(verseText)\n— \(reference)"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 6
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: morningVerseNotificationIdentifier,
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Failed to schedule morning verse notification:", error.localizedDescription)
            } else {
                print("Morning verse notification scheduled.")
            }
        }
    }
}
