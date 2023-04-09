import SwiftUI

struct CreateFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CreateFormViewModel = CreateFormViewModel()
    
    var body: some View {
        ScrollView{
            NavigationView {
                LazyVStack(spacing: 50) {
                    HStack{
                        TextField("AAAA", text: $viewModel.formText)
                        Menu("Type: \(viewModel.formType.rawValue)"){
                            ForEach(CreateFormViewModel.selectedType.allCases, id: \.self){
                                type in
                                Button(type.rawValue){
                                    Task{
                                        try? await viewModel.typeSelected(type:type)
                                    }
                                }
                            }
                        }
                    }
                    Button("DONE"){
                        dismiss.callAsFunction()
                        Task{
                            try await viewModel.createForm()
                            try await viewModel.uploadForm()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
                .padding()
                .navigationTitle("Create form!")
            }
        }
        .ignoresSafeArea()
    }
}

struct CreateFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFormView()
    }
}
