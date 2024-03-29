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
    func updateFields(fields: [TextFieldModel]){
        self.textFields = fields
    }
    func addQuestion(context: NSManagedObjectContext, pickedImage: PhotosPickerItem? = nil, recordedURL: URL? = nil){
        switch questionType {
            case .Default:
                break
            case .Image:
                addQuestionWithImage(context: context, image: pickedImage!)
            case .MultipleChoice:
                addQuestionWithMultipleOptions(context: context)
            case .Text:
                addTextBasedQuestion(context: context, isTrueOrFalse: false)
            case .TrueOrFalse:
                addTextBasedQuestion(context: context)
            case .Voice:
                addQuestionWithAudio(context: context, audioURL: recordedURL!)
        }
        reset(reset: true)
    }
    
    private func addTextBasedQuestion(context: NSManagedObjectContext, isTrueOrFalse: Bool = true){
        CoreDataController().addQuestion(context: context, question: isTrueOrFalse ? self.trueOrFalseQuestionTitle : self.questionTitle , type: questionType.rawValue)
    }
    private func addQuestionWithImage(context: NSManagedObjectContext, image: PhotosPickerItem){
        Task{
            if let data = try? await image.loadTransferable(type: Data.self){
                if let image = UIImage(data: data), let imageData = image.pngData(){                    
                    CoreDataController().addQuestionWithImage(context: context, questionTitle: questionForImage, imageData: imageData, type: SelectedType.Image.rawValue)
                }
            }
        }
    }
    private func addQuestionWithAudio(context: NSManagedObjectContext, audioURL url: URL){
        CoreDataController().addQuestionWithAudio(context: context, url: url, type: questionType.rawValue)
    }
    private func addQuestionWithMultipleOptions(context: NSManagedObjectContext){
        CoreDataController().addQuestionWithMultipleOptions(context: context, options: textFields, type: questionType.rawValue, question: questionTitleMultiple)
    }
    
    
    func editQuestion(context: NSManagedObjectContext,question: QuestionCoreData,pickedImage: PhotosPickerItem? = nil, recordedURL: URL? = nil, oldType: String){
        if oldType != questionType.rawValue {
            // Create the newer one
            addQuestion(context: context, pickedImage: pickedImage, recordedURL: recordedURL)
            // Delete the old
            CoreDataController().deleteQuestion(context: context, question: question)
        }
        switch questionType {
            case .Default:
                break
            case .Image:
                editQuestionWithImage(context: context, question: question, image: pickedImage!)
            case .MultipleChoice:
                editQuestionWithMultipleFields(context: context, question: question)
            case .Text:
                editQuestionTypeText(context: context, question: question)
            case .TrueOrFalse:
                editQuestionTypeTrueOrFalse(context: context, question: question)
            case .Voice:
                editQuestionAudio(context: context, question: question, audioURL: recordedURL!)
        }
        reset(reset: true)
    }
    private func editQuestionWithImage(context: NSManagedObjectContext, question: QuestionCoreData, image: PhotosPickerItem){
        Task{
            if let data = try? await image.loadTransferable(type: Data.self){
                if let image = UIImage(data: data), let imageData = image.pngData(){
                    CoreDataController().editQuestionTypeImage(context: context, question: question, title: questionForImage, imageData: imageData)
                }
            }
        }
    }
    private func editQuestionWithMultipleFields(context: NSManagedObjectContext, question: QuestionCoreData){
        CoreDataController().editQuestionWithMultipleFields(context: context, question: question, options: textFields, title: questionTitleMultiple)
    }
    private func editQuestionAudio(context: NSManagedObjectContext, question: QuestionCoreData, audioURL url: URL){
        CoreDataController().editQuestionWithAudio(context: context, url: url, question: question)
    }
    private func editQuestionTypeText(context: NSManagedObjectContext, question: QuestionCoreData){
        CoreDataController().editQuestionTypeTextBased(context: context, question: question, question: questionTitle)
    }
    private func editQuestionTypeTrueOrFalse(context: NSManagedObjectContext, question: QuestionCoreData){
        CoreDataController().editQuestionTypeTextBased(context: context, question: question, question: trueOrFalseQuestionTitle)
    }
    
    
    func selectedImageConverter(){
        Task{
            if let data = try? await selectedImage?.loadTransferable(type: Data.self){
                let image = UIImage(data: data)
                if let image {
                    selectedConvertedImage = Image(uiImage: image)
                    imageError = false
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


