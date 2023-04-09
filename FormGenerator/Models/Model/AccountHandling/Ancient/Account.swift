import Foundation


protocol Account {
    var userID: String { get set}        // Allowed Read-Write
    var email: String?  { get set }       // Allowed Read-Write
    var dateCreated: Date? { get set }   // Allowed Read-Write
    var type: AccountType { get set }    // Allowed Read-Write
}
