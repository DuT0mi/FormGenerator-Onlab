import SwiftUI
import FirebaseCore

@main
struct FormGeneratorApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            FormGeneratorView(user:UserViewModel())
        }
    }
}
