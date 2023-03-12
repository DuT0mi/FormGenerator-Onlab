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
    @State private var type: Pages = .login
    @State private var signUpViewisPresented: Bool = false
    
    var loginContent: some View {
        VStack{
            Text("\(type.rawValue)".uppercased())
                .font(.title)
                .frame(idealHeight: 0.1 * ScreenDimensions.height)
            // Email text
            HStack{
                Label("",systemImage:  "person.circle.fill")
                    .scaledToFit()
                    .frame(width: 30.0, height: 30.0)
                    .opacity(0.5)
                TextField("Email", text: $user.email)
                    .textInputAutocapitalization(.never)
            }
            .padding(0.02 * ScreenDimensions.height)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
            .frame(width: ScreenDimensions.width * 0.8)
            
            // Password text
            HStack{
                Label("",systemImage: "lock.fill")
                    .scaledToFit()
                    .frame(width: 30.0, height: 30.0)
                    .opacity(0.5)
                SecureField("Password", text: $user.password)
            }
            .padding(0.02 * ScreenDimensions.height)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
            .frame(width: ScreenDimensions.width * 0.8)
            
            Spacer()
                .frame(idealHeight: 0.05 * ScreenDimensions.height)
                .fixedSize()
            // Login button
            Button(action: user.login){
                Text("\(type.rawValue)".uppercased())
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
            }
            .padding(0.025 * ScreenDimensions.height)
            .background(Capsule().fill(Color(.systemTeal)))
            .buttonStyle(BorderlessButtonStyle())
            
            Spacer()
                .frame(idealHeight: 0.05 * ScreenDimensions.height)
                .fixedSize()
            // Sign up
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(user: UserViewModel())
    }
}

