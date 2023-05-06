import SwiftUI
import UIKit
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
    func startIfExists(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        /// Instead of using that
        ///  <
        ///     guard let lastDocument else {return self}
        ///     ...
        ///  >
        if let lastDocument {
            return self
                .start(afterDocument: lastDocument)
        } else {
            return self
        }
    }
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (forms: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        
        let products =  try snapshot.documents.map({document in
            try document.data(as: T.self)
        })
        return (products, snapshot.documents.last)
    }
    func aggregationCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
}

struct AnimatedActionButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if title != nil && systemImage != nil {
                Label(title!, systemImage: systemImage!)
            } else if title != nil {
                Text(title!)
            } else if systemImage != nil {
                Image(systemName: systemImage!)
            }
        }
    }
}
@MainActor
 func topViewController(controller: UIViewController? = nil) -> UIViewController? {
     let controller = controller ?? UIApplication
         .shared
         .connectedScenes
         .compactMap { ($0 as? UIWindowScene)?.keyWindow }
         .last?.rootViewController
     
    if let navigationController = controller as? UINavigationController {
        return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
    }
    if let presented = controller?.presentedViewController {
        return topViewController(controller: presented)
    }
    return controller
}
// MARK: XOR
extension Bool {
    static func ^(lhs: Bool, rhs: Bool) -> Bool {
        return lhs != rhs
    }
}
