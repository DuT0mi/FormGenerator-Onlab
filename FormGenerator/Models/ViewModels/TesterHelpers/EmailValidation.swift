import Foundation

// MARK: Firebase email and password validation method:

// for email: / ^[^@]+@[^@]+\.[a-zA-Z]{2,}$ / -> 2 backslash coz of the dot
/// which means:
/// This pattern matches any string that starts with one or more characters that are not "@" followed by "@" and one or more characters that are not "@", followed by a dot and at least two characters from a-z or A-Z.

class EmailValidation {
    func validateEmail(email: String, completion: @escaping (Result<Void,Error>) -> Void ){
         let (_, emailCheckerErrorResult) = isValidEmail(email)
        if emailCheckerErrorResult != nil { /* There was an error */
            completion(.failure(emailCheckerErrorResult!))
            return
        } else {
            return completion(.success(()))
        }
    }
    private func isValidEmail(_ email: String) -> (Bool, ValidationContent.EmailValidationError?){
        if let regex = try? NSRegularExpression(pattern: ValidationContent.emailRegexPattern){
            let inputString: String = email
            let range = NSRange(inputString.startIndex..<inputString.endIndex,in: inputString)
            let matches = regex.matches(in: inputString, range: range)
            
            if matches.count > 0 { /* The input string was good*/
                return (true, nil)
            }
        } else {
            print(ValidationContent.EmailValidationError.invalidCharactersInEmail.rawValue)
            return (false,ValidationContent.EmailValidationError.invalidCharactersInEmail)
        }
        print(ValidationContent.EmailValidationError.invalidRegexPattern.rawValue)
        return (false,ValidationContent.EmailValidationError.invalidRegexPattern)
    }
}

