//
//  HomeView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 11..
//

import SwiftUI

struct HomeView: View {
    @StateObject var user = UserViewModel()
    // TODO: make it false
    
    var body: some View {
        if user.isSignedIn{
            TabView{
                FormsListView()
                    .tabItem {
                        Label("All", systemImage: "list.bullet.rectangle.fill")
                    }
                RecentsFormsView()
                    .tabItem {
                        Label("Recents", systemImage: "gobackward")
                    }
                SettingsView()
                    .tabItem {
                        Label("Profile",systemImage:"person.crop.circle.fill")
                    }
            }
        } else {
            FormGeneratorView()
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
