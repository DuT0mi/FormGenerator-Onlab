import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @ObservedObject var user: UserViewModel
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        if networkManager.isNetworkReachable{
                VStack{
                    Form {
                        Section {
                            Text("Text")
                            Text("Account type: \(viewModel.account?.type.rawValue ?? "" ) ")
                        } header: {
                            Text("Profile")
                        }
                        Section {
                            HStack {
                                Text("Version")
                                Spacer()
                                Text("\(AppConstants.appVersionNumber, specifier: "%.2f")")
                            }
                        } header: {
                            Text("About")
                        }
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
                }
                .task {
                    try? await viewModel.loadCurrentAccount()
                }
            
        } else {
            SpaceView(networkManager: networkManager)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(user: UserViewModel())
            .environmentObject(NetworkManagerViewModel())
    }
}

