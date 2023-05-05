import Foundation
import CoreData
import PhotosUI
import SwiftUI

@MainActor
final class AddQuestionViewModel: ObservableObject {
    @Published var questionTitle: String = ""
    @Published var questionType: SelectedType = .Default
    @Published var selectedImage: PhotosPickerItem?
    @Published var selectedConvertedImage: Image?
    
    required init(){  }
    
    private func reset(reset: Bool = false){
        self.questionType = .Default
        self.questionTitle = ""
        self.selectedImage = nil
        self.selectedConvertedImage = nil
    }
    
    func addTextQuestion(context: NSManagedObjectContext){
        CoreDataController().addQuestion(context: context, question: self.questionTitle, type: self.questionType.rawValue)
        reset(reset: true)
    }
    
    func selectedImageConverter(){
        Task{
            if let data = try? await selectedImage?.loadTransferable(type: Data.self){
                let image = UIImage(data: data)
                if let image {
                    self.selectedConvertedImage = Image(uiImage: image)
                }
            }
        }
    }
}
