//
//  UtilityExtensions.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 02. 28..
//
import SwiftUI
import FirebaseDatabase

enum Pages: String, CaseIterable, Equatable {
    case login = "login"
    case signup = "signup"
}

// Constants for device's sizes
class ScreenDimensions {
    #if os(iOS) || os(tvOS)
        static var width: CGFloat = UIScreen.main.bounds.size.width
        static var height: CGFloat = UIScreen.main.bounds.size.height
    #elseif os(macOS)
        static var width: CGFloat = NSScreen.main?.visibleFrame.size.width ?? 0
        static var height: CGFloat = NSScreen.main?.visibleFrame.size.height ?? 0
    #endif
}

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


