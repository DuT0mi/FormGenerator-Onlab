import Foundation

@MainActor
final class TrueOrFalseTypeViewModel: ObservableObject{
    @Published var selectedOption: Bool?
}
