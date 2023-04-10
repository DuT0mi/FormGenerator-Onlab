import SwiftUI
import CoreData

struct CreateFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment (\.managedObjectContext) private var managedObjectContext
    @StateObject private var viewModel: CreateFormViewModel = CreateFormViewModel()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id)]) var questionCoreData: FetchedResults<QuestionCoreData>
    @State private var newQuestionText: String = ""
    
    fileprivate var submitButton: some View {
        Button("Submit Form"){
            dismiss.callAsFunction()
            Task{
                try await viewModel.createForm()
                try await viewModel.uploadForm()
            }
        }
    }
    private func deleteQuestion(index: IndexSet){
        withAnimation {
            // delete the question
            index.map{questionCoreData[$0]}.forEach(managedObjectContext.delete)
            // save the current state
            CoreDataController().save(context: managedObjectContext)
        }
    }
    
    var body: some View {
            NavigationView {
                VStack(spacing: 40) {
                    List{
                        ForEach(questionCoreData){question in
                            NavigationLink(destination: EditQuestionView(question: question)) {
                                HStack{
                                    VStack(alignment: .leading, spacing: 5.0){
                                        Text(question.question!).bold()
                                        Text(question.type!)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteQuestion)
                    }
                    .listStyle(.plain)
                    submitButton
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                }
                .padding()
                .navigationTitle("Create form!")
                .toolbar {
                    ToolbarItem(placement:.navigationBarTrailing){
                        NavigationLink {
                            AddQuestionView()
                        } label: {
                            Image(systemName: "doc.badge.plus")
                                .bold()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading){
                        EditButton()
                    }

                }
            }
    }
}

struct CreateFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFormView()
    }
}
