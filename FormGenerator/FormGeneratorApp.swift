import SwiftUI
import FirebaseCore

@main
struct FormGeneratorApp: App {
    @StateObject var networkManager: NetworkManagerViewModel = NetworkManagerViewModel()
    @StateObject var demoModelData: DemoData = DemoData()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            FormGeneratorView(user:UserViewModel())
                .environmentObject(networkManager)
                .environmentObject(demoModelData)
        }
    }
}
