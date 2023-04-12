import SwiftUI

struct FormsListView: View {
    @ObservedObject var networkManager: NetworkManagerViewModel
    @StateObject private var viewModel: FormListViewModel = FormListViewModel()
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        if networkManager.isNetworkReachable{
            NavigationView{
                ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(viewModel.forms){form in
                        NavigationLink{
                            FormViewDetail(networkManager: networkManager, form: form)
                        }label: {
                            FormItemView(form: form)
                        }
                    }
                }
                .padding()
                .task{
                    try? await viewModel.loadCurrentAccount()
                }
                .toolbar{
                    if viewModel.account?.type.rawValue != AccountType.Standard.rawValue ,
                       viewModel.isAccountLoaded {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: CreateFormView()) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
        }
          .onAppear{
                viewModel.downloadAllForm()
            }
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
