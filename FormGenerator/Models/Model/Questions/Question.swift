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
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.formQuestion, forKey: .formQuestion)
        try container.encode(self.type, forKey: .type)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.formQuestion = try container.decode(String.self, forKey: .formQuestion)
        self.type = try container.decode(String.self, forKey: .type)
    }
    init(id:UUID, formQuestion: String, type: String){
        self.id = id
        self.formQuestion = formQuestion
        self.type = type
    }
}
