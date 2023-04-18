import SwiftUI
import CoreData

struct CreateFormView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment (\.managedObjectContext) private var managedObjectContext
    @StateObject private var viewModel: CreateFormViewModel = CreateFormViewModel()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.qDate, order: .reverse)]) var questionCoreData: FetchedResults<QuestionCoreData>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id, order: .reverse)]) var formMetaData: FetchedResults<FormCoreData>
    @State private var showAddQuestionView: Bool = false
    @State private var showAddFormView: Bool = false
    @State private var showFormPreview: Bool = false
    @State private var editMode: EditMode = .inactive
    @State private var isQuestionsCountZero: Bool = false
    
    fileprivate var tap: some Gesture {
        TapGesture().onEnded {  }
    }
    fileprivate var submitButton: some View {
        Button("Submit Form"){
            if isThereAtLeastOneQuestion(),
               AddFormViewModel.shared.isFormHasBeenAdded
            {
                dismiss.callAsFunction()
                Task{
                    try await viewModel.createAndUploadForm(allQData: questionCoreData, allFData: formMetaData, context: managedObjectContext)
                }
                CoreDataController().resetCoreData(context: managedObjectContext)
                // Adjust it back, to avoid invalid access to the preview
                AddFormViewModel.shared.isFormHasBeenAdded = false
            } else {
                isQuestionsCountZero = true
            }
        }
        .alert(isPresented: $isQuestionsCountZero){
            Alert(
                title: Text("Invalid parameter(s)!"),
                message: Text("You should have at least one question/Form!"),
                dismissButton: .destructive(Text("Got it!"))
            )
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
            AnimatedActionButton(title: "Add", systemImage: "plus"){
                showAddFormView = true
            }
            if AddFormViewModel.shared.isFormHasBeenAdded { // If the user has any form the show preview
                AnimatedActionButton(title: "Preview", systemImage: "eye"){
                    showFormPreview = true
                }
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
    private func isThereAtLeastOneQuestion() -> Bool{
        questionCoreData.count > 0
    }
    
    var body: some View {
        if networkManager.isNetworkReachable{
                VStack(spacing: 40) {
                    List{
                        ForEach(questionCoreData.filter({$0.uid == UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)})){question in
                                NavigationLink(destination: EditQuestionView(question: question)) {
                                    HStack{
                                        VStack(alignment: .leading, spacing: 5.0){
                                            Text(question.question ?? "").bold()
                                            Text(question.type ?? "")
                                                .foregroundColor(.red)
                                        }
                                        .gesture(editMode == .active ? tap : nil)
                                        Spacer()
                                        Text(timeSinceCreated(date: question.qDate ?? Date()))
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
                .sheet(isPresented: $showAddFormView) {
                    AddFormView()
                }
                .sheet(isPresented: $showFormPreview) {
                    if let form = formMetaData.first(where: {$0.cID == UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)}){
                        FormPreview(form: form)
                    }
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
