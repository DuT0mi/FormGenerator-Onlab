import Foundation

@MainActor
final class FormListViewModel: ObservableObject {
    @Published private(set) var forms: [FormData] = []
    @Published private(set) var account: Account?
    @Published private(set) var isAccountLoaded: Bool
    
    private let authManager: AuthenticationManager = AuthenticationManager()
    
    init(){
        _isAccountLoaded = .init(wrappedValue: false)
    }
    
    func loadCurrentAccount() async throws {
        let authDataResult = try await authManager.getAuthenticatedUser()
        let (account,_) = try await AccountManager.shared.getUserByJustID(userID: authDataResult.uid)
        self.account = account
        // Must to adjust it true, and not toggle because of the User can tap back from creating the View and then will disappear the oppurtinity to create
        self.isAccountLoaded = true
    }
    func downloadAllForm(){
        Task{
            self.forms = try await FormManager.shared.downloadAllForm()
        }
    }
}
