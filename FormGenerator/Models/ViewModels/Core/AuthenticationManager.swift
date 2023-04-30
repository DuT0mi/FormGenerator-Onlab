import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

enum AuthProviderOtpion: String { // String for rawValue
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}


@MainActor
final class AuthenticationManager{
    @Environment (\.managedObjectContext) private var managedObjectContext
    fileprivate let signInAppleHelper = AppleSignInViewModel()
    
    private func setIDToUserDefaults(ID: String){
        UserDefaults.standard.set(ID, forKey: UserConstants.currentUserID.rawValue)
    }
    //MARK: We got google.com if sign in with google and if with random email, password
    func getProviders() throws -> [AuthProviderOtpion]{
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw AppErrors.AuthenticationError.invalidProvider
        }
        var providers: [AuthProviderOtpion] = []
        for provider in providerData {
            if let option = AuthProviderOtpion(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)") // there are not any other option
                // MARK: fatalError() is crash the user app, that is not crashes the production
            }
        }
        return providers
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
    func signInApple()async throws {
        let helper = AppleSignInViewModel() // MARK: It is must to be here because of concurrency, not the shared one upper
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult =  try await signInWithApple(tokens: tokens)
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
            throw AppErrors.AuthenticationError.userIsNotAuthenticated
        }
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AppErrors.AuthenticationError.userIsNotAuthenticated
        }
        try await user.updateEmail(to: email)
        // Also update the database
        try await AccountManager.shared.updateEmailAddress(userID: user.uid, email: email)
    }
    
    func getAuthenticatedUser() throws -> AuthenticationDataResult {
        guard let user = Auth.auth().currentUser else {
            throw AppErrors.AuthenticationError.userIsNotAuthenticated
        }
        return AuthenticationDataResult(user: user)
    }
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AppErrors.AuthenticationError.userIsNotAuthenticated
        }
        // Reset the coredata
        CoreDataController().resetCoreData(context: managedObjectContext)
        // Just from the authentication
        try await user.delete()
        // From the DB
        try await AccountManager.shared.deleteAccountByID(userID: user.uid)
    }

}
//MARK: - SSO
extension AuthenticationManager{
    
    @discardableResult
    private func signInWithGoogle(tokens: GoogleSigninResult) async throws -> AuthenticationDataResult {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken , accessToken: tokens.accessToken)
            return try await signIn(credential: credential)
    }
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthenticationDataResult {
        let credential = OAuthProvider.credential(withProviderID: AuthProviderOtpion.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce)
        return try await signIn(credential: credential)
    }
    private func signIn(credential: AuthCredential) async throws -> AuthenticationDataResult {
        let authDataResult = try await Auth.auth().signIn(with: credential)
            return AuthenticationDataResult(user: authDataResult.user)
    }
}
