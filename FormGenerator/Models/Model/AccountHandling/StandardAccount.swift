import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct StandardAccount: Account, Codable {

    var userID: String
    var email: String?
    var dateCreated: Date?
    var type: AccountType {
        get { AccountType.Standard }
        set {}
    }
    
    init(userID: String,
         email: String,
         dateCreated: Date? = nil,
         type: AccountType) {
        self.userID = userID
        self.email = email
        self.dateCreated = dateCreated
        self.type = type
    }
    init(auth: AuthenticationDataResult){
        self.userID = auth.uid
        self.email = auth.email
        self.dateCreated = Date()
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userID,forKey: .userID)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.type.rawValue, forKey: .type)
    }
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email = "email"
        case dateCreated = "date_created"
        case type = "type"
    }
}

