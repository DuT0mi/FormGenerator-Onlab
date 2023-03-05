//
//  ContentView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 02. 28..
//

import SwiftUI
import Firebase

struct FormGeneratorView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
       content
    }
    var content: some View {
        ZStack{
            Color.green.opacity(0.6)
            RoundedRectangle(cornerRadius: 30,style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.blue,.gray], startPoint: .topLeading, endPoint: .bottomLeading))
                .frame(width: 1000,height: 400)
                .rotationEffect(.degrees(135))
            RoundedRectangle(cornerRadius: 30,style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.blue,.gray], startPoint: .topLeading, endPoint: .bottomLeading))
                .frame(width: 1000,height: 400)
                .rotationEffect(.degrees(-135))
            VStack(spacing:20){
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 40,weight: .bold,design: .serif))
                TextField("Email",text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty){
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password",text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty, placeholder: {
                        Text("Password").foregroundColor(.white)
                            .bold()
                    })
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
            }
            .frame(width: 350)
        }
        .ignoresSafeArea()
    }
}
struct FormGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
            FormGeneratorView()
    }
}
    
