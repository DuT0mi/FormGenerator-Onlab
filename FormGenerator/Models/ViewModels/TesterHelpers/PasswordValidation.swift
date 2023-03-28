// MARK: Firebase email and password validation method:
// for password:
/// By default the password's length must be at least 6 character (can be also whitespace)

import Foundation

class PasswordValidation{
    
    func validatePassword(password: String, completion: @escaping (Result<Void,Error>) -> Void ){
            let (_,passwordCheckerErrorResult) = isPasswordValid(password)
        if passwordCheckerErrorResult != nil { /* There was an error */
            completion(.failure(passwordCheckerErrorResult!))
            return
        } else {
            return completion(.success(()))
        }
    }
    
    private func isPasswordValid(_ email: String) -> (Bool, ValidationContent.PasswordValidationError?){
        if let regex = try? NSRegularExpression(pattern: ValidationContent.passwordRegexPattern){
            let inputString: String = email
            let range = NSRange(inputString.startIndex..<inputString.endIndex, in: inputString)
            let matches = regex.matches(in: inputString, range: range)
            
            if matches.count > 0 { /* The input string was good */
                return (true,nil)
            } else {
                print(ValidationContent.PasswordValidationError.invalidPassword.rawValue)
                return (false, ValidationContent.PasswordValidationError.invalidPassword)
            }
        }
        print(ValidationContent.PasswordValidationError.invalidPasswordRegex.rawValue)
        return (false,ValidationContent.PasswordValidationError.invalidPasswordRegex)
    }
}
