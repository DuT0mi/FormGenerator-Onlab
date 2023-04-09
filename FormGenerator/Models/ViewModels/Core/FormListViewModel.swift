import Foundation

@MainActor
final class FormListViewModel: ObservableObject {
    @Published private(set) var account: Account?
    @Published private(set) var isAccountLoaded: Bool
    
    init(){
        _isAccountLoaded = .init(wrappedValue: false)
    }
    
    private let authManager: AuthenticationManager = AuthenticationManager()
    
    func loadCurrentAccount() async throws {
        let authDataResult = try authManager.getAuthenticatedUser()
        self.account = try await AccountManager.shared.getUserByJustID(userID: authDataResult.uid)
        self.isAccountLoaded = true
    }
}
