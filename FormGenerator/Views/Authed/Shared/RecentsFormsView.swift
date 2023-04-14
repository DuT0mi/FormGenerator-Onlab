import SwiftUI

struct RecentsFormsView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    
    var body: some View {
        if networkManager.isNetworkReachable{
            VStack{
                Text("All of the recents forms come here: started and not finished and finished")
            }
        } else {
            SpaceView()
        }
        
        
    }
}

struct RecentsFormsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentsFormsView()
            .environmentObject(NetworkManagerViewModel())
    }
}
