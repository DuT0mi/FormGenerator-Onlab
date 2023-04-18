import Foundation
import AuthenticationServices // Sign in with Apple
import UIKit
import CryptoKit
import SwiftUI

// Local model
struct SignInWithAppleResult {
    let token: String
    let nonce: String
    let name: String?
    let email: String?
}

// UIKit button
// UIViewRepresentable to convert UIKit btn to SwiftUI btn
struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    let type:ASAuthorizationAppleIDButton.ButtonType
    let style:ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
         ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

@MainActor
final class AppleSignInViewModel: NSObject{
    // Unhashed nonce.
    private var currentNonce: String?
    private var completionHandler: ((Result<SignInWithAppleResult,Error>) -> Void)?// Nil the the class starts
    
    // MARK: Important
    // .. is for making a a completion handler to concurrency
    // With continuation you can always continue just one time, or your app will crashes
    func startSignInWithAppleFlow() async throws -> SignInWithAppleResult {
       try await withCheckedThrowingContinuation { continuation in
            self.startSignInWithAppleFlow {result in
                switch result {
                    case .success(let signInAppleResult):
                        continuation.resume(returning: signInAppleResult)
                        return
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        return
                }
            }
        }
    }
    @available(iOS 13, *)
    func startSignInWithAppleFlow(completion: @escaping (Result<SignInWithAppleResult, Error>) -> Void ) {
        guard let topViewController = topViewController()  else {
            completion(.failure(URLError(.badURL))) // Could be custom
            return
        }
        
        
      let nonce = randomNonceString()
      currentNonce = nonce
      completionHandler = completion
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = topViewController
      authorizationController.performRequests()
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}


@available(iOS 13.0, *)
extension AppleSignInViewModel: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        completionHandler?(.failure(URLError(.badURL)))
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        completionHandler?(.failure(URLError(.badURL)))
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        completionHandler?(.failure(URLError(.badURL)))
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
        _ = appleIDCredential.fullName?.givenName
        //.... MARK: for email and any other thing which are available through that credintal
        let tokens = SignInWithAppleResult(token: idTokenString, nonce: nonce, name:"" , email:"")
        completionHandler?(.success(tokens))


    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
    completionHandler?(.failure(URLError(.badURL)))
  }

}
extension UIViewController:ASAuthorizationControllerPresentationContextProviding {
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return  self.view.window!
    }
}


