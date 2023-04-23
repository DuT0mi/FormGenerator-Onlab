import SwiftUI

struct IntroView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    
    var body: some View {
        if networkManager.isNetworkReachable{
            ZStack{
                AppConstants.backgroundColor
                VStack{
                    Label("Home",systemImage: "house.fill")
                }
            }
            .ignoresSafeArea()
        } else {
            SpaceView()
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .environmentObject(NetworkManagerViewModel())
    }
}
