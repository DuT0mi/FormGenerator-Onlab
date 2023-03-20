import SwiftUI


struct PopUpView: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    
    // start and end angle to animate
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x:rect.midX, y: rect.midY);
        let radius = min(rect.width, rect.height)/2;
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
    )
        var newPath = Path()
            newPath.move(to: center)
            newPath.addLine(to:start)
            newPath.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)// clockwise could be inverted
            newPath.addLine(to: center) // go back to the center
        return newPath
    }
    
}


// checkmark
