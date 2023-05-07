import SwiftUI

struct Star: Identifiable, Equatable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    var position: CGPoint
    var isAnimating: Bool = false
}
