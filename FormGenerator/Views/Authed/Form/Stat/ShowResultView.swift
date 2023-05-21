import SwiftUI

struct ShowResultView: View {
    @StateObject private var viewModel: ShowResultsViewModel = ShowResultsViewModel()
    var form: FormData?
    
    private func drawTitle(question: DownloadedQuestion) -> some View {
        Text("Title: \(question.formQuestion == "nil" ? "Voice" : question.formQuestion!)")
            .bold()
            .italic()
    }
    private func drawAnswers(question: DownloadedQuestion) -> AnyView{
        switch question.type{
            case SelectedType.Image.rawValue:
                return AnyView(drawAnswersTextBased(question: question))
            case SelectedType.MultipleChoice.rawValue: break
            case SelectedType.Text.rawValue:
                return AnyView(drawAnswersTextBased(question: question))
            case SelectedType.TrueOrFalse.rawValue: break
            case SelectedType.Voice.rawValue:
                return AnyView(drawAnswersTextBased(question: question))
            default: break
        }
        return AnyView(EmptyView())
    }
    private func drawAnswersTextBased(question: DownloadedQuestion) -> some View{
        VStack{
            Text("answers")
                .bold()
            ForEach(viewModel.answers, id: \.answer){ answer in
                if question.id == answer.id{
                    Text(answer.answer)
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack{                
                if viewModel.isWorking{
                    ProgressView()
                }else {
                    ForEach(viewModel.questions, id:\.id){question in
                        drawTitle(question: question)
                        drawAnswers(question: question)
                        Divider()
                            .bold()
                            .foregroundColor(.red)
                    }
                }
            }
            .task{
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
