import Foundation

struct DownloadedAnswer:Codable{
    var id: String
    var answer: String

}

struct TextBasedData{
    let id: UUID
    let questionTitle: String
    let answers: [String]
    
    init(questionTitle: String, answers: [String], id: UUID = UUID()) {
        self.questionTitle = questionTitle
        self.answers = answers
        self.id = id
    }
}


@MainActor
final class ShowResultsViewModel: ObservableObject{
    // State flags
    @Published private(set) var isWorking: Bool = false
    // Common source
    @Published private(set) var questions: [DownloadedQuestion] = []
    @Published private(set) var answers: [DownloadedAnswer] = []
    
    
    func downloadComponents(formID: String) async throws {
        isWorking.toggle()
        try await downloadQuestionsForAForm(formID: formID)
        try await downloadAnswers(formID: formID)
        isWorking.toggle()
    }
    private func downloadQuestionsForAForm(formID: String) async throws{
            if questions.isEmpty{
                let size: Int = try await FormManager.shared.getAllQuestionCount(formID: formID)
                questions.reserveCapacity(size)
                self.questions =  try await FormManager.shared.downloadAllQuesition(formID: formID)
            }
    }
    private func downloadAnswers(formID: String) async throws {
            let downloadedDocuments = try await FormManager.shared.downloadAllAnswers(formID: formID)
            for document in downloadedDocuments {
                guard let data = document.data() else{ continue }
                let qIDs = data.keys
                let ans = data.values
                 
                for index in qIDs.indices{
                    self.answers.append(DownloadedAnswer(id: qIDs[index], answer: ans[index] as! String))
                }
            }
        }
}
