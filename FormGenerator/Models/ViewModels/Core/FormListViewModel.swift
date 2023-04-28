import Foundation
import FirebaseFirestore

@MainActor
final class FormListViewModel: ObservableObject {
    @Published private(set) var forms: [FormData] = []
    @Published private(set) var account: Account?
    @Published private(set) var isAccountLoaded: Bool
    @Published private(set) var allFormCountOnServer: Int?
    private let authManager: AuthenticationManager = AuthenticationManager()
    private var lastDocument: DocumentSnapshot?
    
    init(){
        _isAccountLoaded = .init(wrappedValue: false)
    }
    
    private func getAllFormCount() async throws -> Int {
            try await FormManager.shared.getAllFormCount()
    }
    
    func loadCurrentAccount() async throws {
        let authDataResult = try authManager.getAuthenticatedUser()
        let (account,_) = try await AccountManager.shared.getUserByJustID(userID: authDataResult.uid)
        self.account = account
        // Must to adjust it true, and not toggle because of the User can tap back from creating the View and then will disappear the oppurtinity to create
        self.isAccountLoaded = true
    }
    func downloadAllForm(withoutLimit: Bool = false){
        Task{            
            let (newForm, lastDocument) = try await FormManager.shared.downloadAllForm(limit: withoutLimit ? getAllFormCount() : FormConstants.defaultDownloadingLimit, lastDocument: lastDocument)
            self.forms.append(contentsOf: newForm)
            if let lastDocument{
                self.lastDocument = lastDocument
            }
            self.allFormCountOnServer = try await getAllFormCount()
        }
    }
    func pullRefreshDownloadAllForm() {
        Task{
            if try await FormManager.shared.getAllFormCount() > 0 {
                self.forms = []
                self.lastDocument = nil
                downloadAllForm(withoutLimit: true)
            }
        }
    }
}
