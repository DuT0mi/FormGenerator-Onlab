import SwiftUI

struct ImageType: View {
    @State private var answer: String = ""
    @State private var symbolColorChange: Bool = false
    @ObservedObject var viewModel: StartFormViewModel
    
    var question: DownloadedQuestion
    
    var body: some View {
        VStack{
            Text(question.formQuestion!)
                    .downloadedQuestionTemplateModifier()
        
            if let url = URL(string: question.image_url ?? "https://picsum.photos/200/300"){
                AsyncImage(url: url){ image in
                    image
                        .resizable()
                        .frame(width: 225, height: 150)                        
                }placeholder: {
                    ProgressView()
                        .frame(width: 225, height: 150)
                }
            }
            HStack{
                TextField("Enter your answer: ", text: $answer)
                    .lineLimit(nil)
                    .padding()
                    .disabled(symbolColorChange ? true : false)

                Image(systemName: "rectangle.filled.and.hand.point.up.left")
                    .onTapGesture {
                        symbolColorChange = true
                        //viewModel.answers.append(answer)
                        viewModel.answers.append((answer,question.id!))
                    }
                    .foregroundColor(symbolColorChange ? .green : .gray)
                    .disabled(symbolColorChange ? true : false)
            }
            .padding(.trailing)
        }
    }
}

struct ImageType_Previews: PreviewProvider {
    static var previews: some View {
        ImageType(viewModel: StartFormViewModel(), question: DownloadedQuestion(id: "1", formQuestion: "Hello", type: "aa", choices: ["a"], audio_path: "", image_url: "https://picsum.photos/200/300"))
    }
}

