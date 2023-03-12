//
//  SignupView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 12..
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var user: UserViewModel
    @Binding var isPresented: Bool
    @State private var type: Pages = .signup
    
    var body: some View {
        VStack{
            Text("\(type.rawValue)".uppercased())
                .font(.title)
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
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
            .frame(width: ScreenDimensions.width * 0.8)
            
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
            
            Button {
                user.signUp()
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
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(user: UserViewModel(), isPresented: .constant(false))
    }
}
