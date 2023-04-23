import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var user: UserViewModel
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @State private var isShowingPopup:Bool = false
    @State var  showError: Bool = false
    
    fileprivate var profileSection: some View {
        Section {
            Text("Text")
            Text("Account type: \(viewModel.account?.type.rawValue ?? "" ) ")
            Text("userID with vm: " + (viewModel.account?.userID ?? "ures"))
            Text("userID with default: " + (UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue) ?? "ures"))
        } header: {
            Text("Profile")
        }
    }
    fileprivate var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text("\(AppConstants.appVersionNumber, specifier: "%.2f")")
            }
        } header: {
            Text("About")
        }
    }
    fileprivate var logOutSection: some View {
        Section{
            Button {
                Task{
                    do{
                        try user.logout()
                    } catch {/* error handled in user view model */}
                }
            }label: {
                HStack{
                    Spacer()
                    Label("Log Out", systemImage: "figure.walk.arrival")
                        .foregroundColor(.red)
                        .bold()
                    Spacer()
                }
            }
        } header: {
            Text("log out".uppercased())
        }
    }
    
    var body: some View {
        if networkManager.isNetworkReachable{
            ZStack{
                Form {
                    profileSection
                    aboutSection
                    logOutSection
                }
                if isShowingPopup{
                    Color.black.opacity(0.5)
                                    .edgesIgnoringSafeArea(.all)
                    PopupOverlay(viewModel: viewModel, user: user, showError: $showError, isShowingPopup: $isShowingPopup)
                }
                if showError {
                    // TODO: something error handling, animated, ...
                        Text("aaaaaaaaaaaa")
                }
            } // MARK: Just for testing it
            .onChange(of: showError, perform: { newValue in
                if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                                showError = false
                        }
                }
            })
            .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingPopup = true
                        } label: {
                            Image(systemName: "gearshape")
                        }



                    }
                }
            .task {
                try? await viewModel.loadCurrentAccount()
            }
            .onAppear{
                viewModel.loadAuthenticationProviders()
            }
        } else {
            SpaceView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SettingsView(user: UserViewModel())
                .environmentObject(NetworkManagerViewModel())
        }
    }
}
