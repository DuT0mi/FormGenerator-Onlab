import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

actor FormManager{
    // MARK: Singleton
    static let shared: FormManager = FormManager()
    private init() { }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    private let decoder: Firestore.Decoder = {
        let encoder = Firestore.Decoder()
        return encoder
    }()
    
    private let formCollection = Firestore.firestore().collection("forms")
    private func formSubCollectionOfQuestionDocument(formID: String, questionID: String) -> DocumentReference{
        formDocument(formID: formID).collection("form_questions").document(questionID)
    }
    private func formDocument(formID: String) -> DocumentReference {
        formCollection.document(formID)
    }
    
    
    private func uploadFormToDatabase(form: FormData) async throws {
        try formDocument(formID: (form.id.uuidString)).setData(from: form, merge:false)
    }
    /// First upload the Form itself, then the questions to it
    func uploadQuestionsToTheProperFormToDatabase(form: FormData, questions: [Question]) async throws{
            try await uploadFormToDatabase(form: form)
        
            for question in questions {
                guard let data = try? encoder.encode(question) else {throw URLError(.badURL)}
                let dict: [String : Any] = [
                    Question.CodingKeys.formQuestion.rawValue : data
                ]
                try await formSubCollectionOfQuestionDocument(formID: form.id.uuidString, questionID: question.id.uuidString).setData(dict)
            }
    }
    func downloadAllForm() async throws -> [FormData]{
        try await formCollection.getDocuments(as: FormData.self)
    }
    func updateFormProfileImagePath(formID: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            FormData.CodingKeys.backgroundImagePath.rawValue : path as Any,
            FormData.CodingKeys.backgroundImageURL.rawValue : url as Any
        ]
        try await formDocument(formID: formID).updateData(data)
    }
}
