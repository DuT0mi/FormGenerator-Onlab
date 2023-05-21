import SwiftUI

struct ShowResultView: View {
    @StateObject private var viewModel: ShowResultsViewModel = ShowResultsViewModel()
    var form: FormData?
    
    var body: some View {
        ScrollView {
            VStack{                
                if viewModel.isWorking{
                    ProgressView()
                }else {
                    Text("Loaded")
                }
            }
            .task{
                //Download && generate
                try? await viewModel.downloadComponents(formID: form!.id.uuidString)
            }
        }
        
    }
}

struct ShowResultView_Previews: PreviewProvider {
    static var previews: some View {
        ShowResultView()
    }
}
