import SwiftUI

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
                    Image(systemName: "info.circle")
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
        }
        .padding()
    }
}
struct PopupOverlay_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PopupOverlay(viewModel: SettingsViewModel(), user: UserViewModel(), isShowingPopup: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}

