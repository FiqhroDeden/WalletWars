//
//  NotificationService.swift
//  WalletWars
//

import Foundation
import UserNotifications

enum NotificationService {

    /// Request notification permission.
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    /// Schedule daily reminder to log expenses.
    static func scheduleDailyReminder(hour: Int = 20, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Time to log!"
        content.body = "Don't forget to record today's expenses. Keep your streak alive."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-reminder", content: content, trigger: trigger)
        center.add(request)
    }

    /// Schedule streak warning if no transaction logged by evening.
    static func scheduleStreakWarning(streakCount: Int) {
        guard streakCount >= 3 else { return } // Only warn if streak worth protecting

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["streak-warning"])

        let content = UNMutableNotificationContent()
        content.title = "Streak in danger!"
        content.body = "You have a \(streakCount)-day logging streak. Log one expense to keep it alive."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "streak-warning", content: content, trigger: trigger)
        center.add(request)
    }

    /// Cancel all pending notifications.
    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
