import SwiftUI

struct AddFormView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var formTitle: String = ""
    @State private var formCompanyName: String = ""
    @State private var formDescription: String = ""
    @State private var formType: String = ""
    
    var backgroundImage = "form_demo"
    var circleImage = "checkmark"
    
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
                            Spacer()
                            TextField("Company",text: $formCompanyName)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        Divider()
                        
                        TextField("Description", text: $formDescription)
                            .font(.title2)
                        
                        Spacer()
                    }
                    .padding()
                    Button("Add"){
                        CoreDataController().addFormMetaData(context: managedObjectContext, formData: FormData(id: UUID(), title: formTitle, type: formType, companyID: UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)!, companyName: formCompanyName, description: formDescription, answers: "answers"))
                        dismiss.callAsFunction()
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .edgesIgnoringSafeArea(.top)
    }
}
