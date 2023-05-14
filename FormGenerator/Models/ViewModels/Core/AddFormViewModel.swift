import Foundation
import _PhotosUI_SwiftUI

@MainActor
final class AddFormViewModel: ObservableObject{
    @Published var isFormHasBeenAdded: (Bool, String?) = (false,nil)
    @Published var formDatas: FormData?
    @Published var questionImage: String?
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedPremiumItem: PhotosPickerItem?
    @Published var selectedPremiumItemDataIfCameraIsUsed: Data?
    @Published var isPremium: Bool?
    
    
   static let shared = AddFormViewModel()
    
    func saveMultipleChoice(texfields: [TextFieldModel], formID: String, questionID: String){
        Task {
            let choices: [String] = texfields.map { $0.text }
            print(choices)
            try await FormManager.shared.uploadMultipleChoicesToTheProperQuestion(formID: formID, questionID: questionID, array: choices)
        }
    }
    func saveQuestionImage(data: Data, formID: String, questionID: String){
        Task{
            let (path, _) = try await FirebaseStorageManager.shared.saveQuestionImage(data: data, formID: formID, questionID: questionID)
            let url = try await FirebaseStorageManager.shared.getUrlForImage(path: path)
            self.questionImage? = url.absoluteString
            try await FormManager.shared.updateFormQuestionImagePath(formID: formID, url: url.absoluteString, questionID: questionID)
        }
    }
    func saveProfileImage(item: PhotosPickerItem, formID: String){
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else {return}
            let (path, _) = try await FirebaseStorageManager.shared.saveImage(data: data, formID: formID)
            let url = try await FirebaseStorageManager.shared.getUrlForImage(path: path)
            formDatas?.backgroundImagePath = path
            formDatas?.backgroundImageURL = url.absoluteString
            try await FormManager.shared.updateFormProfileImagePath(formID: formID, path: path, url: url.absoluteString)
        }
    }
    func savePremiumProfileImage(item: PhotosPickerItem?, formID: String){
        Task {
            guard let data = ((selectedPremiumItemDataIfCameraIsUsed) != nil) ? selectedPremiumItemDataIfCameraIsUsed : try await item?.loadTransferable(type: Data.self) else {return}
            let (path, _) = try await FirebaseStorageManager.shared.savePremiumImage(data: data, formID: formID)
            let url = try await FirebaseStorageManager.shared.getUrlForImage(path: path)
            formDatas?.circleImagePath = path
            formDatas?.circleImageURL = url.absoluteString
            try await FormManager.shared.updateFormProfileImagePathPremium(formID: formID, path: path, url: url.absoluteString)
        }
    }
    @discardableResult
    func isAccountPremium() async throws -> Bool {
        var premium: Bool = false
            let (account, exist) =  try await AccountManager.shared.getUserByJustID(userID: UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue) ?? "ures")
            if exist {
                self.isPremium = ((account as? CompanyAccount)?.isPremium) ?? false
                premium = self.isPremium ?? false
            }
        return premium
    }
}
