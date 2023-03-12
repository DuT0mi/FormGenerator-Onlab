//
//  HomeView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 11..
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var user: UserViewModel
    var body: some View {
            TabView{
                FormsListView()
                    .tabItem {
                        Label("All", systemImage: "list.bullet.rectangle.fill")
                    }
                RecentsFormsView()
                    .tabItem {
                        Label("Recents", systemImage: "gobackward")
                    }
                SettingsView(user: user)
                    .tabItem {
                        Label("Profile",systemImage:"person.crop.circle.fill")
                    }
            }
        }
    }
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: UserViewModel())
    }
}
