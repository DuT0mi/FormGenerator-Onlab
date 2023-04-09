import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FormManager{
    // MARK: Singleton
    static let shared: FormManager = FormManager()
    private init() { }
    
    private let formCollection = Firestore.firestore().collection("forms")
    private func formDocument(formID: String) -> DocumentReference {
        formCollection.document(formID)
    }
    
    
    func uploadFormToDatabase(form: FormData) async throws {
        try formDocument(formID: (form.id.uuidString)).setData(from: form, merge:false)
    }
    func downloadAllForm() async throws -> [FormData]{
        try await formCollection.getDocuments(as: FormData.self)
    }
}
