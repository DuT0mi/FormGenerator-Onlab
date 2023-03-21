import Foundation

// Constants about the App
struct AppConstants {
    static let appVersionNumber: Double = 1.0
}

// Constants for the error screen (space view)
struct AnimatedSpaceScreen{
    static let numberOfStars: Int = 250
}

// Constants strings for UI texts
struct UITextConstants{
    struct NetworkStateTexts{
        static let retryConnectionText: String = "Trying to reconnect..."
    }
    static let any = 10
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
