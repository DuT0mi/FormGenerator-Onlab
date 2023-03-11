//
//  TemplateView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 11..
//

import SwiftUI
import Firebase

struct TemplateView: View {
    @StateObject var user = UserViewModel()
    @State private var type: Pages
    
    init(type: Pages) {
        self.type = type
    }
    
    var body: some View {
        VStack{
            Text("\(type.rawValue)".uppercased())
                .font(.title)
            Spacer()
                .frame(idealHeight: 0.1 * ScreenDimensions.height)
            HStack{
                Label("",systemImage:  "person.circle.fill")
                    .scaledToFit()
                    .frame(width: 30.0, height: 30.0)
                    .opacity(0.5)
                TextField("Email", text: $user.email)
                    .textInputAutocapitalization(.never)
            }
            .padding(0.02 * ScreenDimensions.height)
            HStack{
                Label("",systemImage: "lock.fill")
                    .scaledToFit()
                    .frame(width: 30.0, height: 30.0)
                    .opacity(0.5)
                SecureField("Password", text: $user.password)
            }
            .padding(0.02 * ScreenDimensions.height)
            Spacer()
                .frame(idealHeight: 0.05 * ScreenDimensions.height)
                .fixedSize()
            Button {
                if type == .login {
                    user.login()
                    if user.alertMessage.isEmpty {
                        user.isSignedIn = true
                    }
                } else if type == .signup {
                    user.signUp()
                }
            } label: {
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
            if isLoginPage(){
                HStack{
                    Text("Don't have an account?")
                    Button(action: {
                        type = .signup
                    }) {
                        Text("sign up".uppercased())
                            .bold()
                    }
                       
                }
                .alert(isPresented: $user.alert, content: {
                    Alert(
                    title: Text("Message"),
                    message: Text(user.alertMessage),
                    dismissButton: .destructive(Text("OK"))
                    )
                })
            } else if isSignupPage(){
                HStack{
                    Text("Already have an account?")
                    Button(action: {
                        type = .login
                    }) {
                        Text("login".uppercased())
                            .bold()
                    }
                }
                .alert(isPresented: $user.alert, content:{
                    Alert(
                        title: Text("Message"),
                        message:Text(user.alertMessage) ,
                        dismissButton: .destructive(Text("OK"))
                    )
                })
            }
        }
        .ignoresSafeArea()
    }
    
    func isLoginPage() -> Bool {
        type == Pages.login
    }
    func isSignupPage() -> Bool {
        type == Pages.signup
    }
}

struct TemplateView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateView(type: Pages.signup)
    }
}
