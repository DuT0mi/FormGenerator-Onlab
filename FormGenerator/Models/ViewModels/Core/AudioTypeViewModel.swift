import Foundation

@MainActor
final class AudioTypeViewModel: ObservableObject {
    @Published var answer: String = ""
}
