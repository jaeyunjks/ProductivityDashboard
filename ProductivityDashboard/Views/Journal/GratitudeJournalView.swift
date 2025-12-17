import SwiftUI
import UIKit  // Untuk haptic

struct GratitudeJournalView: View {
    @State private var vm = GratitudeJournalViewModel()
    @State private var selectedDate = Date()
    @State private var mood: String?
    @State private var gratefulFor = ""
    @State private var makeGreat = ""
    @State private var amazingThings = ""
    @State private var showConfetti = false
    @State private var showTimer = false  // Optional timer toggle
    
    private let moods = ["Grateful", "Happy", "Calm", "Loved", "Strong"]
    private let moodEmojis = ["🙏", "😊", "🧘‍♀️", "❤️", "💪"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                DreamyBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        headerSection
                        moodSection
                        textBoxSection(for: "I'm grateful for...", text: $gratefulFor)
                        textBoxSection(for: "What would make today great?", text: $makeGreat)
                        textBoxSection(for: "What are some amazing things that happened today?", text: $amazingThings)
                        saveButtonSection
                        Spacer(minLength: 50)
                    }
                }
                
                if showConfetti {
                    ConfettiRain()
                        .transition(.opacity.combined(with: .scale))
                        .zIndex(1)
                }
            }
            .navigationTitle("Jurnal Syukur")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { loadEntryForSelectedDate() }
            .onChange(of: selectedDate) { loadEntryForSelectedDate() }
        }
    }
    
    // MARK: - Sub Views
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            DatePicker("Pilih Tanggal", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .colorScheme(.dark)  // Aesthetic dark mode
                .padding(.horizontal)
            
            Text("Take 5 minutes to reflect today")
                .font(.headline.italic())
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    private var moodSection: some View {
        VStack(spacing: 12) {
            Text("How is your mood for today?")
                .font(.title3.bold())
                .foregroundStyle(.white.opacity(0.9))
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 16)], spacing: 16) {
                ForEach(moods.indices, id: \.self) { i in
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            mood = moods[i]
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        VStack(spacing: 4) {
                            Text(moodEmojis[i])
                                .font(.system(size: mood == moods[i] ? 50 : 40))
                            Text(moods[i])
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                        }
                        .padding(12)
                        .background(mood == moods[i] ? .white.opacity(0.3) : .white.opacity(0.15))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(mood == moods[i] ? .white : .clear, lineWidth: 1.5)
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func textBoxSection(for prompt: String, text: Binding<String>) -> some View {
        TextEditor(text: text)
            .scrollContentBackground(.hidden)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .frame(height: 150)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal)
            .overlay(alignment: .topLeading) {
                if text.wrappedValue.isEmpty {
                    Text(prompt)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                }
            }
            .accessibilityLabel(prompt)
    }
    
    private var saveButtonSection: some View {
        Button {
            vm.addEntry(mood: mood, gratefulFor: gratefulFor, makeGreat: makeGreat, amazingThings: amazingThings, for: selectedDate)
            showConfetti = true
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { showConfetti = false }
            }
        } label: {
            Text(entryForSelectedDate != nil ? "Update Entri" : "Simpan Entri")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(colors: [.teal, .blue], startPoint: .leading, endPoint: .trailing))
                )
                .foregroundStyle(.white)
                .shadow(radius: 8)
        }
        .padding(.horizontal, 32)
        .disabled(gratefulFor.isEmpty && makeGreat.isEmpty && amazingThings.isEmpty)
        .opacity(gratefulFor.isEmpty && makeGreat.isEmpty && amazingThings.isEmpty ? 0.6 : 1.0)
        .accessibilityHint(gratefulFor.isEmpty && makeGreat.isEmpty && amazingThings.isEmpty ? "Isi setidaknya satu field" : "Simpan entri hari ini")
    }
    
    // MARK: - Helpers
    
    private var entryForSelectedDate: GratitudeEntry? {
        vm.entryForDate(selectedDate)
    }
    
    private func loadEntryForSelectedDate() {
        if let entry = entryForSelectedDate {
            mood = entry.mood
            gratefulFor = entry.gratefulFor
            makeGreat = entry.makeGreat
            amazingThings = entry.amazingThings
        } else {
            mood = nil
            gratefulFor = ""
            makeGreat = ""
            amazingThings = ""
        }
    }
}

// ConfettiRain (tetap sama, enhanced)
struct ConfettiRain: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<100) { _ in
                Text(randomEmoji())
                    .font(.system(size: CGFloat.random(in: 20...60)))
                    .foregroundStyle(randomColor())
                    .rotationEffect(.degrees(Double.random(in: -90...90)))
                    .offset(
                        x: CGFloat.random(in: -geometry.size.width/2...geometry.size.width*1.5),
                        y: CGFloat.random(in: -geometry.size.height...0)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 2...5))
                            .repeatForever(autoreverses: false),
                        value: UUID()
                    )
            }
        }
        .ignoresSafeArea()
        .blendMode(.screen)
    }
    
    private func randomEmoji() -> String {
        ["❤️", "💖", "✨", "🌟", "🎉", "🎊", "🦋", "🌈", "💫", "🌸", "🙏", "😊", "🥳"].randomElement()!
    }
    
    private func randomColor() -> Color {
        [.pink, .yellow, .blue, .green, .purple, .orange].randomElement()!
    }
}

#Preview {
    GratitudeJournalView()
}
