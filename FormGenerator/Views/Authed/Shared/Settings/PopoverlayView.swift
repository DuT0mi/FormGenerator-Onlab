import SwiftUI

struct PopupOverlay: View {
    @Environment (\.managedObjectContext) private var managedObjectContext
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
        if user.email != userInput{
            EmailValidation().validateEmail(email: email) { result in
                switch result {
                case .failure( _ ): showError = true; break
                case .success(): break
                }
            }
        } else { /* Same as the previous one */
            showError = true
        }
    }
    private func buttonTemplate(text: String, action: @escaping () -> Void ) -> some View {
        Button {
                action()
                isShowingPopup.toggle()
        } label: {
            Text(text)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.black)
                .cornerRadius(PopoverlayConstants.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: PopoverlayConstants.cornerRadius)
                        .stroke(.black, lineWidth: PopoverlayConstants.lineWidth)
                )
        }
        .disabled(showInfo ? true : false)
    }
        
    fileprivate var infoComponent: some View {
        Image(systemName: self.showInfo ? "info.circle.fill" : "info.circle")
            .foregroundColor(.accentColor)
            .onTapGesture {
                self.showInfo.toggle()
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
                    infoComponent
                }
                TextField(self.showInfo ? "Examples:" : "Change!", text: $userInput)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if viewModel.authProviders.contains(.apple)  ||
                    viewModel.authProviders.contains(.google) {
                    ssoSection
                } else {
                    getEmailSection()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(PopoverlayConstants.cornerRadius)
            .padding(EdgeInsets(top: PopoverlayConstants.Padding.top,
                                leading: PopoverlayConstants.Padding.leading,
                                bottom: PopoverlayConstants.Padding.bottom,
                                trailing: PopoverlayConstants.Padding.trailing)
            )
        }
}
extension PopupOverlay {
    
    var ssoSection: some View {
        buttonTemplate(text: self.showInfo ? "Permamently? " : "Delete account") {
            Task {
                try await viewModel.deleteUser(context: managedObjectContext)
                print("delete")
                try user.logout()
            }
        }
    }
    func getEmailSection() -> some View {
        Group{
            buttonTemplate(text: self.showInfo ? "at least 6 digit" : "Update password") {
                Task{
                    checkUserInputForPassword(userInputPassword: userInput)
                    try await viewModel.updatePassword(password: userInput)
                    try user.logout()
                }
            }
            buttonTemplate(text: self.showInfo ? "test@gmail.com" : "Update email") {
                Task{
                    checkUserInputForEmeail(userInputEmail: userInput)
                    try await viewModel.updateEmail(email: userInput)
                    try user.logout()
                }
            }
            buttonTemplate(text: self.showInfo ? "Permamently? " : "Delete account") {
                Task {                    
                    try await viewModel.deleteUser(context: managedObjectContext)
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

