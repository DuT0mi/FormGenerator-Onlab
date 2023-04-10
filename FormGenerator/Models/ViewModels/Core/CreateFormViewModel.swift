import Foundation
import SwiftUI

@MainActor
final class CreateFormViewModel: ObservableObject {
    @Published private(set) var form: FormData?
    @Published var formText: String = ""
    @Published var formType: SelectedType = .none
    
    private var account: Account?
    private let authManager: AuthenticationManager = AuthenticationManager()
    
    private func loadCurrentAccount() async throws {
        let authDataResult = try authManager.getAuthenticatedUser()
        self.account = try await AccountManager.shared.getUserByJustID(userID: authDataResult.uid)
    }
    
    init(){
        Task{
            try? await loadCurrentAccount()
        }

    }
    
    func createForm() async throws {
        form = FormData(id: UUID(),
                        title: "Title",
                        type: formType.rawValue,
                        companyID: account?.userID ?? "Error",
                        description: "Desc",
                        answers: "Answers",
                        questions: formText)
        
    }
    func uploadForm() async throws {
        try await FormManager.shared.uploadFormToDatabase(form: form!)
    }
    
    // MARK: - Intent(s)
    func typeSelected(type: SelectedType) async throws {
        self.formType = type
    }
}

enum SelectedType: String, CaseIterable{
    case A
    case B
    case none
}
