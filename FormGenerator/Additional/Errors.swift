import Foundation

class AppErrors{
    
    enum AuthenticationError: String, Error{
        case invalidProvider = "Invalid provider during the authentication flow!"
        case userIsNotAuthenticated = "The User have to sing in for change their account!"
    }
    enum AccountChanges: String, Error {
        case emailAddressNotExist = "The User's email address is not available!"
    }
    enum Storage: String, Error {
        case jpegCompressionFailed
        case imageDoesNotExist
    }
}
