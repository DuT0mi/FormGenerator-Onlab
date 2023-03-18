//
//  ContentView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 02. 28..
//

import SwiftUI

struct FormGeneratorView: View {
    @StateObject var user: UserViewModel = UserViewModel()
    @State private var shouldShowSuccessView: Bool = true
    
    /// Which contexts are involved in the popup message only works when the app is started. (Quit the app and then start it again)
    private func getPopUpContent<TimeType>(content: some View, extratime: TimeType ) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(truncating: (extratime) as! NSNumber)){
                    withAnimation{
                       shouldShowSuccessView.toggle()
                    }
                }
            }
    }
    fileprivate var popUpContent: some View {
        get {
            Text("a") // TODO: Animated pop up
        }
    }
    
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
                .overlay{
                    if shouldShowSuccessView {
                        getPopUpContent(content: popUpContent, extratime: PopUpMessageTimer.onScreenTime)
                    }
                }
            
        }
    }
   
}
struct FormGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        FormGeneratorView()
    }
}
    

