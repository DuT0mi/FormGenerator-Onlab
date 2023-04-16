import Foundation
import SwiftUI

struct FormData: Identifiable, Codable, Hashable{
    let id: UUID
    let title: String
    let type: String
    let companyID: String
    let companyName: String
    let description: String
    var answers: String
    // TODO: filler's ID, type,background,..
    
    enum CodingKeys: String, CodingKey { // String for rawValue
        case id
        case title
        case type
        case companyID
        case description
        case answers
        case companyName
    }
}
