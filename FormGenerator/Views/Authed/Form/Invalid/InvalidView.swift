import SwiftUI

struct InvalidView: View {
    typealias PC = PopUpViewsConstants
    
    var text: String
    
    var body: some View {
        VStack{
            ZStack{
                Text("❌ " +  text + " ❌")
                    .foregroundColor(.red)
                    .bold()
                    .lineLimit(nil)
                    .frame(width: PC.invalidViewFrameWidth, height: PC.invalidViewFrameHeight)
                
            }
            Spacer()
        }
        .padding()
    }
}

struct InvalidImageView_Previews: PreviewProvider {
    static var previews: some View {
        InvalidView(text: "Image format shoudl be jpeg")
    }
}
