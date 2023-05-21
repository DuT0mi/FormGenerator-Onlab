import SwiftUI
import Charts

struct AnswersByTrueOrFalse{
    let id: UUID = UUID()
    let count: Int
    let value: String
}

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
            case SelectedType.TrueOrFalse.rawValue:
                 return AnyView(drawTrueOrFalseChart(question: question))
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
    private func drawTrueOrFalseChart(question: DownloadedQuestion) -> some View{
        var countTrue: Int = 0
        var countFalse: Int = 0
        countLogicalValues(trueValues: &countTrue, falseValues: &countFalse, question: question)
        let data: [AnswersByTrueOrFalse] = [
            AnswersByTrueOrFalse(count: countFalse, value: AppConstants.FALSE),
            AnswersByTrueOrFalse(count: countTrue, value: AppConstants.TRUE)
        ]
        return VStack{
            Chart(data, id:\.id){
                BarMark(
                    x: .value("Value", $0.value),
                    y: .value("Quantity", $0.count)
                )
                .foregroundStyle(by: .value("Value", $0.value))
            }
            .chartPlotStyle(content: { chartPlot in
                chartPlot
                    .background(.gray)
            })
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                AxisValueLabel()
                        .foregroundStyle(.black)
              }
            }
            .chartYAxis {
              AxisMarks(values: .automatic) { _ in
                AxisValueLabel()
                      .foregroundStyle(.black)
              }
            }
            .frame(width: 175, height: 300)
            .padding()
        }
    }
    private func countLogicalValues(trueValues: inout Int, falseValues: inout Int, question: DownloadedQuestion){
        viewModel.answers.forEach {
            if $0.id == question.id{
                if $0.answer == AppConstants.TRUE{
                    trueValues += 1
                }else {
                    falseValues += 1
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
