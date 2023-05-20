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
    private func getAllFormQuery() -> Query {
        formCollection
    }
    private func getAllQuestionQuery(formID: String) -> Query {
        questionCollectionReference(formID: formID)
    }
    private func questionCollectionReference(formID: String) -> CollectionReference {
        formDocument(formID: formID).collection("form_questions")
    }
    
    private func answerCollectionReference(formID: String) -> CollectionReference{
        formDocument(formID: formID).collection("form_answers")
    }
    private func answerSubCollectionDocument(formID: String, userID: String) -> DocumentReference{
        formDocument(formID: formID).collection("form_answers").document(userID)
    }
    private func formSubCollectionOfQuestionDocument(formID: String, questionID: String) -> DocumentReference{
        formDocument(formID: formID).collection("form_questions").document(questionID)
    }
    private func formDocument(formID: String) -> DocumentReference {
        formCollection.document(formID)
    }
    
    private func uploadFormToDatabase(form: FormData) async throws {
        try formDocument(formID: (form.id.uuidString)).setData(from: form, merge:false)
    }
    func uploadAudioFile(url path : URL, formID: String, questionID: String) async throws {
        try await formSubCollectionOfQuestionDocument(formID: formID, questionID: questionID).updateData(["audio_path" : path.absoluteString])
    }
    func uploadMultipleChoicesToTheProperQuestion(formID: String, questionID: String, array: [String]) async throws{
        try await formSubCollectionOfQuestionDocument(formID: formID, questionID: questionID).setData(["choices" : array], merge: true)
    }
    func uploadAnswers(formID: String, datas: [(answer: String, qID: String)]) async throws {
        let userID = UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)
        var dictionary: [String: Any] = [:]
        for data in datas {
            dictionary[data.qID] = data.answer
        }
        try await answerSubCollectionDocument(formID: formID, userID: userID!).setData(dictionary)
        
    }
    // First upload the Form itself, then the questions to it
    func uploadQuestionsToTheProperFormToDatabase(form: FormData, questions: [Question]) async throws{
            try await uploadFormToDatabase(form: form)
        for question in questions {
                let dict: [String : Any] = [
                    Question.CodingKeys.formQuestion.rawValue   : question.formQuestion,
                    Question.CodingKeys.type.rawValue           : question.type,
                    Question.CodingKeys.id.rawValue             : question.id.uuidString
                ]
                try await formSubCollectionOfQuestionDocument(formID: form.id.uuidString, questionID: question.id.uuidString).setData(dict, merge: true)
            }
    }
    func downloadAllForm(limit: Int, lastDocument: DocumentSnapshot?) async throws -> (forms: [FormData], lastDocument: DocumentSnapshot?){
        let formsQuery: Query = self.getAllFormQuery()
        
        return try await formsQuery
            .limit(to: limit)
            .startIfExists(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: FormData.self)
            
    }
    func checkUserIfHasAlreadyAnswered(formID: String, userID: String, completion: @escaping (Bool) -> Void) {
        let docRef = answerCollectionReference(formID: formID).document(userID)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                completion(document.documentID == userID)
            } else {
                completion(false)
            }
        }
    }

    func downloadOneForm(formID: String) async throws -> FormData{
        let formsQuery: Query = self.getAllFormQuery()
        
        return try await
                formsQuery
                    .whereField(FormData.CodingKeys.id.rawValue, isEqualTo: formID)
                    .getDocumentsWithSnapshot(as: FormData.self)
                    .forms
                    .first!
                    
    }
    func downloadAllQuesition(formID: String) async throws -> [DownloadedQuestion] {
        let questionQuery: Query = self.getAllQuestionQuery(formID: formID)
                
        return try await questionQuery
            .getDocuments(as: DownloadedQuestion.self)
    }
    func updateFormProfileImagePath(formID: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            FormData.CodingKeys.backgroundImagePath.rawValue : path as Any,
            FormData.CodingKeys.backgroundImageURL.rawValue : url as Any
        ]
        try await formDocument(formID: formID).updateData(data)
    }
    func updateFormProfileImagePathPremium(formID: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            FormData.CodingKeys.circleImagePath.rawValue : path as Any,
            FormData.CodingKeys.circleImageURL.rawValue : url as Any
        ]
        try await formDocument(formID: formID).updateData(data)
    }
    func updateFormQuestionImagePath(formID: String, url: String?, questionID: String) async throws {
        let data: [String: Any] = [
            Question.CodingKeys.imageURL.rawValue : url as Any
        ]
        try await formSubCollectionOfQuestionDocument(formID: formID, questionID: questionID).updateData(data)
    }
    func getAllFormCount() async throws -> Int {
        try await formCollection.aggregationCount()
    }
    func getAllQuestionCount(formID: String) async throws -> Int {
        try await questionCollectionReference(formID: formID).aggregationCount()
    }

}
