import SwiftUI

struct IntroView: View {
    @ObservedObject var networkManager: NetworkManagerViewModel
    
    var body: some View {
        if networkManager.isNetworkReachable{
            VStack{
                Label("Home",systemImage: "house.fill")
            }
        } else {
            SpaceView(networkManager: networkManager)
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(networkManager: NetworkManagerViewModel())
    }
}
