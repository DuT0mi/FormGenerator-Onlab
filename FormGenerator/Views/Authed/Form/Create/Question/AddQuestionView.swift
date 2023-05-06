import SwiftUI
import PhotosUI

struct AddQuestionView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddQuestionViewModel = AddQuestionViewModel()
    @State private var isQuestionEmpty: Bool = false
    @State private var selectedImage: Image?
    
    private func checkIfUserHasAddedQuestion() -> Bool {
        viewModel.questionTitle.isEmpty
    }
    private func typeSelected(type: SelectedType){
        viewModel.questionType = type
    }
    private func getUIForSelectedQuestionType() -> some View {
        switch viewModel.questionType {
        case .Image:
            return AnyView(selectedQuestionIsImage())
        case .MultipleChoice:
            return AnyView(MultipleChoiceView(viewModel: viewModel))
        case .Text:
            return AnyView(selectedQuestionIsText)
        case .TrueOrFalse:
            return AnyView(selectedQuestionIsTrueOrFalse)
        case .Voice:
            return AnyView(VoiceRecorderView())
        default:
            return AnyView(EmptyView())
        }
    }
    
    private func selectedQuestionIsImage() -> some View {
        HStack{
            PhotosPicker(selection: $viewModel.selectedImage) {
                Image(systemName: "photo")
                    .foregroundColor(.accentColor)
            }
            Spacer()
            if (viewModel.selectedConvertedImage != nil) {
                viewModel.selectedConvertedImage?
                    .resizable()
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        viewModel.selectedConvertedImage = nil
                    }
            }
        }
    }

    fileprivate var selectedQuestionIsText: some View {
        TextField("Enter your question:", text: $viewModel.questionTitle)
    }
    fileprivate var selectedQuestionIsTrueOrFalse: some View {
        TextField("Enter your question:", text: $viewModel.trueOrFalseQuestionTitle)
    }
    fileprivate var questionTypeSelectorComponent: some View {
            Picker("Question Type", selection: $viewModel.questionType) {
                ForEach(SelectedType.allCases, id: \.self){
                    type in
                    Button(type.rawValue){
                        typeSelected(type: type)
                    }
                }
            }
            .pickerStyle(.menu)
            .bold()        
    }
    fileprivate var buttonComponent: some View {
        Button("Add"){
            if checkIfUserHasAddedQuestion(){
                isQuestionEmpty = true
            } else{
                viewModel.addTextQuestion(context: managedObjectContext)
                dismiss.callAsFunction()
            }
        }
        .alert(isPresented: $isQuestionEmpty){
            Alert(
                title: Text("Invalid parameter"),
                message: Text("You should write something to the question dialog."),
                dismissButton: .destructive(Text("Got it"))
                
            )
        }
    }
    
    var body: some View {
        if networkManager.isNetworkReachable{
            NavigationView{
                VStack(spacing: 50){
                    questionTypeSelectorComponent
                    getUIForSelectedQuestionType()
                    Spacer()
                    buttonComponent
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .padding()
                }
                .padding()
                .onChange(of: viewModel.selectedImage) { _ in
                    viewModel.selectedImageConverter()
                    }
            }
        } else {
            SpaceView()
        }
    }
}

struct AddQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestionView()
            .environmentObject(NetworkManagerViewModel())
    }
}
