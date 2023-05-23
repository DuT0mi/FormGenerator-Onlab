import SwiftUI

struct QuestionRowView: View {
    
    var questions: [DemoQuestion] {
        
        var array: [DemoQuestion] = []
        for typeCase in DemoQuestionType.allCases{
            array.append(DemoQuestion(type: typeCase))
        }
        return array
    }
    
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Questions")
                .font(.headline)
                .bold()
                .padding(.leading, 15)
                .padding(.top, 5)
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .bottom, spacing: ScreenDimensions.width / 10){
                    ForEach(questions, id:\.id) { question in
                        VStack{
                            Text(question.title!)
                                .bold()
                                .italic()
                            question.image
                                .resizable()
                                .frame(width: 200, height: 200)
                                .aspectRatio(1/2, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 10)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct QuestionRowView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionRowView()
    }
}
