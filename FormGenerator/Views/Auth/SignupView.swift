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
    
    var title: some View {
        Text("\(type.rawValue)".uppercased())
            .font(.title)
            .frame(idealHeight: AVC.titleFrameHeightFactor * ScreenDimensions.height)
            .bold()
    }
    var emailTextInput: some View {
        HStack{
            Label("",systemImage:  "person.circle.fill")
                .scaledToFit()
                .frame(width: AVC.textFieldFrameWidthFactor, height: AVC.textFieldFrameHeightFactor)
                .opacity(AVC.textFieldOpacityFactor)
            TextField("Email", text: $user.email)
                .textInputAutocapitalization(.never)
        }
        .padding(AVC.StackParameters.paddingFactor * ScreenDimensions.height)
        .background(RoundedRectangle(cornerRadius: AVC.StackParameters.rectangleRadiusFactor).fill(Color(.systemGray5)))
        .frame(width: ScreenDimensions.width * AVC.StackParameters.frameWidthForDimensionsFactor)
    }
    var passwordTextInput: some View {
        HStack{
            Label("",systemImage: "lock.fill")
                .scaledToFit()
                .frame(width: AVC.textFieldFrameWidthFactor, height: AVC.textFieldFrameHeightFactor)
                .opacity(AVC.textFieldOpacityFactor)
            SecureField("Password", text: $user.password)
        }
        .padding(0.02 * ScreenDimensions.height)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
        .frame(width: ScreenDimensions.width * AVC.StackParameters.frameWidthForDimensionsFactor)
    }
    var loginButton: some View {
        Button {
            user.signUp()
        } label: {
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
                title
                emailTextInput
                passwordTextInput
            Spacer()
                .frame(idealHeight: AVC.SpacerParameters.frameIdealHeightFactor * ScreenDimensions.height)
                .fixedSize()
            
                loginButton
            
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
