import SwiftUI

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
                    .padding(.horizontal, 36)
                    .frame(maxWidth: 380)
                    .fixedSize(horizontal: false, vertical: true)
                
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
