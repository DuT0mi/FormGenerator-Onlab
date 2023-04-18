import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSigninResult{
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

final class GoogleSignViewModel{
    
    @MainActor
    func signIn() async throws -> GoogleSigninResult {
        // Get a UIViewController (top most)
        guard let topViewController = topViewController() else {
            throw URLError(.appTransportSecurityRequiresSecureConnection)
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topViewController)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.appTransportSecurityRequiresSecureConnection)
        }
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        let email = gidSignInResult.user.profile?.email
        let name = gidSignInResult.user.profile?.name
        
        let tokens = GoogleSigninResult(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
    
}
