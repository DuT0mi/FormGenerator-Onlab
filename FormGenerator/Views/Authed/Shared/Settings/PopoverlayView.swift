import SwiftUI

struct PopupOverlay: View {
    @ObservedObject var viewModel: SettingsViewModel
    @ObservedObject var user: UserViewModel
    @Binding var showError: Bool
    @State private var showInfo: Bool = false
    @State private var userInput: String = ""
    @Binding var isShowingPopup: Bool
    
    private func checkUserInputForPassword(userInputPassword pw : String){
        PasswordValidation().validatePassword(password: pw) { result in
            switch result {
                case .failure( _ ): showError = true; break
                case .success(): break
            }
            
        }
    }
    private func checkUserInputForEmeail(userInputEmail email : String){
        EmailValidation().validateEmail(email: email) { result in
            switch result {
                case .failure( _ ): showError = true; break
                case .success(): break
            }
        }
    }
    private func buttonTemplate(text: String, action: @escaping () -> Void ) -> some View{
        Button {
                action()
                isShowingPopup.toggle()
        } label: {
            Text(text)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.black)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 2)
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
                    checkUserInputForPassword(userInputPassword: userInput)
                    try await viewModel.updatePassword(password: userInput)
                    // TODO: checking if the password passes the regex
                    try user.logout()
                }
            }
            buttonTemplate(text: "Email upd") {
                Task{
                    checkUserInputForEmeail(userInputEmail: userInput)
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
            PopupOverlay(viewModel: SettingsViewModel(), user: UserViewModel(), showError: .constant(false), isShowingPopup: .constant(true))
                .preferredColorScheme(.dark)
        }
    }
}

