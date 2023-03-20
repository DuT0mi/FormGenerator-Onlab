import SwiftUI


struct PopUpView: View{
    
    var body: some View {
        VStack{
            Image(systemName: "person.crop.circle.badge.checkmark")
                .foregroundColor(.black)
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
