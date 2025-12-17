import SwiftUI

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
                    .foregroundColor(isSelected ? .teal3 : .textDark.opacity(0.7))
                Text(title)
                    .font(.headline)
                    .foregroundColor(.textDark)
            }
            .frame(maxWidth: .infinity, minHeight: 140)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(isSelected ? Color.teal3 : Color.clear, lineWidth: 3))
        }
        .popover(isPresented: $showDesc) {
            Text(description).padding(12).background(Color.teal1).cornerRadius(12)
        }
        .onHover { showDesc = $0 }
    }
}
