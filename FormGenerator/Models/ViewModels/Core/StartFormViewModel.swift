import Foundation

@MainActor
final class StartFormViewModel: ObservableObject {
    @Published var questionsFormDB: [DownloadedQuestion]?
    @Published var answers: [String]?
    
    required init() {  }
    
    func downloadQuestionsForAForm(formID: String){
        Task{
            let size: Int = try await FormManager.shared.getAllQuestionCount(formID: formID)
            questionsFormDB?.reserveCapacity(size)
            questionsFormDB =  try await FormManager.shared.downloadAllQuesition(formID: formID)
        }
    }
}
