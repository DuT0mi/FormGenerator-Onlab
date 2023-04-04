//
//  FormItemView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 04. 04..
//

import SwiftUI

struct FormItemView: View {
    var body: some View {
        VStack(spacing: .zero){
            Image("form_demo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
            
            VStack(alignment: .leading){
                Text("Nice") // TODO: Make some nice UI element here e.g. pill view
                Text("Title")
                    .font(.system(.body, design: .rounded))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}

struct FormItemView_Previews: PreviewProvider {
    static var previews: some View {
        FormItemView()
            .frame(width: 250)
    }
}
