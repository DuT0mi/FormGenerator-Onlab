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
// UIApplication.shared.windows.last { $0.isKeyWindow }
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
