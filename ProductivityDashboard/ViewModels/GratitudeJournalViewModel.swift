import Foundation
import Observation

@Observable
final class GratitudeJournalViewModel {
    private let storageKey = "gratitude_entries"
    
    var entries: [GratitudeEntry] = [] {
        didSet { saveToStorage() }
    }
    
    init() {
        loadFromStorage()
    }
    
    // MARK: - Add / Update Entry
    func addEntry(mood: String?,
                  gratefulFor: String,
                  makeGreat: String,
                  amazingThings: String,
                  for date: Date) {
        
        let cleanedGrateful = gratefulFor.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedMake = makeGreat.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedAmazing = amazingThings.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Simpan kalau ada setidaknya satu field yang terisi
        guard !cleanedGrateful.isEmpty || !cleanedMake.isEmpty || !cleanedAmazing.isEmpty else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        if let index = entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }) {
            // Update existing entry
            entries[index].mood = mood
            entries[index].gratefulFor = cleanedGrateful
            entries[index].makeGreat = cleanedMake
            entries[index].amazingThings = cleanedAmazing
        } else {
            // Create new entry
            let newEntry = GratitudeEntry(
                date: startOfDay,
                mood: mood,
                gratefulFor: cleanedGrateful,
                makeGreat: cleanedMake,
                amazingThings: cleanedAmazing
            )
            entries.insert(newEntry, at: 0)
        }
    }
    
    // MARK: - Computed Properties (untuk akses cepat di View)
    
    /// Entry untuk hari ini (tanpa perlu panggil function)
    var entryForToday: GratitudeEntry? {
        entryForDate(Date())
    }
    
    /// Entry untuk tanggal tertentu
    func entryForDate(_ date: Date) -> GratitudeEntry? {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }
    }
    
    /// Current streak (hari berturut-turut ada entry)
    var streakDays: Int {
        guard !entries.isEmpty else { return 0 }
        
        let sortedDates = entries
            .sorted { $0.date > $1.date }
            .map { Calendar.current.startOfDay(for: $0.date) }
        
        var streak = 1
        for i in 1..<sortedDates.count {
            if Calendar.current.date(byAdding: .day, value: -1, to: sortedDates[i-1]) == sortedDates[i] {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }
    
    /// Distribusi mood (untuk chart)
    var moodDistribution: [String: Int] {
        entries.reduce(into: [:]) { result, entry in
            let mood = entry.mood ?? "Unknown"
            result[mood, default: 0] += 1
        }
    }
    
    // MARK: - Persistence (UserDefaults)
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([GratitudeEntry].self, from: data)
        else { return }
        
        entries = decoded
    }
}
