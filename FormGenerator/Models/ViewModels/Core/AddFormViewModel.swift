import Foundation
import _PhotosUI_SwiftUI

@MainActor
final class AddFormViewModel: ObservableObject{
    @Published var isFormHasBeenAdded: Bool
    @Published var formDatas: FormData?
    @Published var selectedItem: PhotosPickerItem?
    
    static let shared = AddFormViewModel()
   private init(){
        _isFormHasBeenAdded = .init(initialValue: false)
    }
    func saveProfileImage(item: PhotosPickerItem, formID: String){
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else {return}
            let (path, name) = try await FirebaseStorageManager.shared.saveImage(data: data, formID: formID)
            print("SUCCESS")
            print(name)
            print(path)
            let url = try await FirebaseStorageManager.shared.getUrlForImage(path: path)
            formDatas?.backgroundImagePath = path
            formDatas?.backgroundImageURL = url.absoluteString
            try await FormManager.shared.updateFormProfileImagePath(formID: formID, path: path, url: url.absoluteString)
        }
    }
}
