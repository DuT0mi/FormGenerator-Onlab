import SwiftUI


struct PopUpView: View{
    
    var body: some View {
        VStack{
            Image(systemName: "person.crop.circle.badge.checkmark")
                .foregroundColor(Color(red: 0, green: 0.4, blue: 0))
                .bold()
                .padding()
            Spacer()
        }
    }
}
struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView()
          //  .preferredColorScheme(.dark)
    }
}
