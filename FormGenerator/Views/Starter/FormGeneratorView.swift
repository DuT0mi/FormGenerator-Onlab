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
                        Text("a")
                    }
                }
             /*   .overlay {
                    if shouldShowSuccessView {
                        SuccessPopUpView(startAngle: Angle(degrees: 120), endAngle: Angle(degrees: -10), clockwise: true)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                                    withAnimation(.spring()){
                                        shouldShowSuccessView.toggle()
                                    }
                                }
                            }
                    }
                } */
            
        }
    }
   
}
struct FormGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        FormGeneratorView()
    }
}
    

