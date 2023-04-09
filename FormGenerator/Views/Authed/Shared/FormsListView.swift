import SwiftUI

struct FormsListView: View {
    @ObservedObject var networkManager: NetworkManagerViewModel
    @StateObject private var viewModel: FormListViewModel = FormListViewModel()
    
    var body: some View {
        if networkManager.isNetworkReachable{
            NavigationView{
                VStack{
                    Text("All of the forms come here")
                }
                .task{
                    try? await viewModel.loadCurrentAccount()
                }
                .toolbar{
                    if viewModel.account?.type.rawValue != AccountType.Standard.rawValue, viewModel.isAccountLoaded {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: CreateFormView()) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()
        } else {
            SpaceView(networkManager: networkManager)
        }
    }
}

struct FormsListView_Previews: PreviewProvider {
    static var previews: some View {
        FormsListView(networkManager: NetworkManagerViewModel())
    }
}
