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
                    Text(mood).font(.title2)  // Bisa diganti emoji kalau mau lebih aesthetic
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
                .lineSpacing(6)
            
            // Bagian foto sudah DIHAPUS karena konsep baru tidak pakai photo
            // Kalau nanti mau balik pakai foto, tinggal uncomment + tambah photoData ke GratitudeEntry lagi
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

#Preview {
    GratitudeCard(entry: GratitudeEntry(
        date: Date(),
        mood: "Happy",
        gratefulFor: "Keluarga dan teman-teman",
        makeGreat: "Menyelesaikan tugas penting",
        amazingThings: "Mendengar kabar baik dari sahabat"
    ))
}
