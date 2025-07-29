//
//  LabelTextFieldView.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import SwiftUI

struct LabeledTextFieldView: View {
    let label: String
    @Binding var text: String?
    @Binding var value: Int?
    var formatter: NumberFormatter?
    
    static let intFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()

    
    init(label: String, text: Binding<String?>) {
        self.label = label
        self._text = text
        self._value = .constant(nil)
        self.formatter = nil
    }
    
    init(label: String, value: Binding<Int?>, formatter: NumberFormatter? = nil) {
        self.label = label
        self._text = .constant(nil)
        self._value = value
        self.formatter = formatter
    }
    
    init(label: String, text: Binding<String>) {
        self.label = label
        self._text = Binding(
            get: { text.wrappedValue },
            set: { text.wrappedValue = $0 ?? "" }
        )
        self._value = .constant(nil)
        self.formatter = nil
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.offWhite)
                .font(.title3)
                .fontWeight(.medium)
            
            if let formatter {
                TextField("", value: Binding(get: {
                    value ?? 0
                }, set: {
                    value = $0
                }), formatter: formatter)
                .keyboardType(.numberPad)
                .padding(10)
                .accentColor(.offWhite)
                .foregroundColor(.offWhite)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.lightPinkBorder, lineWidth: 2)
                )
                .cornerRadius(8)
            }
            else if text != nil {
                TextField("", text: Binding(get: {
                    text ?? ""
                }, set: {
                    text = $0
                }))
                .padding(10)
                .accentColor(.offWhite)
                .foregroundColor(.offWhite)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.lightPinkBorder, lineWidth: 2)
                )
                .cornerRadius(8)
            }
        }
    }
}


#Preview {
    @Previewable @State var value: Int? = 2025
    ZStack {
        LabeledTextFieldView(label: "Year", value: $value, formatter: LabeledTextFieldView.intFormatter)
    }
    .bodyBackground()
}

