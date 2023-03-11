//
//  TemplateView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 11..
//

import SwiftUI

struct TemplateView: View {
    private var type: Pages
    
    init(type: Pages) {
        self.type = type
    }
    var body: some View {
        if isLoginPage(){
            Text("Login")
        } else if isSignupPage() {
            Text("Signup")
        } else {
            Text("ELSE")
        }
    }
    
    func isLoginPage() -> Bool {
        type == Pages.login
    }
    func isSignupPage() -> Bool {
        type == Pages.signup
    }
}

struct TemplateView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateView(type: Pages.login)
    }
}
