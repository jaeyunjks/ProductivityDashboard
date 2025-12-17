import Foundation

struct GratitudeEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var text: String  // Ganti dari [String] ke single text biar flexibel
    var mood: String?  // Emoji mood
    var photoData: Data?  // Optional photo as Data
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: date)
    }
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: date)
    }
}
