import Foundation

@MainActor
final class StartFormViewModel: ObservableObject {
    @Published var questionsFormDB: [DownloadedQuestion] = []
    @Published var answers: [(String, String)] = []
    @Published var formData: FormData?
    @Published var isLoading: Bool = false
    
    required init() {  }
    
    func downloadQuestionsForAForm(formID: String){
        Task{
            if questionsFormDB.isEmpty{
                isLoading.toggle()
                let size: Int = try await FormManager.shared.getAllQuestionCount(formID: formID)
                questionsFormDB.reserveCapacity(size)
                answers.reserveCapacity(size * 2)
                questionsFormDB =  try await FormManager.shared.downloadAllQuesition(formID: formID)
                // The form itself
                self.formData = try await FormManager.shared.downloadOneForm(formID: formID)
                isLoading.toggle()
            }
        }
    }
    func uploadAnswer(formID: String){
        Task{
            try await FormManager.shared.uploadAnswers(formID: formID , datas: answers)
        }
    }
}
