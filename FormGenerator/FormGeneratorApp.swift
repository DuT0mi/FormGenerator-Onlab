import SwiftUI
import FirebaseCore

@main
struct FormGeneratorApp: App {
    @StateObject var networkManager: NetworkManagerViewModel = NetworkManagerViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            FormGeneratorView(user:UserViewModel())
                .environmentObject(networkManager)
        }
    }
}
