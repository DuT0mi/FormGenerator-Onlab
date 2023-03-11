//
//  ChoosePageView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 11..
//

import SwiftUI

struct ChoosePageView: View {
    var selectedPage: Pages
    
    init(selectedPage: Pages) {
        self.selectedPage = selectedPage
    }
    
    
    var body: some View {
        switch selectedPage {
        case Pages.login:
           return TemplateView(type: Pages.login)
        case Pages.signup:
           return TemplateView(type: Pages.signup)
        }
    }
}

struct ChoosePageView_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePageView(selectedPage: Pages.login)
    }
}
