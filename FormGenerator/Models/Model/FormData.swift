import Foundation

struct FormData: Identifiable, Codable, Hashable{
    let id: UUID
    let title: String
    let type: String
    let companyID: String
    let description: String
    var answers: String
    var questions: String
    // TODO: filler's ID, type,background,..
    
    enum CodingKeys: String, CodingKey { // String for rawValue
        case id
        case title
        case type
        case companyID
        case description
        case answers
        case questions
    }
}
