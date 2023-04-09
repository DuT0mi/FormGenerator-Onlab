import SwiftUI
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift

// Homemade View, makes an oppurtinity to show and unshow the password's field
struct SecureTextField: View {
    @State private var isSecureField: Bool = true
    @Binding var secureText: String
    
    var body: some View {
        HStack {
            if isSecureField {
                SecureField("Password", text: $secureText)
            } else {
                TextField(secureText, text: $secureText)
            }
        }
        .overlay(alignment: .trailing){
            Image(systemName: isSecureField ? "eye.slash" : "eye")
                .onTapGesture {
                    isSecureField.toggle()
                }
        }
    }
    
}

// Reaching the db easily
extension Database {
    class var root: DatabaseReference {
        return database().reference()
    }
}

// For downloading Form's data from the server, and decode
extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable{
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ documentSnapshot in
            try documentSnapshot.data(as: T.self)
        })
    }
}
