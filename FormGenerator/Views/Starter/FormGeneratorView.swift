//
//  ContentView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 02. 28..
//

import SwiftUI

struct FormGeneratorView: View {
    @StateObject var user: UserViewModel = UserViewModel()
    @StateObject var networkManager: NetworkManager = NetworkManager()
    @State private var shouldShowSuccessView: Bool = true
    @State private var isConnected:Bool = false
    @State private var spaceViewIsPresented: Bool = false
    
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
    var tabView: some View {
        TabView {
            IntroView(networkManager: networkManager)
                .tabItem {
                    Label("Home",systemImage: "house.fill")
                }
            LoginView(user: user)
                .tabItem {
                    Label("Start", systemImage: "person.fill")
                }
            
        }
    }
    
    var body: some View {
        ZStack{
            if isConnected{
                if !user.isSignedIn{
                    tabView
                } else {
                    homeView
                        .overlay{
                            if shouldShowSuccessView {
                                getPopUpContent(content: popUpContent, extratime: PopUpMessageTimer.onScreenTime)
                            }
                        }
                    
                }
            } else {
                SpaceView(networkManager: networkManager)
            }
        }
        .task {
            do{
                let response = await networkManager.isInternetAvailable()
                if response {
                    self.isConnected.toggle()
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
    

