import SwiftUI

struct CompanyCircleView: View {
    
    let image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct CompanyCircleView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyCircleView(image: "checkmark")
    }
}
