//
//  HomeView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 11..
//

import SwiftUI

struct IntroView: View {
    @ObservedObject var networkManager: NetworkManager
    
    var body: some View {
            Label("Home",systemImage: "house.fill")
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(networkManager: NetworkManager())
    }
}
