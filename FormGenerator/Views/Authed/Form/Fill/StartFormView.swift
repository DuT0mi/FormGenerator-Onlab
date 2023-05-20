import SwiftUI

struct StartFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: StartFormViewModel = StartFormViewModel()
    
    private let columns = [GridItem(.flexible())]
    var formID: String?
    
    private func getProperUIForTheQuestion(question: DownloadedQuestion) -> some View {
        switch question.type{
        case SelectedType.Image.rawValue:
            return AnyView(ImageType(viewModel: viewModel, question: question))
            
        case SelectedType.Text.rawValue:
            return AnyView(TextType(viewModel: viewModel, question: question.formQuestion!))
            
        case SelectedType.MultipleChoice.rawValue:
            return AnyView(MultipleTypeView(observer: viewModel, question: question.formQuestion!, choices: question.choices!))
            
        case SelectedType.TrueOrFalse.rawValue:
            return AnyView(TrueOrFalseTypeView(observed: viewModel, question: question.formQuestion!))
            
        case SelectedType.Voice.rawValue:
            return AnyView(AudioTypeView(observer: viewModel, audioPath: question.audio_path!))
            
        default:
            return AnyView(EmptyView())
        }
    }
    var body: some View {
        ScrollView{
                VStack{
                    ForEach(viewModel.questionsFormDB, id: \.self) { question in
                        getProperUIForTheQuestion(question: question)
                    }
                    Button{                        
                        viewModel.showAnswers()
                        dismiss.callAsFunction()
                    } label: {
                        Text("Submit!")
                    }
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                }
            }
            .onAppear{
                viewModel.downloadQuestionsForAForm(formID: formID!)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }

}

//struct StartFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartFormView()
//    }
//}

