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
    
        var title: some View {
            Text("\(type.rawValue)".uppercased())
                .font(.title)
                .frame(idealHeight:AVC.titleFrameHeightFactor * ScreenDimensions.height)
                .bold()
        }
        var emailTextInput: some View {
            HStack{
                Label("",systemImage:  "person.circle.fill")
                    .scaledToFit()
                    .frame(width:AVC.textFieldFrameWidthFactor, height:AVC.textFieldFrameHeightFactor)
                    .opacity(AVC.textFieldOpacityFactor)
                TextField("Email", text: $user.email)
                    .textInputAutocapitalization(.never)
            }
            .padding(AVC.StackParameters.paddingFactor * ScreenDimensions.height)
            .background(RoundedRectangle(cornerRadius:AVC.StackParameters.rectangleRadiusFactor).fill(Color(.systemGray5)))
            .frame(width: ScreenDimensions.width * AVC.StackParameters.frameWidthForDimensionsFactor)
        }
        var passwordTextInput: some View {
            HStack{
                Label("",systemImage: "lock.fill")
                    .scaledToFit()
                    .frame(width:AVC.textFieldFrameWidthFactor, height:AVC.textFieldFrameHeightFactor)
                    .opacity(AVC.textFieldOpacityFactor)
                SecureField("Password", text: $user.password)
            }
            .padding(AVC.StackParameters.paddingFactor * ScreenDimensions.height)
            .background(RoundedRectangle(cornerRadius:AVC.StackParameters.rectangleRadiusFactor).fill(Color(.systemGray5)))
            .frame(width: ScreenDimensions.width * AVC.StackParameters.frameWidthForDimensionsFactor)
        }
        var loginButton: some View {
            Button(action: user.login){
                Text("\(type.rawValue)".uppercased())
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
            }
            .padding(AVC.buttonPaddingFactor * ScreenDimensions.height)
            .background(Capsule().fill(Color(.systemTeal)))
            .buttonStyle(BorderlessButtonStyle())
        }
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
                title
                emailTextInput
                passwordTextInput
                Spacer()
                    .frame(idealHeight:AVC.SpacerParameters.frameIdealHeightFactor * ScreenDimensions.height)
                    .fixedSize()
                loginButton
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
