import SwiftUI

struct CircleOption: Identifiable, Equatable {
    let id: UUID = UUID()
    let multilpleTypeValue: String?
    let trueOrFalseTypeValue: Bool?
    
    init(multilpleTypeValue: String? = nil, trueOrFalseTypeValue: Bool? = nil) {
        self.multilpleTypeValue = multilpleTypeValue
        self.trueOrFalseTypeValue = trueOrFalseTypeValue
    }
}

@MainActor
final class MultipleTypeViewModel: ObservableObject{
    @Published var options: [CircleOption] = []
    @Published var selectedOption: String?
    
    func loadQuestions(choices: [String]){
        options.reserveCapacity(choices.count)
        choices.forEach { options.append(CircleOption(multilpleTypeValue: $0.description)) }
    }
    
}

struct MultipleTypeView: View {
    @StateObject private var viewModel: MultipleTypeViewModel = MultipleTypeViewModel()
    
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
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
                
            }
        }
        .padding()
        .onAppear{
            viewModel.loadQuestions(choices: choices)
        }
    }
}

struct MultipleTypeView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTypeView(question: "What do you think about that?", choices: ["OPTION 1","OPTION 2","OPTION 3","OPTION 4"])
    }
}
