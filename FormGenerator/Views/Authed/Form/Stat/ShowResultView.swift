import SwiftUI

struct ShowResultView: View {
    @StateObject private var viewModel: ShowResultsViewModel = ShowResultsViewModel()
    var form: FormData?
    
    var body: some View {
        ScrollView {
            VStack{
                Text("here")
                // switch the question types
            }
            .onAppear{
                //Download && generate
                viewModel.downloadAnswers(formID: form!.id.uuidString)
                viewModel.downloadQuestionsForAForm(formID: form!.id.uuidString)
            }
        }
        
    }
}

struct ShowResultView_Previews: PreviewProvider {
    static var previews: some View {
        ShowResultView()
    }
}
