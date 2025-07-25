//
//  ReusableViews.swift
//  TrackBite
//
//  Created by D F on 7/25/25.
//

import Foundation

import SwiftUI

struct CustomTextField: View{
    let name: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textColor = Color(hex:"#fef2f2")
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
    var textColor = Color(hex:"#fef2f2")
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
    var textColor = Color(hex:"#fef2f2")
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

