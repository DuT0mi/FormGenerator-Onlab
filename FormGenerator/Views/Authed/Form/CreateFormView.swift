import SwiftUI

struct CreateFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CreateFormViewModel = CreateFormViewModel()
    
    
    fileprivate var submitButton: some View {
        Button("Submit"){
            dismiss.callAsFunction()
            Task{
                try await viewModel.createForm()
                try await viewModel.uploadForm()
            }
        }
    }
    
    var body: some View {
        ScrollView{
            NavigationView {
                LazyVStack(spacing: 50) {
                    HStack{
                        TextField("Enter your question", text: $viewModel.formText)
                        Menu("Type: \(viewModel.formType.rawValue)"){
                            ForEach(CreateFormViewModel.SelectedType.allCases, id: \.self){
                                type in
                                Button(type.rawValue){
                                    Task{
                                        try? await viewModel.typeSelected(type:type)
                                    }
                                }
                            }
                        }
                    }
                    submitButton
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                }
                .padding()
                .navigationTitle("Create form!")
                .toolbar {
                    Button {
                        
                    } label: {
                        Image(systemName:"doc.badge.plus")
                            .bold()
                    }

                }
            }
        }
    }
}

struct CreateFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFormView()
    }
}
