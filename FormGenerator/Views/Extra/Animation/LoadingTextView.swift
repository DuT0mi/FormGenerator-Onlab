import SwiftUI
import Combine

struct LoadingText: View {
    @State private var counter = 0

    private let items: [String] = UITextConstants.NetworkStateTexts.retryConnectionText.map { String($0) }
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private let timing: Double
    private var maxCounter: Int {
        get {
            UITextConstants.NetworkStateTexts.retryConnectionText.count
        }
    }
    private let frame: CGSize
    private let primaryColor: Color
    
    typealias PathOfConstants = UITextConstants.TextAnimationIndicator
    
    init(color: Color = PathOfConstants.foregroundColor, size: CGFloat = PathOfConstants.size,speed: Double = PathOfConstants.speed) {
        timing = speed / PathOfConstants.speedDividerFactor
        timer = Timer.publish(every: timing, on: .main, in: .common).autoconnect()
        frame = CGSize(width: size,
                       height: size)
        primaryColor = color
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id:\.self) { index in
                Text(items[index])
                    .foregroundColor(primaryColor)
                    .font(.system(size: frame.height / PathOfConstants.fontFactor, weight: .semibold, design: .default))
                    .offset(y: counter == index ? -frame.height / PathOfConstants.offsetFactor : 0)
            }
        }
        .frame(height: frame.height, alignment: .center)
        .onReceive(timer, perform: { _ in
            withAnimation(Animation.spring()) {
                counter = counter == (maxCounter - 1) ? 0 : counter + 1
            }
        })
    }
    
}

struct LoadingText_Previews: PreviewProvider {
    static var previews: some View {
        LoadingText()
    }
}
