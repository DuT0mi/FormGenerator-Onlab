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
            NavigationStack{
                IntroView()
            }
                .tabItem {
                    Label("Home",systemImage: "house.fill")
                }
            NavigationStack{
                LoginView(user: user)
            }
                .tabItem {
                    Label("Start", systemImage: "person.fill")
                }
            
        }
    }
    
    var body: some View {
        ZStack{
            if networkManager.isNetworkReachable{
                if user.isAutoLoginLoading{
                 ProgressView()
                }
                else if !user.isSignedIn{
                    tabView
                } else {
                    homeView
                        .environment(\.managedObjectContext, dataController.containerQ.viewContext)
                        .environment(\.managedObjectContext, dataController.containerF.viewContext)
                }
            } else {
                SpaceView()
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
    

