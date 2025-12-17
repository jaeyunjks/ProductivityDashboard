import Foundation

struct GratitudeEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var mood: String?
    var gratefulFor: String
    var makeGreat: String
    var amazingThings: String
    // var photoData: Data?  // Uncomment kalau masih pakai photo dari konsep lama
    
    // MARK: - Computed Properties untuk UI
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")  // Bahasa Indonesia
        formatter.dateFormat = "EEEE"  // Hari nama lengkap: Senin, Selasa, dll
        return formatter.string(from: date).capitalized
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateStyle = .long  // Contoh: 17 Desember 2025
        return formatter.string(from: date)
    }
    
    // Bonus: kalau mau short version, misal "17 Des"
    var shortFormattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
    
    // Text utama untuk card (gabung 3 field biar nggak kosong)
    var text: String {
        let components = [
            gratefulFor.isEmpty ? nil : "I'm grateful for: \(gratefulFor)",
            makeGreat.isEmpty ? nil : "What would make today great: \(makeGreat)",
            amazingThings.isEmpty ? nil : "Amazing things today: \(amazingThings)"
        ].compactMap { $0 }
        
        return components.isEmpty ? "Belum ada entri hari ini" : components.joined(separator: "\n\n")
    }
}
