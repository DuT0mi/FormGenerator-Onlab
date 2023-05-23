import Foundation
import CoreData

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published private(set) var account: Account?
    @Published var authProviders: [AuthProviderOtpion] = []
    @Published var authUser: AuthenticationDataResult?
    
    private let authManager: AuthenticationManager = AuthenticationManager()
    
    func loadCurrentAccount() async throws {
        
        let authDataResult = try authManager.getAuthenticatedUser()
        let(account,_) = try await AccountManager.shared.getUserByJustID(userID: authDataResult.uid)
        self.account = account
    }
    func loadAuthenticationProviders(){
        if let providers = try?  authManager.getProviders(){
            self.authProviders = providers
        }
    }
    func deleteUser(context: NSManagedObjectContext) async throws {
        try await authManager.deleteUser(context: context)
    }
    func updatePassword(password: String) async throws {
        try await authManager.updatePassword(password: password)
    }
    func updateEmail(email: String) async throws {
        try await authManager.updateEmail(email: email)
    }
    
    func resetPassword(email: String) async throws {
            let authUser = try authManager.getAuthenticatedUser()
            guard let email = authUser.email else {
                throw AppErrors.AccountError.emailAddressNotExist
            }
            
            try await authManager.resetPassword(email: email )
        }
    func togglePremiumStatus(newValue: Bool){
        guard let account else { return }
        Task {
            // Update
            try await AccountManager.shared.updateAccountPremiumStatus(userID: account.userID, isPremium: newValue)
            // Refetch the current user
            self.account = try await AccountManager.shared.getCompanyAccount(userID: account.userID)            
        }
    }
}
