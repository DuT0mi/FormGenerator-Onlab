import SwiftUI

struct AddQuestionView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    @State private var questionTitle: String = ""
    @State private var questionType: SelectedType = .none
    
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
        Button("Submit question"){
            CoreDataController().addQuestion(context: managedObjectContext, question: questionTitle, type: questionType.rawValue)
            
            dismiss.callAsFunction()
        }
    }
    
    var body: some View {
        if networkManager.isNetworkReachable{
            VStack(spacing: 50){
                questionComponent
                buttonComponent
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                Spacer()
                Spacer()
            }
            .padding()
        } else {
            SpaceView(networkManager: networkManager)
        }
    }
}

struct AddQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestionView()
            .environmentObject(NetworkManagerViewModel())
    }
}
