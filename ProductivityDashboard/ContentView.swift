import SwiftUI

// MARK: - Soft Pastel Colors
extension Color {
    static let pink1 = Color(red: 1.00, green: 0.92, blue: 0.95)
    static let pink2 = Color(red: 0.98, green: 0.85, blue: 0.92)
    static let pink3 = Color(red: 0.95, green: 0.78, blue: 0.90)
    static let textDark = Color(red: 0.15, green: 0.15, blue: 0.18)
}

extension ShapeStyle where Self == Color {
    static var pink1: Color { .pink1 }
    static var pink2: Color { .pink2 }
    static var pink3: Color { .pink3 }
}

// MARK: - Dreamy Animated Background
struct DreamyBackground: View {
    @State private var phase = 0.0
    
    var body: some View {
        ZStack {
            ForEach(0..<6) { i in
                Circle()
                    .fill(AngularGradient(colors: [.pink1, .pink2, .pink3.opacity(0.6), .pink1], center: .center))
                    .frame(width: 380 + CGFloat(i * 90))
                    .rotationEffect(.degrees(phase + Double(i) * 30))
                    .offset(x: sin(phase * 0.01 + Double(i)) * 100,
                            y: cos(phase * 0.01 + Double(i)) * 150)
                    .blur(radius: 80)
                    .opacity(0.7)
            }
        }
        .background(Color.pink1)
        .onAppear {
            withAnimation(.linear(duration: 40).repeatForever(autoreverses: false)) {
                phase = 360
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Model
struct Affirmation: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let author: String
}

// MARK: - Mood Card
struct MoodGlassCard: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var showDesc = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundColor(isSelected ? .pink3 : .textDark.opacity(0.7))
                Text(title)
                    .font(.headline)
                    .foregroundColor(.textDark)
            }
            .frame(maxWidth: .infinity, minHeight: 140)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(isSelected ? Color.pink3 : Color.clear, lineWidth: 3))
        }
        .popover(isPresented: $showDesc) {
            Text(description).padding(12).background(Color.pink1).cornerRadius(12)
        }
        .onHover { showDesc = $0 }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @State private var hovered = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.pink3)
                .frame(width: 50)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.title3.bold()).foregroundColor(.textDark)
                Text(subtitle).font(.subheadline).foregroundColor(.textDark.opacity(0.7))
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.textDark.opacity(0.5))
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .scaleEffect(hovered ? 1.02 : 1.0)
        .onHover { hovered = $0 }
    }
}

// MARK: - HOME DASHBOARD
struct ContentView: View {
    @State private var selectedMood = ""
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
                    VStack(spacing: 8) {
                        Text("Good Morning")
                            .font(.title2)
                            .foregroundColor(.textDark.opacity(0.7))
                        Text("How are you feeling?")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.textDark)
                    }
                    .padding(.top, 50)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(moods, id: \.1) { icon, title, desc in
                            MoodGlassCard(icon: icon, title: title, description: desc, isSelected: selectedMood == title) {
                                withAnimation(.spring()) { selectedMood = title }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 18) {
                        NavigationLink(destination: DailyAffirmationView()) {
                            FeatureRow(icon: "heart.text.square.fill", title: "Daily Affirmation", subtitle: "Swipe up for new magic")
                        }
                        FeatureRow(icon: "pencil.and.list.clipboard", title: "Gratitude Journal", subtitle: "Write 3 things today")
                        FeatureRow(icon: "chart.bar.fill", title: "Mood Tracker", subtitle: "See your weekly pattern")
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.pink1.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}
// MARK: - DAILY AFFIRMATION – FIX OUT OF FRAME + UKURAN SEMPURNA
struct DailyAffirmationView: View {
    private let affirmations: [Affirmation] = [
        Affirmation(text: "You are enough, exactly as you are.", author: "Your Heart"),
        Affirmation(text: "Your energy creates your reality.", author: "Universe"),
        Affirmation(text: "Peace begins with a single breath.", author: "Inner Calm"),
        Affirmation(text: "You are growing in beautiful ways.", author: "Growth"),
        Affirmation(text: "Today is full of quiet miracles.", author: "Hope"),
        Affirmation(text: "You deserve rest and kindness.", author: "Self Love"),
        Affirmation(text: "Your presence lights up the world.", author: "The World"),
        Affirmation(text: "You are becoming your highest self.", author: "Destiny")
    ]
    
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    var current: Affirmation { affirmations[currentIndex] }
    
    var body: some View {
        ZStack {
            DreamyBackground()
            
            VStack(spacing: 32) {
                Spacer()
                
                Text("“\(current.text)”")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.35), radius: 8)
                    .multilineTextAlignment(.center)
                    .lineSpacing(9)
                    .padding(.horizontal, 36)           // margin aman
                    .frame(maxWidth: 380)               // batas maksimal lebar
                    .fixedSize(horizontal: false, vertical: true) // biar nggak terpotong
                
                Text("— \(current.author) —")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.92))
                
                Spacer()
                
                Text("Swipe up for next affirmation")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 50)
            }
            .offset(y: dragOffset)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height < 0 {
                            dragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height < -140 {
                            withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
                                currentIndex = (currentIndex + 1) % affirmations.count
                                dragOffset = -1000
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                                dragOffset = 1000
                                withAnimation(.spring(response: 0.8)) { dragOffset = 0 }
                            }
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } else {
                            withAnimation(.spring()) { dragOffset = 0 }
                        }
                    }
            )
        }
        .navigationTitle("Affirmation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
