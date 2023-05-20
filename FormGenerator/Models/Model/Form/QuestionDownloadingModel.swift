struct DownloadedQuestion: Codable, Hashable{
    // Common data
    let id: String?
    let formQuestion: String?
    let type: String?
    // Multiple choice type specific data
    let choices: [String]?
    // Audio type specific data
    let audio_path: String?
    // Image type specific data
    let image_url: String?
    
}
extension DownloadedQuestion{
    enum CodingKeys: CodingKey {
        case id
        case formQuestion
        case type
        case choices
        case audio_path
        case image_url
    }
}
