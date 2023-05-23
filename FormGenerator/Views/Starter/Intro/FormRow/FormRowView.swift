import SwiftUI

struct FormRowView: View {
    var forms: [FormData]{
        get {
            [
                FormData(id: UUID(), time: 23, isAvailable: true, title: "                     Basic", type: "Type", companyID: UUID().uuidString, companyName: "Company name", description: "Description", backgroundImageURL: AppConstants.randomPicURL),
                FormData(id: UUID(), time: 54, isAvailable: true, title: "                     Premium", type: "Type premium", companyID: UUID().uuidString, companyName: "Company name premium", description: "Description premium", backgroundImageURL: AppConstants.randomPicURL, circleImageURL: AppConstants.randomPicURL)
            ]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Forms")
                .font(.headline)
                .bold()
                .padding(.leading, 15)
                .padding(.top, 5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(forms, id:\.id) { form in
                        NavigationLink {
                            DetailTemplate(form: form)
                        } label: {
                            FormItemView(form: form)
                                .frame(width: ScreenDimensions.width / 2)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct FormRowView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowView()
    }
}
