import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class AccountManager{
    
    // MARK: Singleton pattern
    static let shared = AccountManager()
    private init() {  }
    
    private let standardAccountCollection = Firestore.firestore().collection("standard_users")
    private let companyAccountCollection = Firestore.firestore().collection("company_users")
    
    private func standardDocument(userID: String) -> DocumentReference {
        standardAccountCollection.document(userID)
    }
    private func companyDocument(userID: String) -> DocumentReference {
        companyAccountCollection.document(userID)
    }
    
    func createNewStandardAccount(user: StandardAccount) async throws {
        try standardDocument(userID: user.userID).setData(from: user, merge: false)
    }
    func getStandardAccount(userID: String) async throws -> StandardAccount{
        try await standardDocument(userID: userID).getDocument(as:StandardAccount.self)
    }
    
    func createNewCompanyAccount(user: CompanyAccount) async throws {
        try companyDocument(userID: user.userID).setData(from: user, merge: false)
    }
    func getCompanyAccount(userID: String) async throws -> CompanyAccount {
        try await companyDocument(userID: userID).getDocument(as:CompanyAccount.self)
    }
}
