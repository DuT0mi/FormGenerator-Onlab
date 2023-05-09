import SwiftUI
import PhotosUI

struct EditQuestionView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @StateObject private var viewModel: AddQuestionViewModel = AddQuestionViewModel()
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    @State private var showError: Bool = false
    @State private var recordedURL: URL?
    @State private var pickedImage: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var question: FetchedResults<QuestionCoreData>.Element

    private func getUIForSelectedQuestionType() -> some View {
        switch viewModel.questionType {
        case .Image:
            return AnyView(imageTypeComponent())
        case .MultipleChoice:
            return AnyView(MultipleChoiceView(viewModel: viewModel))
        case .Voice:
            return voiceTypeComponent()
        default:
            return AnyView(EmptyView())
        }
    }
    // MARK: Intent
    private func loadCurrentFieldsAsIntent(){
        if let data = try? JSONDecoder().decode([TextFieldModel].self, from: question.multipleOptions as! Data){
            viewModel.updateFields(fields: data)
        }
        
    }
    private func imageTypeComponent() -> some View{
        VStack{
            if let imageData = question.imgData, let image = UIImage(data: imageData) {
                HStack{
                    Spacer()
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .opacity(viewModel.selectedConvertedImage != nil ? 0.2 : 1)
                }
            }
            else {
                HStack{
                    Spacer()
                    Image(systemName: "wrongwaysign")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 100, height: 100)
                        .opacity(viewModel.selectedConvertedImage != nil ? 0.2 : 1)
                }
            }
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
                            viewModel.questionForImage = question.question ?? ""
                        }
                }
            }
        }
    }
    private func voiceTypeComponent() -> AnyView{
        AnyView(VoiceRecorderView(viewModel: viewModel, recordedURL: $recordedURL, templateURL: question.audioURL))
    }
    private func getBindedTitle() -> Binding<String>{
        switch viewModel.questionType {
            case .Text:
                return $viewModel.questionTitle
            case .Image:
                return $viewModel.questionForImage
            case .MultipleChoice:
                return $viewModel.questionTitleMultiple
            case .TrueOrFalse:
                return $viewModel.trueOrFalseQuestionTitle
            default:
                return $viewModel.questionTitle
                
        }
    }
    fileprivate var questionComponent: some View {
        HStack{
            if viewModel.questionType != .Voice, viewModel.questionType != .Default{
                TextField("\(question.question ?? viewModel.questionType.rawValue)", text: getBindedTitle())
                    .onAppear{
                        viewModel.questionTitle = question.question ?? viewModel.questionType.rawValue
                        if viewModel.questionType == .MultipleChoice {
                            loadCurrentFieldsAsIntent()
                        }
                    }
            }
            Menu("Type: \(viewModel.questionType.rawValue)"){
                ForEach(SelectedType.allCases, id: \.self){
                    type in
                    Button(type.rawValue){
                        viewModel.typeSelected(type: type)
                    }
                }
            }
            .onAppear{
                viewModel.typeSelected(type: SelectedType(rawValue: question.type ?? viewModel.questionType.rawValue) ?? .Default)
            }
        }
    }
    fileprivate var buttonComponent: some View {
        Button("Edit"){
            if viewModel.checkAllPossibleError(){
                showError = true
            } else {
                viewModel.editQuestion(context: managedObjectContext, question: question, pickedImage: pickedImage, recordedURL: recordedURL, oldType: question.type!)
                dismiss.callAsFunction()
            }
        }
        .alert(isPresented: $showError){
            Alert(
                title: Text("Invalid parameter"),
                message: Text("You have to fill properly all of the bare minimum reqirements of the selected question type."),
                dismissButton: .destructive(Text("Got it")) 
            )
        }
    }
    var body: some View {
        if networkManager.isNetworkReachable{
            NavigationView{
                VStack(spacing: QuestionConstants.editQuestionStackSpacingParameter){
                        questionComponent
                        getUIForSelectedQuestionType()
                    if viewModel.questionType != .Default{
                        buttonComponent
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                    }
                    Spacer()
                }
            }
            .padding()
            .onChange(of: viewModel.selectedImage) { _ in
                viewModel.selectedImageConverter()
                }

        } else {
            SpaceView()
        }
    }
}
