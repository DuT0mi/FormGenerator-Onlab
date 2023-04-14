import SwiftUI

struct FormGeneratorView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @StateObject private var dataController: CoreDataController = CoreDataController()
    @StateObject var user: UserViewModel = UserViewModel()
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
            if networkManager.isNetworkReachable{
                if !user.isSignedIn{
                    tabView
                } else {
                    homeView
                        .environment(\.managedObjectContext, dataController.container.viewContext)
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
            .environmentObject(NetworkManagerViewModel())
    }
}
    

