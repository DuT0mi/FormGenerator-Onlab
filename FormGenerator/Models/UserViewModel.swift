//
//  UserViewModel.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 05..
//

import SwiftUI
import FirebaseAuth

class UserViewModel: ObservableObject {
    
    @Published var isSignedIn = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alert: Bool = false
    @Published var alertMessage: String = ""
    
    private func showAlertMessage(_ message: String){
        self.alertMessage = message
        alert.toggle()
    }
    
    func login(){
        // Check if all fields are inputted in the correct way
        if email.isEmpty || password.isEmpty {
            showAlertMessage("Error")
            return
        }
        // sign in with email and password
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if  error != nil {
                self.alertMessage = error!.localizedDescription
                self.alert.toggle()
            } else {
                self.isSignedIn = true
            }
        }
        
    }
    func signUp(){
        // Check if all fields are inputted in the correct way
        if email.isEmpty || password.isEmpty {
            showAlertMessage("Neither email nor password can be empty.")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password){result, error in
            if  error != nil {
                self.alertMessage = error!.localizedDescription
                self.alert.toggle()
            } else {
                self.login()
            }
        }
    }
    func logout(){
        do {
            try Auth.auth().signOut()
                isSignedIn = false
                email = ""
                password = ""
        } catch {
            print("Error signing out.")
        }
    }
 
}
