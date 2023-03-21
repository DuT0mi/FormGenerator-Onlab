import SwiftUI
import Firebase

struct LoginView: View {
    @ObservedObject var user: UserViewModel
    @ObservedObject var networkManager: NetworkManagerViewModel
    @State private(set) var type: Pages = .login
    @State private var signUpViewIsPresented: Bool = false
    
    typealias AVC = AuthenticationViewsConstants

    
        var signUpAction: some View {
            HStack{
                Text("Don't have an account?")
                Button(action: {
                    signUpViewIsPresented = true
                }) {
                    Text("sign up".uppercased())
                        .bold()
                }
                .sheet(isPresented: $signUpViewIsPresented, content: {
                    SignupView(user: user, networkManager: networkManager, isPresented: $signUpViewIsPresented)
                })
                .buttonStyle(BorderlessButtonStyle())
                
            }
        }
        var loginContent: some View {
            VStack{
                let templateView = TemplateAuthView(user: user, type: type)
                        templateView.getTitle()
                        templateView.getEmailTextInput()
                        templateView.getPasswordTextInput()

                Spacer()
                    .frame(idealHeight:AVC.SpacerParameters.frameIdealHeightFactor * ScreenDimensions.height)
                    .fixedSize()
                
                    templateView.getUserHandlerButton()
                
                Spacer()
                    .frame(idealHeight:AVC.SpacerParameters.frameIdealHeightFactor * ScreenDimensions.height)
                    .fixedSize()
                
                signUpAction
                    .alert(isPresented: $user.alert, content: {
                        Alert(
                            title: Text("Message"),
                            message: Text(user.alertMessage),
                            dismissButton: .destructive(Text("OK"))
                        )
                    })
            }
        }
    
    var body: some View {
        if networkManager.isNetworkReachable{
            ZStack{
                loginContent
                if user.loading {
                    ProgressView()
                }
            }
        } else {
            SpaceView(networkManager: networkManager)
        }
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(user: UserViewModel(), networkManager: NetworkManagerViewModel())
    }
}
