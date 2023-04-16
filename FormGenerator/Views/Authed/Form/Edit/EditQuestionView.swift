import SwiftUI

struct EditQuestionView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    @State private var questionTitle: String = ""
    @State private var questionType: SelectedType = .none
    @State private var isQuestionEmpty: Bool = false
    
    var question: FetchedResults<QuestionCoreData>.Element

    private func typeSelected(type: SelectedType){
        self.questionType = type
    }
    private func checkIfUserHasAddedQuestion() -> Bool {
        questionTitle.isEmpty
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
    fileprivate var buttonComponent: some View {
        Button("Edit"){
            if checkIfUserHasAddedQuestion(){
                isQuestionEmpty = true
            } else {
                CoreDataController().editQuestion(context: managedObjectContext,question: question, question: questionTitle, type: questionType.rawValue)
                dismiss.callAsFunction()
            }
        }
        .alert(isPresented: $isQuestionEmpty){
            Alert(
                title: Text("Invalid parameter"),
                message: Text("You should write something to the question dialog."),
                dismissButton: .destructive(Text("Got it"))
                
            )
        }
    }
    
    var body: some View {
        if networkManager.isNetworkReachable{
            NavigationView{
                VStack(spacing: 50){
                    questionComponent
                    
                    buttonComponent
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
