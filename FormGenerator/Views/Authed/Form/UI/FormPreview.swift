import SwiftUI

struct FormPreview: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    var form: FetchedResults<FormCoreData>.Element
    var backgroundImage: String = ImageConstants.templateBackgroundImage
    var circleImage: String = ImageConstants.templateCircleImage
    
    var body: some View {
            ScrollView{
                LazyVStack{
                    ImageViewModel.shared.selectedImage!
                        .resizable()
                        .frame(height: ImageConstants.backgroundImageFrameHeight)
                    
                    CompanyCircleView(image: circleImage)
                        .offset(y: -100)
                        .padding(.bottom, -100)
                    
                    LazyVStack(alignment: .leading){
                        HStack{
                            Text(form.title ?? "Title")
                                .font(.title)
                            Text("Favourite btn here")
                        }
                        
                        HStack{
                            Text(form.type ?? "Type")
                            Spacer()
                            Text(form.cName ?? "Company")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        Divider()
                        
                        Text("Description")
                            .font(.title2)
                        Text(form.cDesc ?? "Description template")
                            .lineLimit(nil)
                        
                        Spacer()
                        
                    }
                    .padding()
                    Button("Cool!"){
                        dismiss.callAsFunction()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .edgesIgnoringSafeArea(.top)
    }
}
