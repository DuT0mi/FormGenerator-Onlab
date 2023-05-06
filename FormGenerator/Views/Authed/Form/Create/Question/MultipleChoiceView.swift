import SwiftUI

struct MultipleChoiceView: View {
    @ObservedObject var viewModel: AddQuestionViewModel
    @State private var textFieldCount: Int?
    fileprivate var textComponent: some View{
        TextField("Enter you question: ", text: $viewModel.questionTitle)
    }

    var body: some View {
        ScrollView{
            LazyVStack{
                textComponent
                    .padding(.vertical)
                ForEach(viewModel.textFields, id: \.id) { textField in
                    TextField("\(textField.text)", text: Binding(
                        get: { textField.text },
                        set: { viewModel.updateTextField(id: textField.id, text: $0) }
                    ))
                    Divider()
                }
                .onChange(of: viewModel.textFields.count) { newValue in
                    textFieldCount = newValue
                }
                
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    viewModel.addTextField()
                } label: {
                    Image(systemName: "plus")
                }
            }
            if textFieldCount != nil , textFieldCount != 0{
                ToolbarItem{
                    Button {
                        viewModel.removeTextField()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                }
            }
        }
    }
}

struct MultipleChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MultipleChoiceView(viewModel: AddQuestionViewModel())
        }
    }
}
