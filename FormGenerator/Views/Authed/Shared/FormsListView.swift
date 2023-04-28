import SwiftUI
import SwiftUIPullToRefresh

struct FormsListView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @StateObject private var viewModel: FormListViewModel = FormListViewModel()
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        if networkManager.isNetworkReachable{
            NavigationView{
                    ScrollView{
                        LazyVGrid(columns: columns){
                            ForEach(viewModel.forms){form in
                                NavigationLink{
                                    FormViewDetail(form: form)
                                }label: {
                                    FormItemView(form: form)
                                }
                                if form == viewModel.forms.last{
                                    if let formsOnServerCount = viewModel.allFormCountOnServer, formsOnServerCount != viewModel.forms.count{
                                        ProgressView()
                                            .onAppear{
                                                viewModel.downloadAllForm()
                                            }
                                    }
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
                    .refreshableCompat(onRefresh: { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            viewModel.pullRefreshDownloadAllForm()
                          done()
                        }
                    }, progress: { state in
                        RefreshActivityIndicator(isAnimating: state == .loading) {
                            $0.hidesWhenStopped = true
                        }
                    })
                }
                .onAppear{
                    viewModel.downloadAllForm()
                }
        } else {
            SpaceView()
        }
    }
}

struct FormsListView_Previews: PreviewProvider {
    static var previews: some View {
        FormsListView()
            .environmentObject(NetworkManagerViewModel())
    }
}
