import SwiftUI

struct AddQuestionView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    @State private var questionTitle: String = ""
    @State private var questionType: SelectedType = .Default
    @State private var isQuestionEmpty: Bool = false
    
    private func checkIfUserHasAddedQuestion() -> Bool {
        questionTitle.isEmpty
    }
    private func typeSelected(type: SelectedType){
        self.questionType = type
    }
    fileprivate var questionComponent: some View {
        HStack{
            TextField("Enter your question", text: $questionTitle)
            Menu("Type: \(questionType.rawValue)"){
                ForEach(SelectedType.allCases, id: \.self){
                    type in
                    Button(type.rawValue){
                        typeSelected(type: type)
                    }
                }
            }
        }
    }
    fileprivate var buttonComponent: some View {
        Button("Add"){
            if checkIfUserHasAddedQuestion(){
                isQuestionEmpty = true
            } else{
                CoreDataController().addQuestion(context: managedObjectContext, question: questionTitle, type: questionType.rawValue)
                
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
            ZStack{
                VStack(spacing: 50){
                    questionComponent
                    buttonComponent
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                    Spacer()
                    Spacer()
                }
            }
            .padding()
        } else {
            SpaceView()
        }
    }
}

struct AddQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestionView()
            .environmentObject(NetworkManagerViewModel())
    }
}
