import Foundation
import CoreData
import PhotosUI
import SwiftUI

@MainActor
final class AddQuestionViewModel: ObservableObject {
    // Shared
    @Published var questionType: SelectedType = .Default
    // Type: Text
    @Published var questionTitle: String = ""
    // Type: Image
    @Published var questionForImage: String = ""
    @Published var selectedImage: PhotosPickerItem?
    @Published var selectedConvertedImage: Image?
    @Published var imageError: Bool = false
    // Type: True Or False
    @Published var trueOrFalseQuestionTitle: String = ""
    // Type: Multiple Choice
    @Published var questionTitleMultiple: String = ""
    @Published var textFields: [TextFieldModel] = []
    // Type: Voice
    @Published var recordedURL: URL?

    
    required init(){  }
    
    private func reset(reset: Bool = false){
        questionType = .Default
        questionTitle = ""
        selectedImage = nil
        selectedConvertedImage = nil
        imageError = false
        trueOrFalseQuestionTitle = ""
        questionTitleMultiple = ""
        textFields = []
        recordedURL = nil
    }
    func addQuestion(context: NSManagedObjectContext, pickedImage: PhotosPickerItem? = nil){
        switch questionType {
            case .Default:
                break
            case .Image:
                addQuestionWithImage(context: context, image: pickedImage!)
            case .MultipleChoice:
                break
            case .Text:
                addTextBasedQuestion(context: context, isTrueOrFalse: false)
            case .TrueOrFalse:
                addTextBasedQuestion(context: context)
            case .Voice:
                break
        }
        reset(reset: true)
    }
    
    private func addTextBasedQuestion(context: NSManagedObjectContext, isTrueOrFalse: Bool = true){
        CoreDataController().addQuestion(context: context, question: isTrueOrFalse ? self.trueOrFalseQuestionTitle : self.questionTitle , type: self.questionType.rawValue)
    }
    private func addQuestionWithImage(context: NSManagedObjectContext, image: PhotosPickerItem){
        Task{
            if let data = try? await image.loadTransferable(type: Data.self){
                if let image = UIImage(data: data), let imageData = image.pngData(){                    
                    CoreDataController().addQuestionWithImage(context: context, questionTitle: questionForImage, imageData: imageData, type: self.questionType.rawValue)
                }
            }
        }
    }
    
    func selectedImageConverter(){
        Task{
            if let data = try? await selectedImage?.loadTransferable(type: Data.self){
                let image = UIImage(data: data)
                if let image {
                    selectedConvertedImage = Image(uiImage: image)
                } else {
                    imageError = true
                }
            } else {
                imageError = true
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
    func typeSelected(type: SelectedType){
        self.questionType = type
    }
    
    // MARK: - Error handling
    func checkAllPossibleError() -> Bool {
            switch self.questionType {
                case .Image: return checkIfUserHasAddedBadImageFormat()
                case .MultipleChoice: return checkIfUserHasAddedTextToMultiple()
                case .Text:  return checkIfUserHasAddedQuestion()
                case .TrueOrFalse: return checkIfUserHasAddedTextToTF()
                case .Voice: return checkIfUserHasAddedVoice()
                default: return true
        }
    }
    // Return true if the error happens
    private func checkIfUserHasAddedQuestion() -> Bool {
        questionTitle.isEmpty
    }
    private func checkIfUserHasAddedVoice() -> Bool{
        (self.recordedURL == nil)               ||
        (((self.recordedURL?.isFileURL) == nil))
    }
    private func checkIfUserHasAddedTextToTF() -> Bool{
        trueOrFalseQuestionTitle.isEmpty
    }
    private func checkIfUserHasAddedTextToMultiple() -> Bool {
        questionTitleMultiple.isEmpty ||
        textFields.isEmpty
    }
    private func checkIfUserHasAddedBadImageFormat() -> Bool {
        self.imageError                     ||
        self.selectedImage == nil           ||
        self.selectedConvertedImage == nil  ||
        self.questionForImage.isEmpty
    }


}


