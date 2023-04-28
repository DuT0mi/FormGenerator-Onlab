import Foundation
import UIKit
import FirebaseStorage

@MainActor
final class FirebaseStorageManager {
    
    private init() {  }
    static let shared: FirebaseStorageManager = FirebaseStorageManager()
    
    private let storage = Storage.storage().reference()
    
    private func formImageReference(formID id: String) -> StorageReference {
        storage.child("forms").child(id).child("images").child("background_images")
    }
    private func formPremiumImageReference(formID id: String) -> StorageReference {
        storage.child("forms").child(id).child("images").child("premium_circle_images")
    }
    
    
    func saveImage(data: Data, formID: String) async throws  -> (path: String, name: String){
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await formImageReference(formID: formID).child(path).putDataAsync(data, metadata: meta)
        guard let returnedPath = returnedMetaData.path,let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }
    func savePremiumImage(data: Data, formID: String) async throws  -> (path: String, name: String){
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await formPremiumImageReference(formID: formID).child(path).putDataAsync(data, metadata: meta)
        guard let returnedPath = returnedMetaData.path,let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }
    func saveImage(image: UIImage, formID: String) async throws  -> (path: String, name: String){
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw AppErrors.Storage.jpegCompressionFailed
        }
        return try await saveImage(data: data, formID: formID)
    }
    
    func getData(formID: String, path: String) async throws -> Data {
        try await formImageReference(formID: formID).child(path).data(maxSize: Int64.max)        
    }
    func getPremiumData(formID: String, path: String) async throws -> Data {
        try await formPremiumImageReference(formID: formID).child(path).data(maxSize: Int64.max)
    }
    
    func getPathForImage(path: String ) -> StorageReference{
        Storage.storage().reference(withPath: path)
    }
    func getUrlForImage(path: String) async throws  -> URL{
        try await getPathForImage(path: path).downloadURL()
    }
    
    // MARK: - Not used but can be handy for someone/or later
    func getImage(formID: String, path: String) async throws -> UIImage {
        let data = try await getData(formID: formID, path: path)
        guard let image = UIImage(data: data) else {
            throw AppErrors.Storage.imageDoesNotExist
        }
        return image
    }
    func deleteImage(path: String) async throws {
        try await getPathForImage(path: path).delete()
    }
}
