import SwiftUI

struct FormGeneratorView: View {
    @StateObject var user: UserViewModel = UserViewModel()
    @StateObject var networkManager: NetworkManagerViewModel = NetworkManagerViewModel()
    @State private var isConnected:Bool = false
    @State private var spaceViewIsPresented: Bool = false
    
    fileprivate var homeView: some View {
        HomeView(user: user)
    }
    fileprivate var tabView: some View {
        TabView {
            IntroView()
                .tabItem {
                    Label("Home",systemImage: "house.fill")
                }
            LoginView(user: user)
                .tabItem {
                    Label("Start", systemImage: "person.fill")
                }
            
        }
    }
    
    var body: some View {
        ZStack{
            if isConnected{
                if !user.isSignedIn{
                    tabView
                } else {
                    homeView
                }
            } else {
                SpaceView(networkManager: networkManager)
            }
        }
        .task {
            do{
                let response = await networkManager.isInternetAvailable()
                if response {
                    self.isConnected.toggle()
                }
            }
        }
    }
   
}
struct FormGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        FormGeneratorView()
    }
}
    

