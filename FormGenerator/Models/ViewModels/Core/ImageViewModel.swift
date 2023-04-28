import Foundation
import SwiftUI

@MainActor
final class ImageViewModel{
    @Published var selectedBackgroundImage: Image?
    @Published var selectedCircleImage: Image?
    
    static let shared: ImageViewModel = ImageViewModel()
    
    private init(){  }
}
