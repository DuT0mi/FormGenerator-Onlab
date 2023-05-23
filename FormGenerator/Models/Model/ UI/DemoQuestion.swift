import Foundation
import SwiftUI

struct DemoQuestion{
    let id: UUID = UUID()
    let postfix: String = "QuestionImg"
    var title: String?
    var image: Image{
        Image(type.rawValue + postfix)
    }
    let type: DemoQuestionType
    
    init(type: DemoQuestionType) {
        self.type = type
        setTitle(type: type)

    }
    private mutating func setTitle(type: DemoQuestionType){
        switch type{
            case .tf:           self.title = "True or false"
            case .voice:        self.title = "Audio"
            case .image:        self.title = "Image"
            case .multiple:     self.title = "Multiple choice"
            case .text:         self.title = "Text"
        }
    }
    
}
enum DemoQuestionType: String, CaseIterable{
    case tf
    case voice
    case text
    case multiple
    case image
}
