import SwiftUI

struct FormItemView: View {
    
    var form: FormData
    var image: String = "form_demo"
    
    
    var body: some View {
        VStack(spacing: .zero){
            if let urlString = form.backgroundImageURL, let url = URL(string: urlString) {
                AsyncImage(url: url){ image in
                    image
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
                }placeholder: {
                    ProgressView()
                        .frame(height: 150)
                }
            }
                    
                }
          .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}

struct FormItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FormItemView(form: FormData(id: UUID(), title: "title", type: "", companyID: "", companyName: "", description: "", answers: "", backgroundImagePath: "", backgroundImageURL: "https://firebasestorage.googleapis.com:443/v0/b/formgenerator-b9012.appspot.com/o/forms%2F87A324F5-FFF9-4F86-AC62-D7A7E1E6DEEF%2Fimages%2F07101978-D32C-427D-BC2B-EFE4EDDCEC95.jpeg?alt=media&token=97091564-e3cb-42ec-b7f6-b7056bf87e9e"))
                .frame(width: 250)
        }
    }
}
