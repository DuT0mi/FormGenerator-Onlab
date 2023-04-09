//
//  FormViewDetailt.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 04. 04..
//

import SwiftUI

struct FormViewDetail: View {
    var body: some View {
        ScrollView{
            Image("form_demo")
                .resizable()
                .frame(height: 300)
                    
        CompanyCircleView(image: "checkmark")
                .offset(y: -100)
                .padding(.bottom, -100)
            
            LazyVStack(alignment: .leading){
                HStack{
                    Text("Form's title")
                        .font(.title)
                    Text("Favourite btn here")
                }
                
                HStack{
                    Text("Form's type")
                    Spacer()
                    Text("Company")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("Form's description")
                    .font(.title2)
                Text("Description here")
                
                Spacer()
                
            }
            .padding()
            
            Button("Start form"){
                
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .ignoresSafeArea()
    }
}

struct FormViewDetailt_Previews: PreviewProvider {
    static var previews: some View {
        FormViewDetail()
    }
}
