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
                .overlay(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: .infinity, height: 40)
                            .foregroundColor(.gray.opacity(0.7))
                            .padding(.top)
                            .overlay(alignment: .leading) {
                                    Text("Form's title")
                                        .font(.headline)
                                        .fontDesign(.serif)
                                        .padding()
                            }
                    }
                .overlay(alignment: .topLeading){
                    Image(systemName: "hand.tap")
                        .padding()
                        .font(.largeTitle)
                }
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    }
}

struct FormItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FormItemView()
                .frame(width: 250)
        }
    }
}
