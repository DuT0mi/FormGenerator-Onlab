import SwiftUI

struct TextType: View {
    @State private var answer: String = ""
    var question: String
    
    var body: some View {
        VStack{
            Text(question)
                .downloadedQuestionTemplateModifier()
            TextField("Enter your answer: ", text: $answer)
                .lineLimit(nil)
                .padding()
        }
    }
}

struct TextType_Previews: PreviewProvider {
    static var previews: some View {
        TextType(question: "How old are you?")
    }
}
