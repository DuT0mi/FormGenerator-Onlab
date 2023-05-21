import Foundation

struct DownloadedAnswer:Codable{
    var id: String
    var answer: String
    
    enum CodingKeys: String, CodingKey {
        case id = "answered_questions_id"
        case answer
    }
}


@MainActor
final class ShowResultsViewModel: ObservableObject{
    @Published var isWorking: Bool = false
    @Published var question: [DownloadedQuestion] = []
    @Published var answers: [DownloadedAnswer] = []
    
    func downloadQuestionsForAForm(formID: String){
        Task{
            if question.isEmpty{
                isWorking.toggle()
                let size: Int = try await FormManager.shared.getAllQuestionCount(formID: formID)
                question.reserveCapacity(size)
                question =  try await FormManager.shared.downloadAllQuesition(formID: formID)
                isWorking.toggle()
                print("QUESTIONS: \(question)")
            }
        }
    }
    func downloadAnswers(formID: String){
        Task{
            let downloaedDocuments = try await FormManager.shared.downloadAllAnswers(formID: formID)
            for document in downloaedDocuments {
                guard let data = document.data() else{ continue }
                print("KEY: \(data.keys)")
                print("VALUE: \(data.values)")
            }
        }
    }
}
