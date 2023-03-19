import SwiftUI
import Dispatch

struct SpaceView: View {
    @ObservedObject var networkManager: NetworkManager
    @State private var hasConnected:Bool = false
    
    struct Star: Identifiable, Equatable {
        let id = UUID()
        let color: Color
        let size: CGFloat
        var position: CGPoint
        var isAnimating: Bool = false
    }
    
    let starColors: [Color] = [.white, .gray, .yellow, .orange]
    let numStars = 250
    
    @State var stars: [Star] = []
    
    fileprivate var navigationLinkComponent: some View {
        NavigationLink(destination: FormGeneratorView().navigationBarBackButtonHidden(true)) {
            Text("Connected, get started")
                .bold()
        }
    }
    fileprivate var alertTextComponent: some View {
            Text(UITextConstants.retryConnectionText)
                .foregroundColor(.white)
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
                let position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
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
            NavigationView{
                ZStack{
                    VStack{
                        animation
                        if hasConnected{
                            HStack{
                                navigationLinkComponent
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                            .padding()
                        } else {
                            Button{
                                Task{
                                   let response =  await networkManager.isInternetAvailable()
                                    if response{
                                        hasConnected = true
                                    }
                                }
                            } label: {
                                HStack{
                                    alertTextComponent
                                    Image(systemName: "gobackward")
                                        .foregroundColor(.red)
                                }
                                .padding()
                            }
                        }
                            
                    }
                    .background(.black)
                    .task{
                        let response = await networkManager.isInternetAvailable()
                        if response{
                            self.hasConnected = true
                        }
                    }
                }
            }
        .ignoresSafeArea()
        .toolbar(.hidden)
    }
    }

struct SpaceView_Previews: PreviewProvider {
    static var previews: some View {
        SpaceView(networkManager: NetworkManager())
    }
}
