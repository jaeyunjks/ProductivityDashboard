import Foundation

struct Affirmation: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let author: String
}
