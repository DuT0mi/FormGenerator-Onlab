import SwiftUI

struct FormViewDetail: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @State private var showStartingView: Bool = false
    var form: FormData
    
    var backgroundImage: String = ImageConstants.templateBackgroundImage
    var circleImage: String = ImageConstants.templateCircleImage
    
    typealias IC = ImageConstants.CircleImage
    
    var body: some View {
            ScrollView{
                LazyVStack{
                    if let urlString = form.backgroundImageURL, let url = URL(string: urlString) {
                        AsyncImage(url: url){ image in
                            image
                                .resizable()
                                .frame(height: ImageConstants.Downloaded.frameHeight)
                        }placeholder: {
                            ProgressView()
                                .frame(height: ImageConstants.Downloaded.frameHeight)
                        }
                    }
                    if  let urlCircle = form.circleImageURL,
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
                        showStartingView = true
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .fullScreenCover(isPresented: $showStartingView) {
                StartFormView(formID: form.id.uuidString)
            }
            
    }
}

struct FormViewDetailt_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            FormViewDetail(form:
                            FormData(id: UUID(),
                                     time: 10,
                                     title: "title",
                                     type: "type",
                                     companyID: "companyID",
                                     companyName: "",
                                     description: "description",                                     
                                     backgroundImagePath: "",
                                     backgroundImageURL: "https://picsum.photos/200/300",circleImageURL: "https://picsum.photos/200/300"))
            .environmentObject(NetworkManagerViewModel())
        }
    }
}
