import SwiftUI

struct GratitudeHistoryView: View {
    @Bindable var viewModel: GratitudeJournalViewModel
    @State private var searchText = ""
    @State private var moodFilter: String?
    
    private let moodEmojis = ["😊", "🙏", "🥰", "😌", "💪"]  // Happy, Grateful, Loved, Calm, Strong
    
    var body: some View {
        NavigationStack {
            ZStack {
                DreamyBackground()
                    .ignoresSafeArea()
                
                if viewModel.entries.isEmpty {
                    emptyStateView
                } else {
                    historyContentView
                }
            }
            .navigationTitle("Riwayat Entry")
            .navigationBarTitleDisplayMode(.inline)
            // Animasi global halus saat filter/search berubah
            .animation(.easeInOut(duration: 0.3), value: searchText)
            .animation(.easeInOut(duration: 0.3), value: moodFilter)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.textLight.opacity(0.6))
            
            Text("Belum ada entry")
                .font(.title2.bold())
                .foregroundColor(.textLight)
            
            Text("Mulai tulis jurnal syukur hari ini ya!")
                .font(.subheadline)
                .foregroundColor(.textLight.opacity(0.7))
        }
    }
    
    // MARK: - Main History Content
    private var historyContentView: some View {
        VStack(spacing: 20) {
            searchBarView
            moodFilterView
            entriesListView
        }
    }
    
    // MARK: - Search Bar
    private var searchBarView: some View {
        TextField("Cari keyword di entry...", text: $searchText)
            .padding(14)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .padding(.horizontal)
            .submitLabel(.search)
    }
    
    // MARK: - Mood Filter
    private var moodFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button("All") {
                    moodFilter = nil
                }
                .padding(10)
                .background(moodFilter == nil ? Color.teal3 : Color.clear)
                .foregroundColor(moodFilter == nil ? .white : .textLight)
                .clipShape(Circle())
                
                ForEach(moodEmojis, id: \.self) { mood in
                    Button(mood) {
                        moodFilter = moodFilter == mood ? nil : mood
                    }
                    .font(.title2)
                    .padding(12)
                    .background(moodFilter == mood ? Color.teal3 : Color.clear)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.teal3.opacity(0.4), lineWidth: moodFilter == mood ? 0 : 2)
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Entries List
    private var entriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(filteredEntries) { entry in
                    GratitudeCard(entry: entry)
                        .transition(.opacity.combined(with: .scale))
                }
                
                Color.clear
                    .frame(height: 100)
            }
            .padding(.horizontal, 8)
        }
    }
    
    // MARK: - Filtered Entries
    private var filteredEntries: [GratitudeEntry] {
        viewModel.entries
            .filter { entry in
                // Search filter
                if !searchText.isEmpty {
                    let lowerSearch = searchText.lowercased()
                    return entry.gratefulFor.lowercased().contains(lowerSearch) ||
                           entry.makeGreat.lowercased().contains(lowerSearch) ||
                           entry.amazingThings.lowercased().contains(lowerSearch)
                }
                
                // Mood filter
                if let filter = moodFilter {
                    return entry.mood == moodFromEmoji(filter)
                }
                
                return true
            }
            .sorted { $0.date > $1.date }  // Terbaru di atas
    }
    
    // MARK: - Helper: Emoji → Mood String
    private func moodFromEmoji(_ emoji: String) -> String? {
        let map: [String: String] = [
            "😊": "Happy",
            "🙏": "Grateful",
            "🥰": "Loved",
            "😌": "Calm",
            "💪": "Strong"
        ]
        return map[emoji]
    }
}

#Preview {
    GratitudeHistoryView(viewModel: GratitudeJournalViewModel())
}
