import Foundation

@MainActor
final class StartFormViewModel: ObservableObject {
    @Published var questionsFormDB: [DownloadedQuestion] = []
    
    required init() {  }
    
    func downloadQuestionsForAForm(formID: String){
        Task{
            if questionsFormDB.isEmpty{                
                let size: Int = try await FormManager.shared.getAllQuestionCount(formID: formID)
                questionsFormDB.reserveCapacity(size)
                questionsFormDB =  try await FormManager.shared.downloadAllQuesition(formID: formID)
            }
        }
    }
}
