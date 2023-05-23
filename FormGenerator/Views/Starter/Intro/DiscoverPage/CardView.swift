import SwiftUI

struct CardView: View {
    var demoCard: DemoItem

    var body: some View {
        demoCard.image
            .resizable()
            .aspectRatio(3 / 2, contentMode: .fit)
            .overlay {
                TextOverlay(demoCard: demoCard)
            }
    }
}

struct TextOverlay: View {
    var demoCard: DemoItem

    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            VStack(alignment: .leading) {
                Text(demoCard.title)
                    .font(.title)
                    .bold()
                Text(demoCard.description)
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}
