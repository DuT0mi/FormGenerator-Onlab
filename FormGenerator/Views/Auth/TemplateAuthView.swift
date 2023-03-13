//
//  TemplateAuthView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 12..
//

import SwiftUI

struct TemplateAuthView: View {
    
    @ObservedObject var user: UserViewModel
    @State var type: Pages?
    
    typealias AVC = AuthenticationViewsConstants
    
    private var title: some View {
        Text("\(type!.rawValue)".uppercased())
            .font(.title)
            .frame(idealHeight: AVC.titleFrameHeightFactor * ScreenDimensions.height)
            .bold()
    }
    private var emailTextInput: some View {
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
    private var passwordTextInput: some View {
        HStack{
            Label("",systemImage: "lock.fill")
                .scaledToFit()
                .frame(width: AVC.textFieldFrameWidthFactor, height: AVC.textFieldFrameHeightFactor)
                .opacity(AVC.textFieldOpacityFactor)
          //  SecureField("Password", text: $user.password)
            SecureTextField(secureText: $user.password)
        }
        .padding(AVC.StackParameters.paddingFactor * ScreenDimensions.height)
        .background(RoundedRectangle(cornerRadius: AVC.StackParameters.rectangleRadiusFactor).fill(Color(.systemGray5)))
        .frame(width: ScreenDimensions.width * AVC.StackParameters.frameWidthForDimensionsFactor)
    }
    private var loginButton: some View {
        Button {
            type == .login ? user.login() : user.signUp() // There are not any other option
        } label: {
            Text("\(type!.rawValue )".uppercased())
                .foregroundColor(.white)
                .font(.title2)
                .bold()
        }
        .padding(AVC.buttonPaddingFactor * ScreenDimensions.height)
        .background(Capsule().fill(Color(.systemTeal)))
        .buttonStyle(BorderlessButtonStyle())
    }
    
    var body: some View {
        EmptyView()
    }
    
    func getTitle() -> some View {
        title
    }
    func getEmailTextInput() -> some View {
        emailTextInput
    }
    func getPasswordTextInput() -> some View {
        passwordTextInput
    }
    func getLoginButton() -> some View {
        loginButton
    }
    
    

}

struct TemplateAuthView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateAuthView(user: UserViewModel())
    }
}
