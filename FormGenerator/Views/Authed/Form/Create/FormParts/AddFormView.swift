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
    @State private var selectedCircleItem: PhotosPickerItem?
    @State private var selectedCircleImage: Image?
    @State private var photoSelectorLabel: String?
    @State private var invalidSelectedPhotoErrorShouldShow: Bool = false
    @State private var isAccountPremium: Bool = false
    @State private var showCameraForCircleImagePhoto: Bool = false
    @State private var isCameraTookPhoto: Bool = false
    @State private var handledPickedImageData: Data?
    
    var backgroundImage = ImageConstants.templateBackgroundImage
    var circleImage = ImageConstants.templateCircleImage
    
    
    private func handlePickedImage(_ image: UIImage?){
        if let imageData = image?.jpegData(compressionQuality: 1.0){
            selectedCircleImage = Image(uiImage: UIImage(data: imageData)!)
            handledPickedImageData = imageData
            selectedCircleItem = nil
            isCameraTookPhoto = true
        }
        showCameraForCircleImagePhoto = false
    }
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
    private func isEmptySomething(isPremium: Bool) -> Bool{
        if isPremium{
            return(
                formTitle.isEmpty                                     ||
                formCompanyName.isEmpty                               ||
                formDescription.isEmpty                               ||
                formType.isEmpty                                      ||
                (selectedBackgroundItem == nil)                       ||
                (selectedBackgroundImage == nil)                      ||
                ((selectedCircleItem == nil) && (!isCameraTookPhoto)) ||
                (selectedCircleImage == nil)
            )
        } else {
            return(
                formTitle.isEmpty                  ||
                formCompanyName.isEmpty            ||
                formDescription.isEmpty            ||
                formType.isEmpty                   ||
                (selectedBackgroundItem == nil)    ||
                (selectedBackgroundImage == nil)
            )
        }
    }
    private func photoSelector(systemName: String, selection: Binding<PhotosPickerItem?>) -> some View{
        PhotosPicker(selection: selection, matching: .images, photoLibrary: .shared()) {
            Image(systemName: systemName)
                .bold()
                .font(.system(size: 20))
        }
    }
    private func selectedImageThumbnail(image: Image? , frameFactor ff : CGFloat = 1) -> some View{
        image!
            .resizable()
            .scaledToFit()
            .frame(width: ImageConstants.selectedThumbnailWidth / ff , height: ImageConstants.selectedThumbnailHeight / ff)
    }
    private func commonDataSave(formData: FormData, selectedItem: PhotosPickerItem){
        AddFormViewModel.shared.formDatas = formData
        AddFormViewModel.shared.selectedItem = selectedItem
    }
    
    fileprivate var deleteSelectedImageButton: some View {
        Button {
            self.selectedBackgroundImage = nil
            
        } label: {
            Text("❌")
        }

    }
    fileprivate var backgroundImageComponentIfThereIsValidImage: Image {
        ((selectedBackgroundImage) != nil) ? selectedBackgroundImage! :  Image(backgroundImage)
    }
    fileprivate var backgroundImageComponent: some View {
        backgroundImageComponentIfThereIsValidImage
            .resizable()
            .frame(height: ImageConstants.backgroundImageFrameHeight)
            .opacity(ImageConstants.backgroundImageOpacityFactor)
            .overlay{
                HStack{
                    Spacer()
                    photoSelector(systemName: "photo", selection: $selectedBackgroundItem)
                    Spacer()
                    if selectedBackgroundImage != nil {
                        selectedImageThumbnail(image: selectedBackgroundImage)
                        Spacer()
                        deleteSelectedImageButton
                        Spacer()
                    }
                }
            }
    }
    fileprivate var cameraComponent: some View {
        Button {
            showCameraForCircleImagePhoto = true
        } label: {
            Image(systemName: "camera.fill")
        }

    }
    fileprivate var circleImageComponentPremium: some View {
        CompanyCircleView(image: circleImage, optionalImage: selectedCircleImage)
            .offset(y: -100)
            .padding(.bottom, -100)
            .opacity(0.2)
            .overlay{
                LazyHStack{
                    photoSelector(systemName: "photo", selection: $selectedCircleItem)
                    Spacer()
                    if selectedCircleImage != nil {
                        selectedImageThumbnail(image: selectedCircleImage)
                    }
                    Spacer()
                    cameraComponent
                }
            }
            .onTapGesture {
                self.selectedCircleImage = nil
                self.handledPickedImageData = nil
                self.isCameraTookPhoto = false
            }
    }
    fileprivate var circleImageComponent: some View {
        CompanyCircleView(image: circleImage, optionalImage: selectedCircleImage)
            .offset(y: -100)
            .padding(.bottom, -100)
            .opacity(0.2)
    }
    fileprivate var buttonComponent: some View {
        Button("Add"){
            if isEmptySomething(isPremium: isAccountPremium ){
                isThereAnyEmptyField = true
            } else {
                let formData = FormData(id: UUID(),
                                        title: formTitle,
                                        type: formType,
                                        companyID: UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)!,
                                        companyName: formCompanyName,
                                        description: formDescription,
                                        answers: "answers")
                
                if let selectedBackgroundItem{
                    commonDataSave(formData: formData, selectedItem: selectedBackgroundItem)
                } // Premium user
                if isAccountPremium , let selectedBackgroundItem{
                    if let selectedCircleItem, !isCameraTookPhoto{
                        AddFormViewModel.shared.selectedPremiumItem = selectedCircleItem
                    } else {
                        AddFormViewModel.shared.selectedPremiumItemDataIfCameraIsUsed = handledPickedImageData
                    }
                    commonDataSave(formData: formData, selectedItem: selectedBackgroundItem)
                }
                CoreDataController().addFormMetaData(context: managedObjectContext, formData: formData)
                AddFormViewModel.shared.isFormHasBeenAdded = (true,UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue))
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
                    if isAccountPremium {
                        circleImageComponentPremium
                    } else {
                        circleImageComponent
                    }
                    
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
                                ImageViewModel.shared.selectedBackgroundImage = selectedBackgroundImage
                            }
                        } else {
                            invalidSelectedPhotoErrorShouldShow = true
                        }
                    }
                }
                .onChange(of: selectedCircleItem){_ in
                    Task{
                        if let data = try? await selectedCircleItem?.loadTransferable(type: Data.self){
                            if let image = UIImage(data: data){
                                selectedCircleImage = Image(uiImage: image)
                                ImageViewModel.shared.selectedCircleImage = selectedCircleImage
                            }
                        } else if !isCameraTookPhoto {
                            invalidSelectedPhotoErrorShouldShow = true
                        }
                    }
                }
                .onChange(of: handledPickedImageData, perform: { cameraData in
                    if let cameraData {
                        if let image = UIImage(data: cameraData){
                            selectedCircleImage = Image(uiImage: image)
                            ImageViewModel.shared.selectedCircleImage = selectedCircleImage
                        }
                    }
                })
                .overlay{
                    if invalidSelectedPhotoErrorShouldShow {
                        getPopUpContent(content: InvalidView(text: "Image format should be jpeg"), extratime: PopUpMessageTimer.onScreenTimeExtended)
                    }
                }
                .onAppear{
                    Task {
                        isAccountPremium = try await AccountManager.shared.getCompanyAccount(userID: UserDefaults.standard.string(forKey: UserConstants.currentUserID.rawValue)!).isPremium ?? false
                    }
                }
            }
            .sheet(isPresented: $showCameraForCircleImagePhoto, content: {
                Camera { image in
                    handlePickedImage(image)
                }
            })
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
