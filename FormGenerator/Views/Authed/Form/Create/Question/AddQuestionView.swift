import SwiftUI
import PhotosUI

struct AddQuestionView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddQuestionViewModel = AddQuestionViewModel()
    @State private var showAlert: Bool = false
    @State private var selectedImage: Image?
    @State private var pickedImage: PhotosPickerItem?
    @State private var recordedURL: URL?
    
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
            return AnyView(VoiceRecorderView(viewModel: viewModel, recordedURL: $recordedURL))
        default:
            return AnyView(EmptyView())
        }
    }
    
    private func selectedQuestionIsImage() -> some View {
        VStack{
            HStack{
                PhotosPicker(selection: $viewModel.selectedImage, matching: .images, photoLibrary: .shared()) {
                    HStack{
                        Image(systemName: "photo")
                            .foregroundColor(.accentColor)
                        Text("in jpeg format").italic()
                    }
                }
                Spacer()
                if (viewModel.selectedConvertedImage != nil) {
                    viewModel.selectedConvertedImage?
                        .resizable()
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            viewModel.selectedConvertedImage = nil
                        }
                        .onAppear{
                            self.pickedImage = viewModel.selectedImage
                        }
                }
            }
            TextField("Enter you question:", text: $viewModel.questionForImage)
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
                        viewModel.typeSelected(type: type)
                    }
                }
            }
            .pickerStyle(.menu)
            .bold()        
    }
    fileprivate var buttonComponent: some View {
        Button("Add"){
            if viewModel.checkAllPossibleError(){
                showAlert = true
            } else{
                viewModel.addQuestion(context: managedObjectContext,pickedImage: pickedImage, recordedURL: recordedURL)
                dismiss.callAsFunction()
            }
        }
        .alert(isPresented: $showAlert){
            Alert(
                title: Text("Invalid parameter"),
                message: Text("You have to fill properly all of the bare minimum reqirements of the selected question type"),
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
