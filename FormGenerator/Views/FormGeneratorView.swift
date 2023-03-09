//
//  ContentView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 02. 28..
//

import SwiftUI

struct FormGeneratorView: View {
 
    var body: some View {
        VStack{
            MapView()
                .ignoresSafeArea()
                .frame(height: 300)
            CircleImage()
                .offset(y:-130)
                .padding(.bottom, -130)
            VStack(alignment: .leading){
                Text("Demo")
                    .font(.title)
                HStack {
                    Text("Demo_desc")
                        .font(.subheadline)
                    Spacer()
                    Text("Demo2")
                        .font(.subheadline)
                }
                Divider()
                Text("Demo3")
                    .font(.title2)
                Text("Demo3_desc")
            }
            .padding()
            
            Spacer()
        }
    }
   
}
struct FormGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
            FormGeneratorView()
    }
}
    
