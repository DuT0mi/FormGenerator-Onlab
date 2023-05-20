import Foundation
import SwiftUI

struct FormData: Identifiable, Codable, Hashable{
    let id: UUID
    let time: Int
    let title: String
    let type: String
    let companyID: String
    let companyName: String
    let description: String
    var backgroundImagePath: String?
    var backgroundImageURL: String?
    var circleImagePath: String?
    var circleImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case time = "time_to_fill_in_seconds"
        case title = "title"
        case type = "type"
        case companyID = "company_id"
        case description = "description"
        case companyName = "company_name"
        case backgroundImagePath = "background_image_path"
        case backgroundImageURL = "background_image_url"
        case circleImagePath = "circle_image_path"
        case circleImageURL = "circle_image_url"
    }
}
