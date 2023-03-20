import Foundation

struct Answers: Identifiable {
    var id: Int
    var uid: String
    var text: String    // MARK: Just temporary
    var author: String  // MARK: Just temporary
    
    init(id: Int, uid: String, text: String, author: String) {
        self.id = id
        self.uid = uid
        self.text = text
        self.author = author
    }
    init?(id: Int, dict: [String: Any]){
        guard let uid = dict["uid"] as? String else {return nil}
        guard let author = dict["author"] as? String else {return nil}
        guard let text = dict["text"] as? String else {return nil}
        
        self.id = id
        self.uid = uid
        self.author = author
        self.text = text
    }
}
