import SwiftUI

struct RecentsFormsView: View {
    @ObservedObject var networkManager: NetworkManagerViewModel
    
    var body: some View {
        if networkManager.isNetworkReachable{
            VStack{
                Text("All of the recents forms come here: started and not finished and finished")
            }
        } else {
            SpaceView(networkManager: networkManager)
        }
        
        
    }
}

struct RecentsFormsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentsFormsView(networkManager: NetworkManagerViewModel())
    }
}
