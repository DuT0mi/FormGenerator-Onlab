import Foundation
import SwiftUI


// User constants
enum UserConstants: String {
    case currentUserID = "currentUserID"
}

// Separating the different pages (login/signup)
enum Pages: String, CaseIterable, Equatable {
    case login = "login"
    case signup = "signup"
}
// Constants for device's sizes
class ScreenDimensions {
    #if os(iOS) || os(tvOS)
        static var width: CGFloat = UIScreen.main.bounds.size.width
        static var height: CGFloat = UIScreen.main.bounds.size.height
    #elseif os(macOS)
        static var width: CGFloat = NSScreen.main?.visibleFrame.size.width ?? 0
        static var height: CGFloat = NSScreen.main?.visibleFrame.size.height ?? 0
    #endif
}

class ValidationContent{
    
    enum EmailValidationError: String,Error {
        case invalidEmail = "The given email is invalid"
        case invalidRegexPattern = "Invalid regex pattern"
        case invalidCharactersInEmail = "Input email contains invalid characters."
    }
    enum PasswordValidationError: String, Error {
        case invalidPassword = "Password should containt at least 6 characters!"
        case invalidPasswordRegex = "Invalid password regex!"
    }
    
    static let emailRegexPattern = "^[^@]+@[^@]+\\.[a-zA-Z]{2,}$"
    static let expectationTimeInterval: TimeInterval = 5.0
    static let passwordRegexPattern = "^.{6,}$"
}

// Constants about the App
struct AppConstants {
    static let appVersionNumber: Double = 1.0
}

// Constants for the error screen (space view)
struct AnimatedSpaceScreen{
    static let numberOfStars: Int = 350
}

// Constants strings for UI texts
struct UITextConstants{
    struct NetworkStateTexts{
        static let retryConnectionText: String = "Trying to reconnect..."
    }
    struct TextAnimationIndicator{
        static let size: CGFloat = 50
        static let speed: Double = 0.5
        static let speedDividerFactor: Double = 4.0
        static let foregroundColor: Color = .orange
        static let fontFactor: Double = 3.0
        static let offsetFactor: Double = 8.0
    }
}

// Constants for the Views that are participiate in authentication method
struct AuthenticationViewsConstants {
    static let titleFrameHeightFactor: CGFloat = 0.1
    
    static let textFieldFrameWidthFactor: CGFloat = 30.0
    static let textFieldFrameHeightFactor: CGFloat = 30.0
    static let textFieldOpacityFactor: CGFloat = 0.5
    
    static let buttonPaddingFactor: CGFloat = 0.025
    
    struct StackParameters{
        static let paddingFactor: CGFloat = 0.02
        static let rectangleRadiusFactor: CGFloat = 10.0
        static let frameWidthForDimensionsFactor: CGFloat = 0.8
    }
    struct SpacerParameters{
        static let frameIdealHeightFactor: CGFloat = 0.05
    }
}

// Constant for the View that is popping up when succed a login or signup
struct PopUpMessageTimer{
    static let onScreenTime: Double = 1.0
}
