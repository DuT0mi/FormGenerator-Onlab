import SwiftUI
import FirebaseAuth

@MainActor
final class UserViewModel: ObservableObject {
    // Variables and objects used for authentication
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var alert: Bool = false
        // object
        fileprivate var authenticationManager: AuthenticationManager = AuthenticationManager()
    
    // Variables used for interact with the User
        @Published var alertMessage: String = ""
        @Published var isSignedIn = false
        @Published var loading: Bool = false
    
    init(autoLogin:Bool = true){ /* Autologin method */
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
    
    func logIn() async throws {
        loading.toggle()
        // Check if all fields are inputted in the correct way
        guard !email.isEmpty || !password.isEmpty else{
            showAlertMessage("Neither email nor password can be empty.")
            loading.toggle()
            return
        }
        // sign in with email and password
        do{
            try await authenticationManager.signInUser(email: email, password: password)
            // If it did not throw
            self.loading.toggle()
            self.isSignedIn = true
        } catch {
            self.alertMessage = error.localizedDescription
            self.alert.toggle()
            self.loading.toggle()
        }
        
    }
    func signUp() async throws {
        self.loading.toggle()
        // Check if all fields are inputted in the correct way
        guard !email.isEmpty || !password.isEmpty else{
            showAlertMessage("Neither email nor password can be empty.")
            self.loading.toggle()
            return
        }
        do{
            try await authenticationManager.createUser(email: email, password: password)
            // If it did not throw
            self.loading.toggle()
            self.isSignedIn = true
        } catch {
            self.alertMessage = error.localizedDescription
            self.alert.toggle()
            self.loading.toggle()
        }

    }
    func logout() throws{
        self.loading.toggle()
        do {
            try authenticationManager.signOut()
                isSignedIn = false
                email = ""
                password = ""
                self.loading.toggle()
        } catch {
            print("Error signing out, error: \(error)")
        }
    }
}
