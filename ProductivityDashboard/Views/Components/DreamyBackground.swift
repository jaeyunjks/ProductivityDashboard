import SwiftUI

struct DreamyBackground: View {
    @State private var phase = 0.0
    
    var body: some View {
        ZStack {
            ForEach(0..<6) { i in
                Circle()
                    .fill(AngularGradient(colors: [.teal1, .teal2, .teal3.opacity(0.6), .teal1], center: .center))
                    .frame(width: 380 + CGFloat(i * 90))
                    .rotationEffect(.degrees(phase + Double(i) * 30))
                    .offset(x: sin(phase * 0.01 + Double(i)) * 100,
                            y: cos(phase * 0.01 + Double(i)) * 150)
                    .blur(radius: 80)
                    .opacity(0.7)
            }
        }
        .background(Color.teal1)
        .onAppear {
            withAnimation(.linear(duration: 40).repeatForever(autoreverses: false)) {
                phase = 360
            }
        }
        .ignoresSafeArea()
    }
}
