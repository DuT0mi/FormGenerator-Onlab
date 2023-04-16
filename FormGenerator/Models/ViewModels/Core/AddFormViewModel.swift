import Foundation

@MainActor
final class AddFormViewModel: ObservableObject{
    @Published var isFormHasBeenAdded: Bool
    
    static let shared = AddFormViewModel()
   private init(){
        _isFormHasBeenAdded = .init(initialValue: false)
    }
}
