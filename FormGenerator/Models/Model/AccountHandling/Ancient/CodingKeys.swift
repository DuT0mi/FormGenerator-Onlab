import Foundation

enum CodingKeys: String, CodingKey {
    case userID = "user_id"
    case email = "email"
    case dateCreated = "date_created"
    case type = "account_type"
    case isPremium = "is_premium"
}

enum AccountType: String {
    case Standard = "Standard"
    case Company = "Company"
    
}
