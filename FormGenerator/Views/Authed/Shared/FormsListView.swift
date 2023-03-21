import SwiftUI

struct FormsListView: View {
    @ObservedObject var networkManager: NetworkManagerViewModel
    
    var body: some View {
        if networkManager.isNetworkReachable{
            VStack{
                Text("All of the forms come here")
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
