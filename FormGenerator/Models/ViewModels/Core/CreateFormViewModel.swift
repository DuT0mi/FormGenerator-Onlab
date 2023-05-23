import Foundation
import SwiftUI
import CoreData
import PhotosUI

@MainActor
final class CreateFormViewModel: ObservableObject {
    @Published private(set) var form: FormData?
    @Published var formText: String = ""
    @Published var formType: SelectedType = .Default
    
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
    
    private func createForm(allQData: FetchedResults<QuestionCoreData>,allFData: FetchedResults<FormCoreData>, context: NSManagedObjectContext, time: Int) async throws {
        allQData.filter({$0.uid == UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)}).forEach { data in
            
            self.formQuestions.append(
                Question(id: data.id!,
                         formQuestion: data.question ?? "nil",
                         type: data.type!))
            
            if data.type == SelectedType.MultipleChoice.rawValue {
                if let dataDecoded = try? JSONDecoder().decode([TextFieldModel].self, from: data.multipleOptions as! Data){
                    AddFormViewModel.shared.saveMultipleChoice(texfields: dataDecoded, formID: AddFormViewModel.shared.formDatas?.id.uuidString ?? "", questionID: data.id?.uuidString ?? "")
                }
            } else
            if data.type == SelectedType.Image.rawValue {
                AddFormViewModel.shared.saveQuestionImage(data: data.imgData!, formID: AddFormViewModel.shared.formDatas?.id.uuidString ?? "", questionID: data.id?.uuidString ?? "")
            } else
            
            if data.type == SelectedType.Voice.rawValue {
                AddFormViewModel.shared.saveAudioFile(audioURL: data.audioURL!, formID: AddFormViewModel.shared.formDatas?.id.uuidString ?? "", questionID: data.id?.uuidString ?? "")
            }
        }        
        allFData.filter({$0.cID == UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)}).forEach { data in
            self.form = FormData(
                            id: AddFormViewModel.shared.formDatas?.id ?? UUID(),
                            time: time,
                            isAvailable: true,
                            title: data.title ?? "Title",
                            type: data.type ?? "None",
                            companyID: account?.userID ?? "Error",
                            companyName: data.cName ?? "Company Name",
                            description: data.cDesc ?? "Description",                            
                            backgroundImagePath: AddFormViewModel.shared.formDatas?.backgroundImagePath ?? "",
                            backgroundImageURL: AddFormViewModel.shared.formDatas?.backgroundImageURL ?? "",
                            circleImagePath: AddFormViewModel.shared.formDatas?.circleImagePath ?? "",
                            circleImageURL: AddFormViewModel.shared.formDatas?.circleImageURL ?? "" )
        }
        
    }
    private func uploadForm() async throws {
        try await FormManager.shared.uploadQuestionsToTheProperFormToDatabase(form: form!, questions: formQuestions)        
    }
    private func uploadToFireBaseStorage(selectedItem: PhotosPickerItem, formData: FormData) async throws {
        AddFormViewModel.shared.saveProfileImage(item: selectedItem, formID: formData.id.uuidString)
    }
    private func uploadToFireBaseStoragePremiumItem(selectedItemPremium: PhotosPickerItem?, formData: FormData) async throws {
        AddFormViewModel.shared.savePremiumProfileImage(item: selectedItemPremium, formID: formData.id.uuidString)
    }
    private func commonUploadToFirebaseStorage(allQData: FetchedResults<QuestionCoreData>,allFData: FetchedResults<FormCoreData>, context: NSManagedObjectContext, time: Int) async throws {
        try await createForm(allQData: allQData, allFData: allFData, context: context, time: time)
        try await uploadToFireBaseStorage(selectedItem: AddFormViewModel.shared.selectedItem!, formData: AddFormViewModel.shared.formDatas!)
    }
    
    func createAndUploadForm(allQData: FetchedResults<QuestionCoreData>,allFData: FetchedResults<FormCoreData>, context: NSManagedObjectContext, time: Int) async throws {
        try await commonUploadToFirebaseStorage(allQData: allQData, allFData: allFData, context: context, time: time)
        try await uploadForm()
    }
    func createAndUploadFormPremium(allQData: FetchedResults<QuestionCoreData>,allFData: FetchedResults<FormCoreData>, context: NSManagedObjectContext, time: Int) async throws {
        try await commonUploadToFirebaseStorage(allQData: allQData, allFData: allFData, context: context, time: time)
        try await uploadToFireBaseStoragePremiumItem(selectedItemPremium: AddFormViewModel.shared.selectedPremiumItem, formData: AddFormViewModel.shared.formDatas!)
        try await uploadForm()
    }
}
