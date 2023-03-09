//
//  MapView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 09..
//

// TODO: API call for custom

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.497913, longitude: 19.040236),
        span:MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
