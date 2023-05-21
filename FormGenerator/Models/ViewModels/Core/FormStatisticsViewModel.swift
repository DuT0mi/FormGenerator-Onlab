import Foundation
import FirebaseFirestore

@MainActor
final class FormStatisticsViewModel: ObservableObject{
    @Published private(set) var isGenerating: Bool = false
    @Published private(set) var forms: [FormData] = []
    @Published private(set) var allFormCountOnServer: Int?
    
    private var lastDocument: DocumentSnapshot?
    
    func downloadAllForm(withoutLimit: Bool = false){
        Task{
            let (newForm, lastDocument) = try await FormManager.shared.downloadAllForm(limit: withoutLimit ? getAllFormCount() : FormConstants.defaultDownloadingLimit, lastDocument: lastDocument)
            self.forms.append(contentsOf: newForm.filter({$0.companyID == UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)}))            
            if let lastDocument{
                self.lastDocument = lastDocument
            }
            self.allFormCountOnServer = forms.count
        }
    }
    func pullRefreshDownloadAllForm() {
        Task{
            if try await FormManager.shared.getAllFormCount() > 0 {
                self.forms = []
                self.lastDocument = nil
                downloadAllForm(withoutLimit: true)
            } else {
                self.forms = []
            }
        }
    }
    private func getAllFormCount() async throws -> Int {
            try await FormManager.shared.getAllFormCount()
    }
    
}
