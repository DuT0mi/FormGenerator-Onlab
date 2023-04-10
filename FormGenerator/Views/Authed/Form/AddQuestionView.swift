import SwiftUI

struct AddQuestionView: View {
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
    var body: some View {
        NavigationView{
            VStack(spacing: 50){
                questionComponent
                Button("Submit question"){
                    CoreDataController().addQuestion(context: managedObjectContext, question: questionTitle, type: questionTitle)
                    
                    dismiss.callAsFunction()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
        }
        .padding()
    }
}

struct AddQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestionView()
    }
}
