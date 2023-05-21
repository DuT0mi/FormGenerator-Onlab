import Foundation

struct DownloadedAnswer:Codable{
    var id: String
    var answer: String

}


@MainActor
final class ShowResultsViewModel: ObservableObject{
    @Published var isWorking: Bool = false
    @Published var question: [DownloadedQuestion] = []
    @Published var answers: [DownloadedAnswer] = []
    
    
    func downloadComponents(formID: String) async throws {
        isWorking.toggle()
        try await downloadQuestionsForAForm(formID: formID)
        try await downloadAnswers(formID: formID)
        isWorking.toggle()
    }
    
    private func downloadQuestionsForAForm(formID: String) async throws{
            if question.isEmpty{
                let size: Int = try await FormManager.shared.getAllQuestionCount(formID: formID)
                question.reserveCapacity(size)
                self.question =  try await FormManager.shared.downloadAllQuesition(formID: formID)
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
