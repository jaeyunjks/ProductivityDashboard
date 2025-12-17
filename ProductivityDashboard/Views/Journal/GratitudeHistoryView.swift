import SwiftUI

struct GratitudeHistoryView: View {
    @Bindable var viewModel: GratitudeJournalViewModel
    @State private var searchText = ""
    @State private var moodFilter: String?
    
    private let moods = ["😊", "🙏", "🥰", "😌", "💪"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                DreamyBackground()
                
                if viewModel.entries.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.textLight.opacity(0.6))
                        Text("Belum ada entry")
                            .font(.title2.bold())
                            .foregroundColor(.textLight)
                        Text("Mulai hari ini ya!")
                            .foregroundColor(.textLight.opacity(0.7))
                    }
                } else {
                    VStack {
                        // Search Bar
                        TextField("Cari keyword...", text: $searchText)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        // Mood Filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(moods, id: \.self) { mood in
                                    Button(mood) {
                                        moodFilter = moodFilter == mood ? nil : mood
                                    }
                                    .padding(8)
                                    .background(moodFilter == mood ? Color.teal3 : Color.clear)
                                    .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(viewModel.filteredEntries(searchText: searchText, moodFilter: moodFilter)) { entry in
                                    GratitudeCard(entry: entry)
                                }
                            }
                            .padding(24)
                        }
                    }
                }
            }
            .navigationTitle("Riwayat Entry")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
