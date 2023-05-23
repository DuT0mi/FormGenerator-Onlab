import SwiftUI

struct FormItemView: View {
    
    var form: FormData
    var image: String = ImageConstants.templateBackgroundImage
    
    
    var body: some View {
        VStack(spacing: .zero){
            if let urlString = form.backgroundImageURL, let url = URL(string: urlString) {
                AsyncImage(url: url){ image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: ImageConstants.DownloadedItem.frameHeight)
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
                        .frame(height: ImageConstants.DownloadedItem.frameHeight)
                }
            }
                    
                }
        .clipShape(RoundedRectangle(cornerRadius: ImageConstants.DownloadedItem.roundedRectangleRadius, style: .circular))
    }
}

struct FormItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FormItemView(form: FormData(id: UUID(), time: 10, isAvailable: true, title: "title", type: "", companyID: "", companyName: "", description: "", backgroundImagePath: "", backgroundImageURL: "https://picsum.photos/200/300"))
                .frame(width: 250)
        }
    }
}
