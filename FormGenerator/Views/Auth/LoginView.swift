//
//  LoginView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 05..
//

import SwiftUI

struct LoginView: View {
    @State private var selectedPage: Pages = .login
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ChoosePageView(selectedPage: selectedPage)
                Spacer()
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
