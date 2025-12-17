import SwiftUI
import PhotosUI
import UIKit

struct GratitudeJournalView: View {
    @State private var vm = GratitudeJournalViewModel()
    @State private var text = ""
    @State private var mood: String?
    @State private var showConfetti = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    
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
                        journalTextEditor
                        photoPickerSection
                        moodSelectionSection
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
            .onAppear(perform: loadTodayEntry)
        }
    }
    
    // MARK: - Sub Views
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Apa yang membuatmu bersyukur hari ini?")
                .font(.title2.bold())
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            Text(Date(), format: .dateTime.day().month(.wide).year())
                .font(.headline)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    private var journalTextEditor: some View {
        TextEditor(text: $text)
            .scrollContentBackground(.hidden)
            .background(.regularMaterial)
            .cornerRadius(16)
            .frame(minHeight: 250, maxHeight: 350)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal)
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text("Tuliskan apa saja yang kamu syukuri hari ini...")
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                }
            }
            .accessibilityLabel("Entri jurnal syukur")
    }
    
    private var photoPickerSection: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            Label("Tambah Foto (Opsional)", systemImage: "photo")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))
                .padding(12)
                .background(.white.opacity(0.15))
                .cornerRadius(12)
        }
        .padding(.horizontal)
        .onChange(of: selectedPhoto) { _, new in
            Task {
                photoData = try? await new?.loadTransferable(type: Data.self)
            }
        }
    }
    
    private var moodSelectionSection: some View {
        VStack(spacing: 12) {
            Text("Bagaimana perasaanmu hari ini?")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 16) {
                ForEach(moods.indices, id: \.self) { i in
                    moodButton(for: i)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func moodButton(for index: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                mood = moods[index]
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            VStack(spacing: 8) {
                Text(moodEmojis[index])
                    .font(.system(size: mood == moods[index] ? 60 : 48))
                Text(moods[index])
                    .font(.caption.bold())
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(mood == moods[index] ? .white.opacity(0.3) : .white.opacity(0.15))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(mood == moods[index] ? .white : .clear, lineWidth: 2)
            )
        }
        .accessibilityLabel("Pilih mood \(moods[index])")
    }
    
    private var saveButtonSection: some View {
        Button {
            vm.addEntry(text: text, mood: mood, photoData: photoData)
            triggerCelebration()
        } label: {
            Text(vm.entryForToday() != nil ? "Update Entri Hari Ini" : "Simpan Entri Hari Ini")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            isSaveEnabled
                            ? LinearGradient(colors: [.teal, .blue], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [.gray.opacity(0.7), .gray.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                        )
                        .shadow(radius: isSaveEnabled ? 8 : 0)
                )
                .foregroundStyle(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSaveEnabled ? .clear : .white.opacity(0.3), lineWidth: 1)
                )
                .opacity(isSaveEnabled ? 1.0 : 0.7)  // Bonus: sedikit fade saat disabled
        }
        .padding(.horizontal, 32)
        .disabled(!isSaveEnabled)
        .accessibilityHint(!isSaveEnabled ? "Isi teks dulu untuk simpan" : "Simpan entri")
    }
    
    // MARK: - Helpers
    
    private var isSaveEnabled: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func loadTodayEntry() {
        if let today = vm.entryForToday() {
            text = today.text
            mood = today.mood
            photoData = today.photoData
        }
    }
    
    private func triggerCelebration() {
        showConfetti = true
        text = ""
        mood = nil
        photoData = nil
        selectedPhoto = nil
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation { showConfetti = false }
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
