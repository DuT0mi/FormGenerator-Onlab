import Foundation
import FirebaseAuth

actor AuthenticationManager{
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    private func setIDToUserDefaults(ID: String){
        UserDefaults.standard.set(ID, forKey: UserConstants.currentUserID.rawValue)
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
