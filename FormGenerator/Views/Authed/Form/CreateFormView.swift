import SwiftUI
import CoreData

struct CreateFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment (\.managedObjectContext) private var managedObjectContext
    @StateObject private var viewModel: CreateFormViewModel = CreateFormViewModel()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id)]) var questionCoreData: FetchedResults<QuestionCoreData>
    @State private var newQuestionText: String = ""
    @State private var showAddQuestionView: Bool = false
    
    fileprivate var submitButton: some View {
        Button("Submit Form"){
            dismiss.callAsFunction()
            Task{
                try await viewModel.createForm()
                try await viewModel.uploadForm()
            }
            CoreDataController().resetCoreData(context: managedObjectContext)
        }
    }
    fileprivate var formCreatorControllButton: some View {
        Image(systemName: "gear")
            .contextMenu {
                contextMenu
            }
            .foregroundColor(.accentColor)

    }
    
    @ViewBuilder
    fileprivate var contextMenu: some View {
        AnimatedActionButton(title: "Add question", systemImage: "doc.badge.plus"){
            showAddQuestionView = true
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
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        formCreatorControllButton
                    }
                    // Custom navigation title
                    ToolbarItem(placement: .principal){
                        Text("Create form!")
                            .font(.title)
                            .bold()
                            
                    }

                }
            }
            .sheet(isPresented: $showAddQuestionView) {
                AddQuestionView()
            }
    }
}

struct CreateFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFormView()
    }
}
