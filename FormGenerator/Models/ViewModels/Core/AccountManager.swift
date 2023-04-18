import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

actor AccountManager{
    
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
    
    func getUserByJustID(userID: String) async throws -> (Account?, Bool) {
        if let user = try? await getStandardAccount(userID: userID){
            return (user, true)
        } else if let user = try? await getCompanyAccount(userID: userID){
            return (user, true)
        }
        return (nil,false)
    }
    func deleteAccountByID(userID: String) async throws {
        if let _ = try? await getStandardAccount(userID: userID){
            try? await standardDocument(userID: userID).delete()
        } else if let _ = try? await getCompanyAccount(userID: userID){
            try? await companyDocument(userID: userID).delete()
        }
    }
}
