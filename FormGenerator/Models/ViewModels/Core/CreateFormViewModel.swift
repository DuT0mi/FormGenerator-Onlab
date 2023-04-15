import Foundation
import SwiftUI
import CoreData

@MainActor
final class CreateFormViewModel: ObservableObject {
    @Published private(set) var form: FormData?
    @Published var formText: String = ""
    @Published var formType: SelectedType = .none
    
    private var formQuestions: [Question] = []
    private var account: Account?
    private let authManager: AuthenticationManager = AuthenticationManager()
    
    private func loadCurrentAccount() async throws {
        let authDataResult = try await authManager.getAuthenticatedUser()
        let (account,_) = try await AccountManager.shared.getUserByJustID(userID: authDataResult.uid)
        self.account = account
    }
    
    init(){
        Task{
            try? await loadCurrentAccount()
        }

    }
    
    private func createForm(allData: FetchedResults<QuestionCoreData>, context: NSManagedObjectContext) async throws {
        allData.forEach { data in            
            self.formQuestions.append(Question(id: data.id!, formQuestion: data.question!, type: data.type!))
        }
        form = FormData(id: UUID(),
                        title: "Title",
                        type: formType.rawValue,
                        companyID: account?.userID ?? "Error",
                        description: "Desc",
                        answers: "Answers")
        
    }
    private func uploadForm() async throws {
        try await FormManager.shared.uploadQuestionsToTheProperFormToDatabase(form: form!, questions: formQuestions)
    }
    func createAndUploadForm(allData: FetchedResults<QuestionCoreData>, context: NSManagedObjectContext) async throws {
        try await createForm(allData: allData, context: context)
        try await uploadForm()
    }
}

enum SelectedType: String, CaseIterable{
    case A
    case B
    case none
}
