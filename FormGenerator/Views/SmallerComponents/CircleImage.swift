//
//  CircleImage.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 09..
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("demo_pic")
            .clipShape(Circle())
            .overlay {
                Circle().stroke(Color.black, lineWidth: 5)
            }
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
