import SwiftUI

struct TextType: View {
    @State private var answer: String = ""
    @State private var symbolColorChange: Bool = false
    @ObservedObject var viewModel: StartFormViewModel
    
    var question: String
    
    var body: some View {
        VStack{
            Text(question)
                .downloadedQuestionTemplateModifier()
            HStack{
                TextField("Enter your answer: ", text: $answer)
                    .lineLimit(nil)
                    .padding()
                    .disabled(symbolColorChange ? true : false)

                Image(systemName: "rectangle.filled.and.hand.point.up.left")
                    .onTapGesture {
                        symbolColorChange = true
                        viewModel.answers.append(answer)
                    }
                    .foregroundColor(symbolColorChange ? .green : .gray)
                    .disabled(symbolColorChange ? true : false)
            }
            .padding(.trailing)
        }
    }
}

struct TextType_Previews: PreviewProvider {
    static var previews: some View {
        TextType(viewModel: StartFormViewModel(), question: "How old are you?")
    }
}
