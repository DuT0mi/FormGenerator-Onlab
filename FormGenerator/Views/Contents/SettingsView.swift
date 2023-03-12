//
//  SettingsView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 11..
//

import SwiftUI

struct SettingsView: View {
    @StateObject var user = UserViewModel()
    
    var body: some View {
        Form {
            Section {
                Text("Text")
                Text("Text")
                Text("Text")
                
            } header: {
                Text("Profile")
            }	
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("\(10.0)")
                }
            } header: {
                Text("About")
            }
            Section{
                Button {
                    user.logout()
                }label: {
                    HStack{
                        Spacer()
                        Label("Log Out", systemImage: "figure.walk.arrival")
                            .foregroundColor(.red)
                            .bold()
                        Spacer()
                    }
                }
            } header: {
                Text("log out".uppercased())
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
