import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var user: UserViewModel
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @State private var isShowingPopup: Bool = false
    @State var  showError: Bool = false
    @State private var premiumStatus: Bool = false
    
    private func getPopUpContent<TimeType>(content: some View, extratime: TimeType ) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(truncating: (extratime) as! NSNumber)){
                    withAnimation(.easeInOut(duration: 1.5)){
                        showError.toggle()
                    }
                }
            }
    }
    fileprivate var profileSection: some View {
        Section {
            Text("Text")
            Text("Account type: \(viewModel.account?.type.rawValue ?? "" ) ")
           // Text("userID with vm: " + (viewModel.account?.userID ?? "ures"))
           // Text("userID with default: " + (UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue) ?? "ures"))
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
    fileprivate var premiumSection: some View {
        Section{
            Toggle(premiumStatus ? "Turn off" : "Turn on", isOn: $premiumStatus)
                .onChange(of: premiumStatus) { newValue in
                    viewModel.togglePremiumStatus(newValue: newValue)
                }
        } header: {
            Text("Premium".uppercased())
        }
    }
    var body: some View {
        if networkManager.isNetworkReachable{
            ZStack{
                Form {
                    profileSection
                    if viewModel.account?.type == .Company {
                        premiumSection
                            .onAppear{
                                Task{
                                    self.premiumStatus = try await AccountManager.shared.getCompanyAccount(userID: UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)!).isPremium ?? false
                                }
                            }
                    }
                    aboutSection
                    logOutSection
                }
   
            }
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
            .overlay{
                if showError {
                    getPopUpContent(content: InvalidView(text: "TODO homemade error: email/pw bad format"), extratime: 1.5)
                }
                if isShowingPopup{
                    Color.black.opacity(0.5)
                                    .edgesIgnoringSafeArea(.all)
                    PopupOverlay(viewModel: viewModel, user: user, showError: $showError, isShowingPopup: $isShowingPopup)
                }
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
