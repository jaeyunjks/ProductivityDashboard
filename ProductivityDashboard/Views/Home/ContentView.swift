import SwiftUI

struct ContentView: View {
    @State private var selectedMood = ""
    @State private var journalVM = GratitudeJournalViewModel()  // Tetap @State karena @Observable
    
    private let moods = [
        ("brain.head.profile", "Focused", "Clear mind, ready to work"),
        ("heart.fill", "Grateful", "Feeling thankful today"),
        ("face.smiling", "Joyful", "Full of positive energy"),
        ("cloud.sun", "Calm", "Peaceful and relaxed"),
        ("moon.stars", "Tired", "Need rest & recharge")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Good Morning")
                            .font(.title2)
                            .foregroundColor(.textDark.opacity(0.7))
                        Text("How are you feeling?")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.textDark)
                    }
                    .padding(.top, 50)
                    
                    // Mood Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(moods, id: \.1) { icon, title, desc in
                            MoodGlassCard(icon: icon, title: title, description: desc, isSelected: selectedMood == title) {
                                withAnimation(.spring()) { selectedMood = title }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Calendar Overview (Today's Entry) – sekarang tanpa ()
                    if let todayEntry = journalVM.entryForToday {
                        VStack(alignment: .leading) {
                            Text("Entry Hari Ini")
                                .font(.headline)
                            Text(todayEntry.text.prefix(100) + (todayEntry.text.count > 100 ? "..." : ""))
                                .font(.subheadline)
                                .foregroundColor(.textDark.opacity(0.7))
                        }
                        .padding(20)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
                        .padding(.horizontal, 20)
                    }
                    
                    // Features
                    VStack(spacing: 18) {
                        NavigationLink(destination: DailyAffirmationView()) {
                            FeatureRow(icon: "heart.text.square.fill", title: "Daily Affirmation", subtitle: "Swipe up for new magic")
                        }
                        
                        NavigationLink(destination: GratitudeJournalView()) {
                            FeatureRow(icon: "pencil.and.list.clipboard", title: "Gratitude Journal", subtitle: "Write today's entry")
                        }
                        
                        // Pass journalVM dengan benar ke MoodStatisticsView
                        NavigationLink {
                            MoodStatisticsView(viewModel: journalVM)
                        } label: {
                            FeatureRow(icon: "chart.bar.fill", title: "Statistics", subtitle: "See your patterns")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.teal1.ignoresSafeArea())
            .navigationBarHidden(true)
            // Share ViewModel ke semua child view
            .environment(journalVM)
        }
    }
}

#Preview {
    ContentView()
}
