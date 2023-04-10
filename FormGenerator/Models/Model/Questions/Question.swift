import Foundation

struct Question: Identifiable, Codable{
    let id: UUID
    var formQuestion: String
    let type: String
    
    enum CodingKeys: String,CodingKey {
        case id
        case formQuestion
        case type
    }
}
