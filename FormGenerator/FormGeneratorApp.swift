//
//  FormGeneratorApp.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 02. 28..
//

import SwiftUI
import FirebaseCore

@main
struct FormGeneratorApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            FormGeneratorView(user:UserViewModel())
        }
    }
}
