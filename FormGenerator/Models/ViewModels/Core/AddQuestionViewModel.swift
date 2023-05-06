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
    @Published var trueOrFalseQuestionTitle: String = ""
    @Published var textFields: [TextFieldModel] = []
    
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
    func addTextField() {
        let textField = TextFieldModel(id: UUID(), text: "option: \(self.textFields.count)".uppercased())
        textFields.append(textField)
    }

    func updateTextField(id: UUID, text: String) {
        if let index = textFields.firstIndex(where: { $0.id == id }) {
            textFields[index].text = text
        }
    }
    func removeTextField(){
        textFields.removeLast()
    }
}

struct TextFieldModel {
    let id: UUID
    var text: String
}
