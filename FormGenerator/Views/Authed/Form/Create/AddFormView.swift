import SwiftUI

struct AddFormView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var formTitle: String = ""
    @State private var formCompanyName: String = ""
    @State private var formDescription: String = ""
    @State private var formType: String = ""
    @State private var isThereAnyEmptyField: Bool = false
    
    var backgroundImage = "form_demo"
    var circleImage = "checkmark"
    
    private func isEmptySomething() -> Bool{
         formTitle.isEmpty       ||
         formCompanyName.isEmpty ||
         formDescription.isEmpty ||
         formType.isEmpty
        
    }
    
    fileprivate var buttonComponent: some View {
        Button("Add"){
            if isEmptySomething(){
                isThereAnyEmptyField = true
            } else {
                let formData = FormData(id: UUID(),
                                        title: formTitle,
                                        type: formType,
                                        companyID: UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)!,
                                        companyName: formCompanyName,
                                        description: formDescription,
                                        answers: "answers")
                
                CoreDataController().addFormMetaData(context: managedObjectContext, formData: formData)
                AddFormViewModel.shared.isFormHasBeenAdded = true
                dismiss.callAsFunction()
            }
        }
        .alert(isPresented: $isThereAnyEmptyField){
            Alert(
                title: Text("Invalid parameter(s)!"),
                message: Text("You have to fill every field!"),
                dismissButton: .destructive(Text("Got it!"))
            )
            
        }
    }
    
    var body: some View {
            ScrollView{
                LazyVStack{
                    Image(backgroundImage)
                        .resizable()
                        .frame(height: 300)
                    
                    CompanyCircleView(image: circleImage)
                        .offset(y: -100)
                        .padding(.bottom, -100)
                    
                    LazyVStack(alignment: .leading){
                        TextField("Title", text: $formTitle)
                            .font(.title)
                        
                        HStack{
                            TextField("Type", text: $formType)
                            Divider()
                                .background(.black)
                                .bold()
                                
                            TextField("Company",text: $formCompanyName)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        VStack{
                            TextField("Description", text: $formDescription)
                            Divider()
                                .background(.red)
                                .bold()
                                .font(.title2)
                            Text(formDescription)
                                .lineLimit(nil)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    buttonComponent
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .edgesIgnoringSafeArea(.top)
    }
}
