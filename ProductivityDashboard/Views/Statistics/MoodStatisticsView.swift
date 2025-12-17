import SwiftUI
import Charts

struct MoodStatisticsView: View {
    @Bindable var viewModel: GratitudeJournalViewModel
    
    var body: some View {
        ZStack {
            DreamyBackground()
            
            ScrollView {
                VStack(spacing: 32) {
                    Text("Insights Gratitude")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.textLight)
                        .padding(.top, 40)
                    
                    // Streak
                    Text("Streak Hari Ini: \(viewModel.streakDays()) hari")
                        .font(.title2)
                        .foregroundColor(.teal3)
                    
                    // Mood Chart
                    if !viewModel.moodDistribution().isEmpty {
                        Chart {
                            ForEach(Array(viewModel.moodDistribution()), id: \.key) { mood, count in
                                BarMark(x: .value("Mood", mood), y: .value("Count", count))
                                    .foregroundStyle(Color.teal2)
                            }
                        }
                        .frame(height: 250)
                        .padding()
                    } else {
                        Text("Belum ada data mood")
                            .foregroundColor(.textLight.opacity(0.7))
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }
}
