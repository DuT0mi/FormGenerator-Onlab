import SwiftUI

struct CountDownView: View {
    @State var timeRemaining: Int // Initial time in seconds
    @Binding var timeIsZero: Bool
    var limit: CGFloat // For the animating, same as the initial

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    

    var body: some View {
        VStack {
            Text("Time Remaining: \(timeRemaining)")
                .font(.title2)
                .bold()
                .italic()
                .foregroundColor((timeRemaining - 10) < 0 ? .red : .accentColor)

            ZStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / limit) // Adjust the divisor based on your desired maximum time
                        .stroke(.blue , lineWidth: 10)
                        .frame(width: 100, height: 100)
                        .rotationEffect(Angle(degrees: -90))

                Text("\(timeRemaining)")
                    .foregroundColor((timeRemaining - 10) < 0 ? .red : .accentColor)
                    .bold()
                    .font(.title3)
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            if timeRemaining == 0{
                timeIsZero = true
            }
        }
    }
}

struct CountDown_Previews: PreviewProvider {
    static var previews: some View {
        CountDownView(timeRemaining: 15, timeIsZero: .constant(false), limit: 15)
            .frame(width: 500, height: 500)
    }
}
