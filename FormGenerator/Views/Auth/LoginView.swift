//
//  LoginView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 12..
//

import SwiftUI
import Firebase

struct LoginView: View {
    @ObservedObject var user: UserViewModel
    @State private(set) var type: Pages = .login
    @State private var signUpViewisPresented: Bool = false
    
    typealias AVC = AuthenticationViewsConstants
    
    
        var signUpAction: some View {
            HStack{
                Text("Don't have an account?")
                Button(action: {
                    signUpViewisPresented = true
                }) {
                    Text("sign up".uppercased())
                        .bold()
                }
                .sheet(isPresented: $signUpViewisPresented, content: {
                    SignupView(user: user, isPresented: $signUpViewisPresented)
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
                
                    templateView.getLoginButton()
                
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
            loginContent
        }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(user: UserViewModel())
    }
}
