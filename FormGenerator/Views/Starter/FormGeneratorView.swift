//
//  ContentView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 02. 28..
//

import SwiftUI

struct FormGeneratorView: View {
    @StateObject var user: UserViewModel = UserViewModel()
    
    var homeView: some View {
        HomeView(user: user)
    }
    
    var body: some View {
        if !user.isSignedIn{
            TabView {
                IntroView()
                    .tabItem {
                        Label("Home",systemImage: "house.fill")
                    }
                LoginView(user: user)
                    .tabItem {
                        Label("Start", systemImage: "person.fill")
                    }
            }
        } else {
            homeView
        }
    }
   
}
struct FormGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        FormGeneratorView()
    }
}
    

