import SwiftUI
import PhotosUI

struct CompanyCircleView: View {
    typealias IC = ImageConstants.CircleImage
    
    let image: String
    let optionalImage: Image?
    
    fileprivate var content: Image? {
        (optionalImage != nil) ? optionalImage?.resizable() : Image(image).resizable()
    }
    var body: some View {
       content
            .frame(width: IC.defaultWidth, height: IC.defaultHeight)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: IC.lineWidth)
            }
            .shadow(radius: IC.shadowRadius)
    }
}

struct CompanyCircleView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyCircleView(image: "checkmark", optionalImage: nil)
    }
}
