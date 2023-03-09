//
//  FormModel.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 09..
//

import Foundation
import SwiftUI
import CoreLocation


struct FormModel: Hashable, Codable {
    private var imageName: String
    
    var image: Image {
        Image(imageName)
    }
    var id: Int
    var description: String
    var name: String
    var place: String
}
