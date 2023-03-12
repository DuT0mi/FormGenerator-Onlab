//
//  HomeView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 11..
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        let isSignedIn = UserDefaults.standard.bool(forKey: "signedIn")
        if isSignedIn{
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
