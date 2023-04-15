import SwiftUI

struct EditQuestionView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    @State private var questionTitle: String = ""
    @State private var questionType: SelectedType = .none
    
    var question: FetchedResults<QuestionCoreData>.Element

    private func typeSelected(type: SelectedType){
        self.questionType = type
    }
    fileprivate var questionComponent: some View {
        HStack{
            TextField("\(question.question!)", text: $questionTitle)
                .onAppear{
                    questionTitle = question.question!
                }
            Menu("Type: \(questionType.rawValue)"){
                ForEach(SelectedType.allCases, id: \.self){
                    type in
                    Button(type.rawValue){
                        typeSelected(type: type)
                    }
                }
            }
            .onAppear{
                typeSelected(type: SelectedType(rawValue: question.type!) ?? .none)
            }
        }
    }
    var body: some View {
        if networkManager.isNetworkReachable{
            NavigationView{
                VStack(spacing: 50){
                    questionComponent
                    Button("Submit question"){
                        CoreDataController().editQuestion(context: managedObjectContext,question: question, question: questionTitle, type: questionType.rawValue)
                        dismiss.callAsFunction()
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    Spacer()
                }
            }
            .padding()
        } else {
            SpaceView()
        }
    }
}
