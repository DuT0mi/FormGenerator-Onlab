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
    private var coordinates: Coordinates
    
    
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    var image: Image {
        Image(imageName)
    }
    var id: Int
    var description: String
    var name: String
    var place: String
    
    
    
    private struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
