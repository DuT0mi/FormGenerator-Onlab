import SwiftUI
import PhotosUI

struct AddFormView: View {
    @EnvironmentObject var networkManager: NetworkManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var formTitle: String = ""
    @State private var formCompanyName: String = ""
    @State private var formDescription: String = ""
    @State private var formType: String = ""
    @State private var isThereAnyEmptyField: Bool = false
    @State private var selectedBackgroundItem: PhotosPickerItem?
    @State private var selectedBackgroundImage: Image?
    @State private var photoSelectorLabel: String?
    @State private var invalidSelectedPhotoErrorShouldShow: Bool = false
    @State private var isAccountPremium: Bool = false
    
    var backgroundImage = ImageConstants.templateBackgroundImage
    var circleImage = ImageConstants.templateCircleImage
    
    private func getPopUpContent<TimeType>(content: some View, extratime: TimeType ) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(truncating: (extratime) as! NSNumber)){
                    withAnimation(.easeInOut(duration: PopUpMessageTimer.defaultTime)){
                        invalidSelectedPhotoErrorShouldShow.toggle()
                    }
                }
            }
    }
    private func isEmptySomething() -> Bool{
         formTitle.isEmpty                  ||
         formCompanyName.isEmpty            ||
         formDescription.isEmpty            ||
         formType.isEmpty                   ||
         (selectedBackgroundItem == nil)    ||
         (selectedBackgroundImage == nil)
        
    }
    fileprivate var photoSelector: some View {
        PhotosPicker(selection: $selectedBackgroundItem,matching: .images, photoLibrary: .shared()) {
            Image(systemName: "photo")
                .bold()
                .font(.system(size: 20))
        }
    }
    fileprivate var selectedImageThumbnail: some View {
        selectedBackgroundImage!
            .resizable()
            .scaledToFit()
            .frame(width: ImageConstants.selectedThumbnailWidth, height: ImageConstants.selectedThumbnailHeight)
            
    }
    fileprivate var deleteSelectedImageButton: some View {
        Button {
            self.selectedBackgroundImage = nil
            
        } label: {
            Text("❌")
        }

    }
    fileprivate var backgroundImageComponent: some View {
        Image(backgroundImage)
            .resizable()
            .frame(height: ImageConstants.backgroundImageFrameHeight)
            .opacity(ImageConstants.backgroundImageOpacityFactor)
            .overlay{
                HStack{
                    Spacer()
                    photoSelector
                    Spacer()
                    if selectedBackgroundImage != nil {
                        selectedImageThumbnail
                        Spacer()
                        deleteSelectedImageButton
                        Spacer()
                    }
                }
            }
    }
    // TODO: after bg image
    fileprivate var circleImageComponent: some View {
        CompanyCircleView(image: circleImage)
            .offset(y: -100)
            .padding(.bottom, -100)
            .opacity(0.6)
    }
    fileprivate var buttonComponent: some View {
        Button("Add"){
            if isEmptySomething(){
                isThereAnyEmptyField = true
            } else {
                let formData = FormData(id: UUID(),
                                        title: formTitle,
                                        type: formType,
                                        companyID: UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)!,
                                        companyName: formCompanyName,
                                        description: formDescription,
                                        answers: "answers",
                                        backgroundImagePath: nil,
                                        backgroundImageURL: nil)
                // Never will be "nil" because of the input checker, but I do not have to force unwrap it
                if let selectedBackgroundItem{
                    AddFormViewModel.shared.formDatas = formData
                    AddFormViewModel.shared.selectedItem = selectedBackgroundItem
                }
                CoreDataController().addFormMetaData(context: managedObjectContext, formData: formData)
                AddFormViewModel.shared.isFormHasBeenAdded = true
                dismiss.callAsFunction()
            }
        }
        .alert(isPresented: $isThereAnyEmptyField){
            Alert(
                title: Text("Invalid parameter(s)!"),
                message: Text("You have to fill every field!"),
                dismissButton: .destructive(Text("Got it!"))
            )
            
        }
    }
    
    var body: some View {
            ScrollView{
                LazyVStack{
                    backgroundImageComponent
                    
                    circleImageComponent
                    
                    LazyVStack(alignment: .leading){
                        TextField("Title", text: $formTitle)
                            .font(.title)
                        
                        HStack{
                            TextField("Type", text: $formType)
                            Divider()
                                .background(.black)
                                .bold()
                                
                            TextField("Company",text: $formCompanyName)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        VStack{
                            TextField("Description", text: $formDescription)
                            Divider()
                                .background(.red)
                                .bold()
                                .font(.title2)
                            Text(formDescription)
                                .lineLimit(nil)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    buttonComponent
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
                .onChange(of: selectedBackgroundItem){_ in
                    Task{
                        if let data = try? await selectedBackgroundItem?.loadTransferable(type: Data.self){
                            if let image = UIImage(data: data){
                                selectedBackgroundImage = Image(uiImage: image)
                                ImageViewModel.shared.selectedImage = selectedBackgroundImage
                            }
                        } else {
                            invalidSelectedPhotoErrorShouldShow = true
                        }
                    }
                }
                .overlay{
                    if invalidSelectedPhotoErrorShouldShow {
                        getPopUpContent(content: InvalidView(text: "Image format should be jpeg"), extratime: PopUpMessageTimer.onScreenTimeExtended)
                    }
                }
                .onAppear{
                    AddFormViewModel.shared.isAccountPremium()
                }
            }
            .edgesIgnoringSafeArea(.top)
    }
}
struct AddFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AddFormView()
                .environmentObject(NetworkManagerViewModel())
        }
    }
}
