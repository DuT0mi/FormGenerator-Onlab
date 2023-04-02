import FirebaseAuth
import FirebaseDatabase
import Combine

final class FormViewModel: ObservableObject, Identifiable {
    @Published var id: String
    @Published var uid: String
    @Published var author: String
    @Published var title: String
    @Published var body: String
    
    // DB instance for read/write <-- see: UtilityExtensions
    private var ref = Database.root
    private var referenceHandle: DatabaseHandle?
    
    init(id: String, uid: String, author: String, title: String, body: String){
        self.id = id
        self.uid = uid
        self.author = author
        self.title = title
        self.body = body
    }
    
    private func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
}
