import Foundation
import SwiftUI

struct DemoItem: Hashable, Codable, Identifiable{
    var id: Int
    var title: String
    var description: String
    private var imageName: String
    var image: Image{
        Image(imageName)
    }
}
