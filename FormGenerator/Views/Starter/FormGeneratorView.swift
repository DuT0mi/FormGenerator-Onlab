import SwiftUI

struct FormGeneratorView: View {
    @StateObject var user: UserViewModel = UserViewModel()
    @StateObject var networkManager: NetworkManagerViewModel = NetworkManagerViewModel()
    @State private var isConnected:Bool = false
    @State private var spaceViewIsPresented: Bool = false
    
    fileprivate var homeView: some View {
        HomeView(user: user, networkManager: networkManager)
    }
    fileprivate var tabView: some View {
        TabView {
            IntroView(networkManager: networkManager)
                .tabItem {
                    Label("Home",systemImage: "house.fill")
                }
            LoginView(user: user, networkManager: networkManager)
                .tabItem {
                    Label("Start", systemImage: "person.fill")
                }
            
        }
    }
    
    var body: some View {
        ZStack{
            if networkManager.isNetworkReachable{
                if !user.isSignedIn{
                    tabView
                } else {
                    homeView
                }
            } else {
                SpaceView(networkManager: networkManager)
            }
        }
    }
   
}
struct FormGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        FormGeneratorView()
    }
}
    

