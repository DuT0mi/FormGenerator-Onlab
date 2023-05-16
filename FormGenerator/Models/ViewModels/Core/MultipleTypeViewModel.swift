import Foundation

@MainActor
final class MultipleTypeViewModel: ObservableObject{
    @Published var options: [CircleOption] = []
    @Published var selectedOption: String?
    
    func loadQuestions(choices: [String]){
        options.reserveCapacity(choices.count)
        choices.forEach { options.append(CircleOption(multilpleTypeValue: $0.description)) }
    }
    
}
