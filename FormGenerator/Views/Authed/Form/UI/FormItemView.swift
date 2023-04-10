import SwiftUI

struct FormItemView: View {
    
    var form: FormData
    
    var body: some View {
        VStack(spacing: .zero){
                    Image("form_demo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                        .overlay(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: ScreenDimensions.width, height: 40)
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(.top)
                                .overlay(alignment: .leading) {
                                    Text(form.title)
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .fontDesign(.serif)
                                        .padding()
                                }
                        }
                        .overlay(alignment: .topLeading){
                            Image(systemName: "hand.tap")
                                .foregroundColor(.black)
                                .padding()
                                .font(.largeTitle)
                        }
                    
                }
          .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}

struct FormItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FormItemView(form: FormData(id: UUID(), title: "title", type: "", companyID: "", description: "", answers: "", questions: ""))
                .frame(width: 250)
        }
    }
}
