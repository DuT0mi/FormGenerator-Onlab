//
//  SuccessPopUpView.swift
//  FormGenerator
//
//  Created by Dudas Tamas Alex on 2023. 03. 15..
//

import SwiftUI


struct SuccessPopUpView: View {
    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(.largeTitle, design: .rounded).bold())
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        
    }
}

struct SuccessPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessPopUpView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(.blue)
            .preferredColorScheme(.dark)
    }
}

// checkmark
