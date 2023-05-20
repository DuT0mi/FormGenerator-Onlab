import SwiftUI

struct TrueOrFalseTypeView: View {
    @StateObject private var viewModel: TrueOrFalseTypeViewModel = TrueOrFalseTypeViewModel()
    @ObservedObject var observed: StartFormViewModel
    @State private var symbolColorChange: Bool = false
    
    var question: DownloadedQuestion
    
    var body: some View {
        VStack{
            Text(question.formQuestion!)
                .downloadedQuestionTemplateModifier()
                HStack{
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundColor((viewModel.selectedOption ?? false) ? .accentColor : .gray)
                        .onTapGesture {
                            if !symbolColorChange{
                                viewModel.selectedOption = true
                            }
                        }
                    Text("True")
                        .foregroundColor(.accentColor)
                    Spacer()
                }
                HStack{
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundColor(!(viewModel.selectedOption ?? false) ? .accentColor : .gray)
                        .onTapGesture {
                            viewModel.selectedOption = false
                        }
                    Text("False")
                        .foregroundColor(.accentColor)
                    Spacer()
                }
            Image(systemName: "rectangle.filled.and.hand.point.up.left")
                .onTapGesture {
                    symbolColorChange = true
                    observed.answers.append((viewModel.selectedOption?.description ?? "false", question.id!))
                }
                .foregroundColor(symbolColorChange ? .green : .gray)
                .disabled(symbolColorChange ? true : false)
                .padding()
        }
        .padding()
    }
}

struct TrueOrFalseTypeView_Previews: PreviewProvider {
    static var previews: some View {
        TrueOrFalseTypeView(observed: StartFormViewModel(), question: DownloadedQuestion(id: "1", formQuestion: "Hello", type: "aa", choices: ["a"], audio_path: "", image_url: "https://picsum.photos/200/300"))
    }
}
