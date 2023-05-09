import SwiftUI
import FirebaseAuth

@MainActor
final class UserViewModel: ObservableObject {
    // Variables and objects used for authentication
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var alert: Bool = false

        fileprivate var authenticationManager: AuthenticationManager = AuthenticationManager()
    
    // Variables used for interact with the User
        @Published var alertMessage: String = ""
        @Published var isSignedIn = false
        @Published var loading: Bool = false
        @Published var selectedAccountType: AccountType = .Standard
        @Published var isAutoLoginLoading: Bool = false
    
    init(autoLogin:Bool = true){ /* Autologin method */
        if autoLogin {
            self.isAutoLoginLoading = true
            let user = Auth.auth().currentUser
            if let user = user {
                Task{
                    let (_,exist) = try await AccountManager.shared.getUserByJustID(userID: user.uid)
                    if exist{
                        self.isAutoLoginLoading.toggle()
                        self.isSignedIn = true
                    } else {
                        self.isAutoLoginLoading.toggle()
                    }
                }
            } else {self.isAutoLoginLoading.toggle()}
        }
    }
    private func showAlertMessage(_ message: String){
        self.alertMessage = message
        alert.toggle()
    }
    
    func logIn() async throws {
        loading.toggle()
        guard !email.isEmpty || !password.isEmpty else{
            showAlertMessage("Neither email nor password can be empty.")
            loading.toggle()
            return
        }
        do{
            try await authenticationManager.signInUser(email: email, password: password)
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
        guard !email.isEmpty || !password.isEmpty else{
            showAlertMessage("Neither email nor password can be empty.")
            self.loading.toggle()
            return
        }
        do{
            let authDataResult = try await authenticationManager.createUser(email: email, password: password)
            self.loading.toggle()
            self.isSignedIn = true
            switch selectedAccountType {
                case .Standard:
                    let standardAccount = StandardAccount(auth: authDataResult)
                    try await AccountManager.shared.createNewStandardAccount(user: standardAccount)
                case .Company:
                    let companyAccount = CompanyAccount(auth: authDataResult)
                    try await AccountManager.shared.createNewCompanyAccount(user: companyAccount)
            }
        } catch {
            self.alertMessage = error.localizedDescription
            self.alert.toggle()
            self.loading.toggle()
        }

    }
    func logout() throws{
        self.loading.toggle()
        Task{
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
    func signInWithGoogle(){
        self.loading.toggle()
        Task{
            do{
                try await authenticationManager.signInGoogle()
                self.loading.toggle()
                self.isSignedIn = true
            } catch {
                self.alertMessage = error.localizedDescription
                self.alert.toggle()
                self.loading.toggle()
            }
        }
    }
    func signInWithApple(){
        self.loading.toggle()
        Task{
            do{
                try await authenticationManager.signInGoogle()
                self.loading.toggle()
                self.isSignedIn = true
            } catch {
                self.alertMessage = error.localizedDescription
                self.alert.toggle()
                self.loading.toggle()
            }
        }
    }
}
