//
//  UserViewModel.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 05..
//
import SwiftUI
import FirebaseAuth

final class UserViewModel: ObservableObject {
    // Variables used for authentication
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var alert: Bool = false
    // Variables used for interact with the User
        @Published var alertMessage: String = ""
        @Published var isSignedIn = false
        @Published var loading: Bool = false
    
    init(autoLogin:Bool = true){
        if autoLogin {
            let user = Auth.auth().currentUser
            if let _ = user {
                self.isSignedIn = true
            } else {}
        }
    }
    
    private func showAlertMessage(_ message: String){
        self.alertMessage = message
        alert.toggle()
    }
    func login(){
        loading.toggle()
        // Check if all fields are inputted in the correct way
        if email.isEmpty || password.isEmpty {
            showAlertMessage("Neither email nor password can be empty.")
            loading.toggle()
            return
        }
        // sign in with email and password
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if  error != nil {
                self.alertMessage = error!.localizedDescription
                self.alert.toggle()
                self.loading.toggle()
            } else {
                self.isSignedIn = true
                self.loading.toggle()
            }
        }
        
    }
    func signUp(){
        self.loading.toggle()
        // Check if all fields are inputted in the correct way
        if email.isEmpty || password.isEmpty {
            showAlertMessage("Neither email nor password can be empty.")
            self.loading.toggle()
            return
        }
        Auth.auth().createUser(withEmail: email, password: password){result, error in
            if  error != nil {
                self.alertMessage = error!.localizedDescription
                self.alert.toggle()
                self.loading.toggle()
            } else {
                self.login()
                self.loading.toggle()
            }
        }
    }
    func logout(){
        self.loading.toggle()
        do {
            try Auth.auth().signOut()
                isSignedIn = false
                email = ""
                password = ""
                self.loading.toggle()
        } catch {
            print("Error signing out, error: \(error)")
        }
    }
    
}
