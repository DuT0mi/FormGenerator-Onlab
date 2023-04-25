import Foundation
import SwiftUI

@MainActor
final class ImageViewModel{
    @Published var selectedImage: Image?
    
    static let shared: ImageViewModel = ImageViewModel()
    
    private init(){  }
}
