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
    var backgroundImagePath: String?
    var backgroundImageURL: String?
   // var circleImagePath: String?
   // var circleImageURL: String?
    // TODO: filler's ID, type,background,..
    
    enum CodingKeys: String, CodingKey { // String for rawValue
        case id = "id"
        case title = "title"
        case type = "type"
        case companyID = "company_id"
        case description = "description"
        case answers = "answers"
        case companyName = "company_name"
        case backgroundImagePath = "background_image_path"
        case backgroundImageURL = "background_image_url"
      //  case circleImagePath = "circle_image_path"
      //  case circleImageURL = "circle_image_url"
    }
}
