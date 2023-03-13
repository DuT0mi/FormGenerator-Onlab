//
//  SignupView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 12..
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var user: UserViewModel
    @State private var type: Pages = .signup
    @Binding var isPresented: Bool
    
    typealias AVC = AuthenticationViewsConstants
    
    var signUpAction: some View {
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
    var loginContent: some View {
        VStack{
            let templateView = TemplateAuthView(user: user, type: type)
                    templateView.getTitle()
                    templateView.getEmailTextInput()
                    templateView.getPasswordTextInput()
            Spacer()
                .frame(idealHeight: AVC.SpacerParameters.frameIdealHeightFactor * ScreenDimensions.height)
                .fixedSize()
            
            templateView.getLoginButton()
            
            Spacer()
                .frame(idealHeight: AVC.SpacerParameters.frameIdealHeightFactor * ScreenDimensions.height)
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
        .ignoresSafeArea()
    }
    
    var body: some View {
        loginContent
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(user: UserViewModel(), isPresented: .constant(false))
    }
}
