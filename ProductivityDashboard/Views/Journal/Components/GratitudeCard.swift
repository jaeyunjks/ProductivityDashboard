import SwiftUI

struct GratitudeCard: View {
    let entry: GratitudeEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(entry.dayName)
                    .font(.title3.bold())
                    .foregroundColor(.textLight)
                if let mood = entry.mood {
                    Text(mood).font(.title2)
                }
                Spacer()
                Text(entry.formattedDate)
                    .font(.headline)
                    .foregroundColor(.textLight.opacity(0.8))
            }
            
            Text(entry.text)
                .font(.title3)
                .foregroundColor(.textLight)
                .multilineTextAlignment(.leading)
            
            if let data = entry.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(12)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.teal3.opacity(0.2), lineWidth: 1)
        )
    }
}
