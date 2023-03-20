import SwiftUI

struct HomeView: View {
    @ObservedObject var user: UserViewModel
    @State private var selection: Tab = .all
    @State private var shouldShowSuccessView: Bool = true
    
    /// Which contexts are involved in the popup message only works when the app is started. (Quit the app and then start it again)
    private func getPopUpContent<TimeType>(content: some View, extratime: TimeType ) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(truncating: (extratime) as! NSNumber)){
                    withAnimation(.easeInOut(duration: 1.5)){
                       shouldShowSuccessView.toggle()
                    }
                }
            }
    }
    private enum Tab{
        case all
        case recent
        case profile
    }
    fileprivate var popUpContent: some View {
        get {
            PopUpView()
        }
    }
    
    var body: some View {
            TabView(selection: $selection){
                FormsListView()
                    .tabItem {
                        Label("All", systemImage: "tray")
                    }
                    .tag(Tab.all)
                RecentsFormsView()
                    .tabItem {
                        Label("Recents", systemImage: "clock")
                    }
                    .tag(Tab.recent)
                SettingsView(user: user)
                    .tabItem {
                        Label("Profile",systemImage:"person.crop.circle.fill")
                    }
                    .tag(Tab.profile)
            }
            .overlay{
                if shouldShowSuccessView {
                    getPopUpContent(content: popUpContent, extratime: PopUpMessageTimer.onScreenTime)
                }
            }
        }
    }
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: UserViewModel())
    }
}
