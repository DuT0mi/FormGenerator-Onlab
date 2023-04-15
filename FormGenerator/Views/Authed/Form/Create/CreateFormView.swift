import SwiftUI
import CoreData

struct CreateFormView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment (\.managedObjectContext) private var managedObjectContext
    @StateObject private var viewModel: CreateFormViewModel = CreateFormViewModel()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var questionCoreData: FetchedResults<QuestionCoreData>
    @State private var showAddQuestionView: Bool = false
    @State private var showEditFormView: Bool = false
    @State private var showFormPreview: Bool = false
    @State private var editMode: EditMode = .inactive
    
    fileprivate var tap: some Gesture {
        TapGesture().onEnded {  }
    }
    fileprivate var submitButton: some View {
        Button("Submit Form"){
            dismiss.callAsFunction()
            Task{
                try await viewModel.createAndUploadForm(allData: questionCoreData, context: managedObjectContext)
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
    fileprivate var formMenu: some View {
        Menu {
            AnimatedActionButton(title: "Edit", systemImage: "pencil"){
                showEditFormView = true
            }
            AnimatedActionButton(title: "Preview", systemImage: "eye"){
                showFormPreview = true
            }
        }label: {
            Label("Form", systemImage: "doc.badge.gearshape")
        }
    }
    fileprivate var questionMenu: some View {
        Menu{
            AnimatedActionButton(title: "Add", systemImage: "plus"){
                showAddQuestionView = true
            }
        }label: {
            Label("Question", systemImage: "questionmark.folder")
        }
    }
    
    @ViewBuilder
    fileprivate var contextMenu: some View {
        questionMenu
        formMenu
    }
   
    private func deleteQuestion(index: IndexSet){
        withAnimation {
            index.map{questionCoreData[$0]}.forEach(managedObjectContext.delete)
            CoreDataController().save(context: managedObjectContext)
        }
    }
    
    var body: some View {
        if networkManager.isNetworkReachable{
                VStack(spacing: 40) {
                    List{
                        ForEach(questionCoreData.filter({$0.uid == UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)})){question in
                            NavigationLink(destination: EditQuestionView(question: question)) {
                                HStack{
                                    VStack(alignment: .leading, spacing: 5.0){
                                        Text(question.question!).bold()
                                        Text(question.type!)
                                            .foregroundColor(.red)
                                    }
                                    .gesture(editMode == .active ? tap : nil)
                                    Spacer()
                                    Text(timeSinceCreated(date: question.date!))
                                        .italic()
                                }
                            }
                        }
                        .onDelete(perform: deleteQuestion)
                    }
                    .listStyle(.plain)
                    submitButton
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .padding()
                }
                .navigationTitle("Create Form")
                .toolbar {
                    ToolbarItem(placement:.navigationBarTrailing){
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        formCreatorControllButton
                    }
                }
                .sheet(isPresented: $showAddQuestionView) {
                    AddQuestionView()
                }
                .sheet(isPresented: $showEditFormView) {
                    EditFormView()
                }
                .sheet(isPresented: $showFormPreview) {
                    FormPreview()
                }
                .environment(\.editMode, $editMode)
        } else {
            SpaceView()
        }
    }
}

struct CreateFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            CreateFormView()
                .environmentObject(NetworkManagerViewModel())
        }
    }
}
