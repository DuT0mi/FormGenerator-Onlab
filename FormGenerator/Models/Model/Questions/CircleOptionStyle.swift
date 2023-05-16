import Foundation

struct CircleOption: Identifiable, Equatable {
    let id: UUID = UUID()
    let multilpleTypeValue: String?
    let trueOrFalseTypeValue: Bool?
    
    init(multilpleTypeValue: String? = nil, trueOrFalseTypeValue: Bool? = nil) {
        self.multilpleTypeValue = multilpleTypeValue
        self.trueOrFalseTypeValue = trueOrFalseTypeValue
    }
}
