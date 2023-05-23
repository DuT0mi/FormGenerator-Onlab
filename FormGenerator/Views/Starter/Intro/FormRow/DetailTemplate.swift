import SwiftUI

struct DetailTemplate: View {
    var form: FormData?
    var backgroundImage: String = ImageConstants.templateBackgroundImage
    var circleImage: String = ImageConstants.templateCircleImage
    
    typealias IC = ImageConstants.CircleImage
    
    var body: some View {
        ScrollView{
            if let urlString = form?.backgroundImageURL, let url = URL(string: urlString) {
                AsyncImage(url: url){ image in
                    image
                        .resizable()
                        .frame(height: ImageConstants.Downloaded.frameHeight)
                }placeholder: {
                    ProgressView()
                        .frame(height: ImageConstants.Downloaded.frameHeight)
                }
            }
            if  let urlCircle = form?.circleImageURL,
                let url = URL(string: urlCircle){
                AsyncImage(url: url){ phase in
                    switch phase{
                    case .success(let image):
                        
                        CompanyCircleView(image: circleImage, optionalImage: image)
                            .offset(y: -100)
                            .padding(.bottom, -100)
                        
                    case .empty:
                        ProgressView()
                            .frame(width: IC.defaultWidth, height: IC.defaultHeight)
                    case .failure(let error):
                        Text(error.localizedDescription)
                        
                        
                    @unknown default:
                        ProgressView()
                            .frame(width: IC.defaultWidth, height: IC.defaultHeight)
                    }
                }
            } else {
                CompanyCircleView(image: circleImage, optionalImage: nil)
                    .offset(y: -100)
                    .padding(.bottom, -100)
            }
            
            
            LazyVStack(alignment: .leading){
                HStack{
                    Text(form!.title.trimmingCharacters(in: .whitespaces))
                        .font(.title)                        
                    Text("Favourite btn here")
                }
                
                HStack{
                    Text(form!.type)
                    Spacer()
                    Text(form!.companyID)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("Description")
                    .font(.title2)
                Text(form!.description)
                    .lineLimit(nil)
                
                Spacer()
                
            }
            .padding()
            Button{
                
            }label: {
                Label("Start", systemImage: "gamecontroller")
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            
        }
        .ignoresSafeArea()
        
    }
}

struct DetailTemplate_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailTemplate(form:
                            FormData(id: UUID(),
                                     time: 10,
                                     isAvailable: true,
                                     title: "title",
                                     type: "type",
                                     companyID: "companyID",
                                     companyName: "",
                                     description: "description",
                                     backgroundImagePath: "",
                                     backgroundImageURL: "https://picsum.photos/200/300",circleImageURL: "https://picsum.photos/200/300"))
            .environmentObject(NetworkManagerViewModel())
            .environmentObject(DemoData())
        }
    }
}
