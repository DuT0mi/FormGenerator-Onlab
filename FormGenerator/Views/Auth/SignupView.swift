import SwiftUI

struct SignupView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @ObservedObject var user: UserViewModel
    @State private(set) var type: Pages = .signup
    @Binding var isPresented: Bool
    
    typealias AVC = AuthenticationViewsConstants
    
    var picker: some View {
        Picker("Account type", selection: $user.selectedAccountType){
            Text("Standard account")
                .tag(AccountType.Standard)
            Text("Company account")
                .tag(AccountType.Company)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    var logInAction: some View {
        HStack{
            Text("Already have an account?")
            Button(action: {
                isPresented = false
            }) {
                Text("login".uppercased())
                    .bold()
            }
            .buttonStyle(BorderlessButtonStyle())
               
        }
    }
    var signUpContent: some View {
        VStack{
            let templateView = TemplateAuthView(user: user, type: type)
                    templateView.getTitle()
                    templateView.getEmailTextInput()
                    templateView.getPasswordTextInput()
            Spacer()
                .frame(idealHeight: AVC.SpacerParameters.frameIdealHeightFactor * ScreenDimensions.height)
                .fixedSize()
            picker
            Spacer()
                .frame(idealHeight: AVC.SpacerParameters.frameIdealHeightFactor * ScreenDimensions.height)
                .fixedSize()
            templateView.getUserHandlerButton()
            
            Spacer()
                .frame(idealHeight: AVC.SpacerParameters.frameIdealHeightFactor * ScreenDimensions.height)
                .fixedSize()
            logInAction
            .alert(isPresented: $user.alert, content: {
                Alert(
                title: Text("Message"),
                message: Text(user.alertMessage),
                dismissButton: .destructive(Text("OK"))
                )
            })
        }
        .ignoresSafeArea()
    }
    
    var body: some View {
        if networkManager.isNetworkReachable{
            ZStack{
                if user.loading {
                    ProgressView()
                }
                signUpContent
            }
        } else {
            SpaceView()
        }
    }
}
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(user: UserViewModel(), isPresented: .constant(false))
            .environmentObject(NetworkManagerViewModel())
    }
}
