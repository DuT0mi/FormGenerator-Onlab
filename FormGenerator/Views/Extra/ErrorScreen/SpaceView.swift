import SwiftUI
import Dispatch

struct SpaceView: View {
    @ObservedObject var networkManager: NetworkManagerViewModel
    
    @State var stars: [Star] = []
    @State private var starColors: [Color] = [.white, .gray, .yellow, .orange]
    @State private var numStars = AnimatedSpaceScreen.numberOfStars
    @State private var position: CGPoint = CGPoint()
    @State private var shouldShowAlertComponents: Bool = false
    
    fileprivate var alertAnimatedTextComponent: some View{
        LoadingText()
    }
    fileprivate var alertImageComponent: some View {
        Image(systemName: "wifi.slash")
            .foregroundColor(.orange)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ZStack {
                    // Space background
                    Color.black
                        .frame(width: geometry.size.width, height: geometry.size.height)
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
                    createStars(in: geometry)
                    animateStars()
                }
                .onChange(of: geometry.size, perform: { _ in
                    stars.removeAll()
                    createStars(in: geometry)
                    animateStars()
                })
                Group {
                    VStack{
                        alertAnimatedTextComponent
                        alertImageComponent
                    }
                
                }
                .opacity(shouldShowAlertComponents ? 1.0 : 0.0)
            }
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    shouldShowAlertComponents = true
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func createStars(in geometry: GeometryProxy) {
        // Create stars
        for _ in 1...numStars {
            let size = CGFloat.random(in: 1...2)
            let position = CGPoint(
                x: CGFloat.random(in: 0...geometry.size.width),
                y: CGFloat.random(in: 0...geometry.size.height)
            )
            let color = starColors.randomElement()!
            let star = Star(color: color, size: size, position: position)
            stars.append(star)
        }
    }
    private func animateStars() {
        for index in 0..<stars.count {
            let delay = Double.random(in: 0...3)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(
                    Animation
                        .easeInOut(duration: 2.0)
                        .repeatForever()
                ) {
                    stars[index].isAnimating = true
                }
            }
        }
    }
}

struct SpaceView_Previews: PreviewProvider {
    static var previews: some View {
        SpaceView(networkManager: NetworkManagerViewModel())
        // .previewInterfaceOrientation(.landscapeLeft)
    }
}
