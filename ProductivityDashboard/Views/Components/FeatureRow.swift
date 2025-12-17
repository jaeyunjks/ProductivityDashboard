import SwiftUI

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @State private var hovered = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.teal3)
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
