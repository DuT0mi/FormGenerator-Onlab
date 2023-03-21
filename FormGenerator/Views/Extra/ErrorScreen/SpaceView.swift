import SwiftUI
import Dispatch

struct SpaceView: View {
    @ObservedObject var networkManager: NetworkManagerViewModel
    @State private var hasConnected:Bool = false
    @State var stars: [Star] = []
    
    // Local Model for the Stars
    struct Star: Identifiable, Equatable {
        let id = UUID()
        let color: Color
        let size: CGFloat
        var position: CGPoint
        var isAnimating: Bool = false
    }
    
    fileprivate let starColors: [Color] = [.white, .gray, .yellow, .orange]
    fileprivate let numStars = AnimatedSpaceScreen.numberOfStars
    
    fileprivate var alertTextComponent: some View {
        Text(UITextConstants.NetworkStateTexts.retryConnectionText)
                .foregroundColor(.orange)
                .bold()
    }
    var animation: some View {
            ZStack {
                // Space background
                Color.black
                
                // Draw stars
                ForEach(stars) { star in
                    withAnimation(
                        Animation
                            .easeInOut(duration: 0.5)
                            .repeatForever()
                    ){
                        star.color
                            .frame(width: star.size, height: star.size)
                            .position(star.position)
                            .scaleEffect(star.isAnimating ? 1.5 : 1.0)
                            .overlay(
                                withAnimation(
                                    Animation
                                        .easeInOut(duration: 1.0)
                                        .repeatForever()
                                        .delay(1.0)
                                ){
                                    Circle()
                                        .stroke(star.color.opacity(0.5), lineWidth: 4)
                                        .scaleEffect(star.isAnimating ? 2 : 1)
                                        .opacity(star.isAnimating ? 0 : 1)
                                        .frame(height: 100)
                                }
                            )
                    }
                }
            }
            .onAppear {
                // Create stars
                for _ in 1...numStars {
                    let size = CGFloat.random(in: 1...2)
                    let position = CGPoint(
                        x: CGFloat.random(in: 0...ScreenDimensions.width),
                        y: CGFloat.random(in: 0...ScreenDimensions.height))
                    let color = starColors.randomElement()!
                    let star = Star(color: color, size: size, position: position)
                    stars.append(star)
                }
                
                // Animate a random star
                var randomIndex = Int.random(in: 0..<stars.count)
                stars[randomIndex].isAnimating = true
                
                // Add animation to the star after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(
                        Animation
                            .easeInOut(duration: 2.0)
                            .repeatForever()
                    ) {
                        stars[randomIndex].isAnimating.toggle()
                    }
                }
                
                // Add animation to the next star after the previous animation is done
                let timer = Timer.scheduledTimer(withTimeInterval: 4.5, repeats: true) { _ in
                    var nextIndex = (randomIndex + 1) % stars.count
                    while stars[nextIndex].isAnimating {
                        nextIndex = (nextIndex + 1) % stars.count
                    }
                    
                    stars[nextIndex].isAnimating = true
                    withAnimation(
                        Animation
                            .easeInOut(duration: 2.0)
                            .repeatForever()
                    ) {
                        stars[nextIndex].isAnimating.toggle()
                    }
                    
                    randomIndex = nextIndex
                }
                timer.fire()
            }
        }
    
    var body: some View {
                ZStack{
                    VStack{
                        animation
                        alertTextComponent
                        Image(systemName: "wifi.slash")
                            .foregroundColor(.orange)
                    }
                    .background(.black)
                }
                .ignoresSafeArea()
        }
    }

struct SpaceView_Previews: PreviewProvider {
    static var previews: some View {
        SpaceView(networkManager: NetworkManagerViewModel())
          //  .previewInterfaceOrientation(.landscapeLeft)
    }
}
