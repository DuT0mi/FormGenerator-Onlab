import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var user: UserViewModel
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @State private var isShowingPopup:Bool = false
    
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
                    PopupOverlay(viewModel: viewModel, user: user, isShowingPopup: $isShowingPopup)
                }
            }
            .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingPopup = true
                        } label: {
                            Image(systemName: "gearshape.fill")
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


struct PopupOverlay: View {
    @ObservedObject var viewModel: SettingsViewModel
    @ObservedObject var user: UserViewModel
    @State private var showInfo: Bool = false
    @State private var userInput: String = ""
    @Binding var isShowingPopup: Bool
    
    private func buttonTemplate(text: String, action: @escaping () -> Void ) -> some View{
        Button {
                action()
                isShowingPopup.toggle()
        } label: {
            Text(text)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), .black]), startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), .black]), startPoint: .leading, endPoint: .trailing), lineWidth: 2)
                )
        }

        
    }
    
    var body: some View {
            VStack {
                HStack{
                    Button("Cancel"){
                        isShowingPopup = false
                    }
                    Spacer()
                    Spacer()
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.accentColor)
                    // TODO: the info
                        
                }
                
                TextField("Change what you like'd to!", text: $userInput)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if viewModel.authProviders.contains(.apple)  ||
                    viewModel.authProviders.contains(.google) {
                    ssoSection
                } else {
                    getemailSection()
                }
                
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        }
}
extension PopupOverlay {
    
    var ssoSection: some View {
        buttonTemplate(text: "Delete acc") {
            Task {
                try await viewModel.deleteUser()
                try user.logout()
            }
        }
    }
    func getemailSection() -> some View {
        Group{
            buttonTemplate(text: "Update pw") {
                Task{
                    try await viewModel.updatePassword(password: userInput)
                    // TODO: checking if the password passes the regex
                    try user.logout()
                }
            }
            buttonTemplate(text: "Email upd") {
                Task{
                    try await viewModel.updateEmail(email: userInput)
                    // TODO: email regex check
                    try user.logout()
                }
            }
            buttonTemplate(text: "Delete acc") {
                Task {
                    try await viewModel.deleteUser()
                    // TODO: check if it works
                    try user.logout()
                }
            }
            buttonTemplate(text: "Reset pw") {
                Task{
                    try await viewModel.resetPassword(email: user.email)
                    // TODO: check if it works
                    try user.logout()
                }
            }
        }
    }
}
