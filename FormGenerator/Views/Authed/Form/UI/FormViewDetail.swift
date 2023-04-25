import SwiftUI

struct FormViewDetail: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    var form: FormData
    var backgroundImage: String = "form_demo"
    var circleImage: String = "checkmark"
    
    var body: some View {
            ScrollView{
                LazyVStack{
                    if let urlString = form.backgroundImageURL, let url = URL(string: urlString) {
                        AsyncImage(url: url){ image in
                            image
                                .resizable()
                                .frame(height: 300)
                        }placeholder: {
                            ProgressView()
                                .frame(height: 300)
                        }
                    }
                    
                    CompanyCircleView(image: circleImage)
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
                        
                        Text("Description")
                            .font(.title2)
                        Text(form.description)
                            .lineLimit(nil)
                        
                        Spacer()
                        
                    }
                    .padding()
                    
                    Button("Start form"){
                        // TODO: Add content here
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .edgesIgnoringSafeArea(.top)
    }
}

struct FormViewDetailt_Previews: PreviewProvider {
    static var previews: some View {
        FormViewDetail(form:
                        FormData(id: UUID(),
                                 title: "title",
                                 type: "type",
                                 companyID: "companyID",
                                 companyName: "",
                                 description: "description",
                                 answers: "answers",
                                 backgroundImagePath: "",
                                 backgroundImageURL: "https://picsum.photos/200/300"))
        .environmentObject(NetworkManagerViewModel())
    }
}
