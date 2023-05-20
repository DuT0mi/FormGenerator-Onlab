import SwiftUI

struct MultipleTypeView: View {
    @StateObject private var viewModel: MultipleTypeViewModel = MultipleTypeViewModel()
    @ObservedObject  var observer: StartFormViewModel
    @State private var symbolColorChange: Bool = false
    
    var question: String
    var choices: [String]
    
    
    var body: some View {
        VStack{
            Text(question)
                .downloadedQuestionTemplateModifier()
            ForEach(viewModel.options){option in
                Button {
                    viewModel.selectedOption = option.multilpleTypeValue
                } label: {
                    HStack{
                        Circle()                            
                            .foregroundColor(option.multilpleTypeValue == viewModel.selectedOption ? .accentColor : .gray)
                            .frame(width: 25, height: 25)
                        Text(option.multilpleTypeValue ?? "")
                            .foregroundColor((symbolColorChange && option.multilpleTypeValue == viewModel.selectedOption) ? .green : .gray)
                        Spacer()
                    }
                }
                .disabled(symbolColorChange ? true: false)
            }
            
            Image(systemName: "rectangle.filled.and.hand.point.up.left")
                .onTapGesture {
                    symbolColorChange = true
                    observer.answers.append(viewModel.selectedOption!)
                }
                .foregroundColor(symbolColorChange ? .green : .gray)
                .disabled(symbolColorChange ? true : false)
                .padding()
        }
        .padding()
        .onAppear{
            viewModel.loadQuestions(choices: choices)
        }
    }
}

struct MultipleTypeView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTypeView(observer: StartFormViewModel(), question: "What do you think about that?", choices: ["OPTION 1","OPTION 2","OPTION 3","OPTION 4"])
    }
}
