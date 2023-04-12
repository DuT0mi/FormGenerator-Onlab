import SwiftUI

struct FormViewDetail: View {
    @ObservedObject var networkManager: NetworkManagerViewModel
    var form: FormData
    
    var body: some View {
            ScrollView{
                Image("form_demo")
                    .resizable()
                    .frame(height: 300)
                
                CompanyCircleView(image: "checkmark")
                    .offset(y: -100)
                    .padding(.bottom, -100)
                
                LazyVStack(alignment: .leading){
                    HStack{
                        Text(form.title)
                            .font(.title)
                        Text("Favourite btn here")
                    }
                    
                    HStack{
                        Text(form.type)
                        Spacer()
                        Text(form.companyID)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Form's description")
                        .font(.title2)
                    Text(form.description)
                    
                    Spacer()
                    
                }
                .padding()
                
                Button("Start form"){
                    // TODO:
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
            .ignoresSafeArea()
    }
}

struct FormViewDetailt_Previews: PreviewProvider {
    static var previews: some View {
        FormViewDetail( networkManager: NetworkManagerViewModel(), form:
                        FormData(id: UUID(),
                                 title: "title",
                                 type: "type",
                                 companyID: "companyID",
                                 description: "description",
                                 answers: "answers"))
    }
}
