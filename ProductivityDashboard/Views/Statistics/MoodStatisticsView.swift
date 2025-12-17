import SwiftUI
import Charts

struct MoodStatisticsView: View {
    @Bindable var viewModel: GratitudeJournalViewModel  // Tetap pakai @Bindable (bagus untuk future binding kalau perlu)
    
    var body: some View {
        ZStack {
            DreamyBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Text("Insights Gratitude")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.textLight)
                        .padding(.top, 40)
                    
                    // Streak – sekarang tanpa ()
                    Text("Streak Hari Ini: \(viewModel.streakDays) hari")
                        .font(.title2)
                        .foregroundColor(.teal3)
                    
                    // Mood Chart
                    if !viewModel.moodDistribution.isEmpty {
                        Chart {
                            ForEach(Array(viewModel.moodDistribution.sorted(by: { $0.value > $1.value })), id: \.key) { mood, count in
                                BarMark(
                                    x: .value("Mood", mood),
                                    y: .value("Jumlah", count)
                                )
                                .foregroundStyle(by: .value("Mood", mood))
                                .annotation(position: .top) {
                                    Text("\(count)")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .chartForegroundStyleScale(domain: Array(viewModel.moodDistribution.keys), range: [.teal, .blue, .purple, .pink, .orange])
                        .frame(height: 300)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    } else {
                        Text("Belum ada data mood untuk ditampilkan")
                            .foregroundColor(.textLight.opacity(0.7))
                            .padding()
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MoodStatisticsView(viewModel: GratitudeJournalViewModel())
}
