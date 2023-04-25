import SwiftUI

struct InvalidView: View {
    
    var text: String
    
    var body: some View {
        VStack{
            ZStack{
                Text("❌ " +  text + " ❌")
                    .foregroundColor(.red)
                    .bold()
                    .lineLimit(nil)
                    .frame(width: 300, height: 150)
                
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
