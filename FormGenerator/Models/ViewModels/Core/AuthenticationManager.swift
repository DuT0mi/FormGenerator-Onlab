import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift


actor AuthenticationManager{
    private func setIDToUserDefaults(ID: String){
        UserDefaults.standard.set(ID, forKey: UserConstants.currentUserID.rawValue)
    }
    
    func signInGoogle() async throws {
        let googleVM = GoogleSignViewModel()
        let tokens = try await googleVM.signIn()
        let authDataResult = try await signInWithGoogle(tokens: tokens)
        // with sso they get Company account
        let user = CompanyAccount(auth: authDataResult)
        try await AccountManager.shared.createNewCompanyAccount(user: user)
        setIDToUserDefaults(ID: authDataResult.uid)
    }
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthenticationDataResult{
        let (authDataResult) = try await Auth.auth().signIn(withEmail: email, password: password)
        // When signing in we store userID in UserDefaults
        setIDToUserDefaults(ID: authDataResult.user.uid)
        return AuthenticationDataResult(user: authDataResult.user)
    }
    
    @discardableResult
    func createUser(email:String, password: String) async throws -> AuthenticationDataResult {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        // Also creating the user (aka signing up) in we store userID in UserDefaults
        setIDToUserDefaults(ID: authDataResult.user.uid)
        return AuthenticationDataResult(user: authDataResult.user)
        
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.cannotFindHost)
        }
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.cannotFindHost)
        }
        try await user.updateEmail(to: email)
    }
    
    func getAuthenticatedUser() throws -> AuthenticationDataResult {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.cannotFindHost)
        }
        return AuthenticationDataResult(user: user)
    }
}
//MARK: - SSO
extension AuthenticationManager{
    
    @discardableResult
    private func signInWithGoogle(tokens: GoogleSigninResult) async throws -> AuthenticationDataResult {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken , accessToken: tokens.accessToken)
            return try await signIn(credential: credential)
    }
    private func signIn(credential: AuthCredential) async throws -> AuthenticationDataResult {
        let authDataResult = try await Auth.auth().signIn(with: credential)
            return AuthenticationDataResult(user: authDataResult.user)
    }
}
