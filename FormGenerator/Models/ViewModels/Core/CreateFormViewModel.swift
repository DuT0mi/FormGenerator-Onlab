import Foundation
import SwiftUI
import CoreData
import PhotosUI

@MainActor
final class CreateFormViewModel: ObservableObject {
    @Published private(set) var form: FormData?
    @Published var formText: String = ""
    @Published var formType: SelectedType = .none
    
    private var formQuestions: [Question] = []
    private var formMetaData: [FormData] = []
    private var account: Account?
    private let authManager: AuthenticationManager = AuthenticationManager()
    
    private func loadCurrentAccount() async throws {
        let authDataResult = try authManager.getAuthenticatedUser()
        let (account,_) = try await AccountManager.shared.getUserByJustID(userID: authDataResult.uid)
        self.account = account
    }
    
    init(){
        Task{
            try? await loadCurrentAccount()
        }

    }
    
    private func createForm(allQData: FetchedResults<QuestionCoreData>,allFData: FetchedResults<FormCoreData>, context: NSManagedObjectContext) async throws {
        allQData.forEach { data in            
            self.formQuestions.append(Question(id: data.id!, formQuestion: data.question!, type: data.type!))
        }
        allFData.forEach { data in
            self.form = FormData(
                            id: AddFormViewModel.shared.formDatas?.id ?? UUID(),
                            title: data.title ?? "Title",
                            type: data.type ?? "None",
                            companyID: account?.userID ?? "Error",
                            companyName: data.cName ?? "Company Name",
                            description: data.cDesc ?? "Description",
                            answers: data.answers ?? "Answers",
                            backgroundImagePath: AddFormViewModel.shared.formDatas?.backgroundImagePath ?? "",
                            backgroundImageURL: AddFormViewModel.shared.formDatas?.backgroundImageURL ?? "")
        }
        
    }
    private func uploadForm() async throws {
        try await FormManager.shared.uploadQuestionsToTheProperFormToDatabase(form: form!, questions: formQuestions)
    }
    private func uploadToFireBaseStorage(selectedItem: PhotosPickerItem, formData: FormData) async throws {
        AddFormViewModel.shared.saveProfileImage(item: selectedItem, formID: formData.id.uuidString)
    }
    func createAndUploadForm(allQData: FetchedResults<QuestionCoreData>,allFData: FetchedResults<FormCoreData>, context: NSManagedObjectContext) async throws {
        try await createForm(allQData: allQData, allFData: allFData, context: context)
        try await uploadToFireBaseStorage(selectedItem: AddFormViewModel.shared.selectedItem!, formData: AddFormViewModel.shared.formDatas!)
        try await uploadForm()
    }
}
