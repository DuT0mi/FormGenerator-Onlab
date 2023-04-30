import SwiftUI

struct FormPreview: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isAccountPremium: Bool = false
    var form: FetchedResults<FormCoreData>.Element
    var backgroundImage: String = ImageConstants.templateBackgroundImage
    var circleImage: String = ImageConstants.templateCircleImage
    
    var body: some View {
            ScrollView{
                LazyVStack{
                    ImageViewModel.shared.selectedBackgroundImage!
                        .resizable()
                        .frame(height: ImageConstants.backgroundImageFrameHeight)
                    CompanyCircleView(image: circleImage, optionalImage: isAccountPremium ? ImageViewModel.shared.selectedCircleImage : nil)
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
                .onAppear{
                    Task{
                        isAccountPremium = try await AccountManager.shared.getCompanyAccount(userID: UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)!).isPremium ?? false
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
    }
}
