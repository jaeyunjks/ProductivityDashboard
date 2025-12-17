import Foundation
import Observation

@Observable
class GratitudeJournalViewModel {
    private let storageKey = "gratitude_entries"
    
    var entries: [GratitudeEntry] = [] {
        didSet { saveToStorage() }
    }
    
    init() { loadFromStorage() }
    
    func addEntry(text: String, mood: String?, photoData: Data?) {
        let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedText.isEmpty else { return }
        
        let today = Calendar.current.startOfDay(for: Date())
        if let index = entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            entries[index].text = cleanedText
            entries[index].mood = mood
            entries[index].photoData = photoData
        } else {
            let new = GratitudeEntry(date: Date(), text: cleanedText, mood: mood, photoData: photoData)
            entries.insert(new, at: 0)
        }
    }
    
    func entryForToday() -> GratitudeEntry? {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    // New: Filter for search
    func filteredEntries(searchText: String, moodFilter: String?) -> [GratitudeEntry] {
        entries.filter { entry in
            (searchText.isEmpty || entry.text.lowercased().contains(searchText.lowercased())) &&
            (moodFilter == nil || entry.mood == moodFilter)
        }
    }
    
    // New: Stats calculation
    func moodDistribution() -> [String: Int] {
        entries.reduce(into: [:]) { $0[$1.mood ?? "Unknown", default: 0] += 1 }
    }
    
    func streakDays() -> Int {
        guard !entries.isEmpty else { return 0 }
        let sortedDates = entries.sorted { $0.date > $1.date }.map { Calendar.current.startOfDay(for: $0.date) }
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
    
    private func saveToStorage() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func loadFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([GratitudeEntry].self, from: data)
        else { return }
        entries = decoded
    }
}
