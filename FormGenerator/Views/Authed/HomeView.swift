//
//  HomeView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 11..
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var user: UserViewModel

    @State private var selection: Tab = .all
    var body: some View {
            TabView(selection: $selection){
                FormsListView()
                    .tabItem {
                        Label("All", systemImage: "tray")
                    }
                    .tag(Tab.all)
                RecentsFormsView()
                    .tabItem {
                        Label("Recents", systemImage: "clock")
                    }
                    .tag(Tab.recent)
                SettingsView(user: user)
                    .tabItem {
                        Label("Profile",systemImage:"person.crop.circle.fill")
                    }
                    .tag(Tab.profile)
            }
    }
    private enum Tab{
        case all
        case recent
        case profile
    }
    }
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: UserViewModel())
    }
}
