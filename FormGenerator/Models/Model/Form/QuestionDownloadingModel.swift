struct DownloadedQuestion: Codable, Hashable{
    //MARK: Common data
    let id: String?
    let formQuestion: String?
    let type: String?
    // MARK: Multiple choice type specific data
    let choices: [String]?
    // MARK: Audio type specific data
    let audio_path: String?
    // MARK: Image type specific data
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
