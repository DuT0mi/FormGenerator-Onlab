import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CompanyAccount: Account,Codable {

    var userID: String
    var email: String?
    var dateCreated: Date?
    var type: AccountType {
        get { AccountType.Company }
        set {}
    }
    var isPremium: Bool?
    
    init(userID: String,
         email: String,
         dateCreated: Date? = nil,
         type: AccountType,
         isPremium: Bool = false) {
        self.userID = userID
        self.email = email
        self.dateCreated = dateCreated
        self.type = type
        self.isPremium = isPremium
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
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userID,forKey: .userID)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.type.rawValue, forKey: .type)
        try container.encode(self.isPremium, forKey: .isPremium)
    }
}
