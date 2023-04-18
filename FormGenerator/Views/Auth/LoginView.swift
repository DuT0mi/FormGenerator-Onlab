import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @ObservedObject var user: UserViewModel
    @State private(set) var type: Pages = .login
    @State private var signUpViewIsPresented: Bool = false
    
    typealias AVC = AuthenticationViewsConstants
    
    var appleSignInButton: some View {
        Button(action: {
            Task {
                do {
                    user.signInWithApple()
                }
            }
        }, label: { // UIKit things
            SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                .allowsHitTesting(false)// disallow clicking on it, but the wrapper button does it
        })
        .disabled(true) // MARK: I don't have an account for that
        .frame(width: 200, height: 45)
    }
     var googleSignInButton: some View {
         HStack{
             GoogleSignInButton(scheme: .dark ,style:.wide , state:.normal ){
                 Task {
                     do{
                         user.signInWithGoogle()
                     }
                 }
             }
             .frame(width: 200, height: 50)
         }
    }
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
                    SignupView(user: user, isPresented: $signUpViewIsPresented)
                })
                .buttonStyle(BorderlessButtonStyle())
                
            }
        }
        fileprivate var loginContent: some View {
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
                    
                        googleSignInButton
                            .clipped()
                        
                        appleSignInButton
                            .clipped()
                    
                    
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
            SpaceView()
        }
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(user: UserViewModel())
            .environmentObject(NetworkManagerViewModel())
    }
}
