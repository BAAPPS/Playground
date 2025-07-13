//
//  ViewModifers.swift
//  UserBoard
//
//  Created by D F on 7/13/25.
//

import Foundation
import SwiftUI


struct CustomTextField:View{
    let name: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textColor: Color = .white
    var body: some View{
        TextField(name, text: $text)
            .foregroundColor(textColor)
            .textInputAutocapitalization(.never)
            .keyboardType(keyboardType)
            .autocorrectionDisabled(true)
            .padding(.horizontal, 12)
            .frame(width: 300, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
            )
        
    }
}

struct CustomHeaderView: View {
    let title: String
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Divider()
                .background(Color.white.opacity(0.8))
        }
        .padding()
        .background(Color.black.opacity(0.5))
    }
}
