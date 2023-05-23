import SwiftUI
import SwiftUIPullToRefresh

struct FormStatisticsView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @StateObject private var viewModel: FormStatisticsViewModel = FormStatisticsViewModel()
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        if networkManager.isNetworkReachable{
            NavigationStack{
                    ScrollView{
                        LazyVGrid(columns: columns){
                            if viewModel.forms.count == 0{
                                Text("Try our app and create a form!")
                                    .font(.headline)
                            }else{
                                ForEach(viewModel.forms){form in
                                    NavigationLink{
                                        ShowResultView(form: form)
                                    }label: {
                                        FormItemView(form: form)
                                    }
                                    .padding()
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
                .navigationTitle("Statistics")
        } else {
            SpaceView()
        }
        
        
    }
}

struct FormStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            FormStatisticsView()
                .environmentObject(NetworkManagerViewModel())
        }
    }
}
