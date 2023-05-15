import SwiftUI

struct StartFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: StartFormViewModel = StartFormViewModel()
    
    var formID: String?
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
                viewModel.downloadQuestionsForAForm(formID: formID!)
            }
    }
}

// MARK: - Will crash because of the formID is missing (has to be), using just for UI editing -> comment out the formID
/*
struct StartFormView_Previews: PreviewProvider {
    static var previews: some View {
        StartFormView()
    }
}
*/
