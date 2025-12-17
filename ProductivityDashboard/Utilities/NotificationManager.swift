import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Gratitude Time!"
        content.body = "Apa yang kamu syukuri hari ini?"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20  // Jam 8 malam
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyGratitude", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
