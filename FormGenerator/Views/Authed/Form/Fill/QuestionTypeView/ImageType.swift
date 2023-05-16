import SwiftUI

struct ImageType: View {
    @State private var answer: String = ""
    
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
            TextField("Enter your answer: ", text: $answer)
                .lineLimit(nil)
                .padding()
        }
    }
}

struct ImageType_Previews: PreviewProvider {
    static var previews: some View {
        ImageType(
            question: DownloadedQuestion(id: "1", formQuestion: "Hello", type: "aa", choices: ["a"], audio_path: "", image_url: "https://picsum.photos/200/300"))
    }
}

