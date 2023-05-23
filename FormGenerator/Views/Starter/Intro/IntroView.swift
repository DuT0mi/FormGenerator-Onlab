import SwiftUI

struct IntroView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @EnvironmentObject var demoModelData: DemoData
    
    var body: some View {
        if networkManager.isNetworkReachable{
            NavigationStack{
                        List{
                            PageView(pages: demoModelData.demoItems!.compactMap{
                                CardView(demoCard: $0)
                            })
                            .aspectRatio(3 / 2, contentMode: .fit)
                            .listRowInsets(EdgeInsets())
                            
                            FormRowView()
                                .listRowInsets(EdgeInsets())
                            QuestionRowView()
                                .listRowInsets(EdgeInsets())
                        }
                        .listStyle(.inset)
                }
             .navigationTitle("Discover")            
        } else {
            SpaceView()
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            IntroView()
                .environmentObject(NetworkManagerViewModel())
                .environmentObject(DemoData())
        }
    }
}
