//
//  ContentView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 02. 28..
//

import SwiftUI

struct FormGeneratorView: View {
 
    var body: some View {
        TabView {
            IntroView()
                .tabItem {
                    Label("Home",systemImage: "house.fill")
                }
            AuthHomeView()
                .tabItem {
                    Label("Start", systemImage: "person.fill")
                }
        }
    }
   
}
struct FormGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
            FormGeneratorView()
    }
}
    
