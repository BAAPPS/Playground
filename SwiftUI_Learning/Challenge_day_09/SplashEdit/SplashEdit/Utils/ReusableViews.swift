//
//  ReusableViews.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import Foundation
import SwiftUI

struct CustomTextField: View{
    let name: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textColor = Color(hex:"#30434a")
    var body: some View {
        TextField(name, text: $text)
            .foregroundColor(textColor)
            .textInputAutocapitalization(.never)
            .keyboardType(keyboardType)
            .autocorrectionDisabled(true)
            .padding(.horizontal, 16)
            .frame(width:300, height:50)
            .background(RoundedRectangle(cornerRadius:8).stroke(Color.white.opacity(0.5), lineWidth: 2))
    }
}

struct PasswordTextField: View{
    let name: String
    @Binding var text: String
    var textColor = Color(hex:"#30434a")
    var body: some View {
        SecureField(name, text: $text)
            .foregroundColor(textColor)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .padding(.horizontal, 16)
            .frame(width:300, height:50)
            .background(RoundedRectangle(cornerRadius:8).stroke(Color.white.opacity(0.5), lineWidth: 2))
    }
}

struct ReusableTaskButton: View{
    let name: String
    let action: () async  -> Void
    var textColor = Color(hex:"#d3e0e4")
    var bgColor = Color(hex: "#4b737e")
    var body: some View {
        Button{
            Task {
                await action()
            }
        } label:{
            Text(name)
                .foregroundColor(textColor)
                .padding(.horizontal, 16)
                .frame(width:300, height:50)
                .background(bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 3)
        }
    }
}

struct AsyncImageLoader: View {
    let urlString:String
    var cornerRadius: CGFloat = 16
     var shadowRadius: CGFloat = 5
     var contentMode: ContentMode = .fit
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .cornerRadius(cornerRadius)
                    .shadow(radius: shadowRadius)
            case .failure:
                EmptyView()
            @unknown default:
                EmptyView()
            }
        }
    }
}
