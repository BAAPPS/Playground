//
//  LicensePlateView.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import SwiftUI

struct LicensePlateView:  View {
    var step: DriverOnboardingStep = .vehicleType
    var onNext: () -> Void
    
    @Binding var licensePlate: String
    @State private var plate = "DH454JKI"
    
    var body: some View {
        VStack(spacing: 24) {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Spacer()
                    
                    Text("What's your license plate?")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                        .foregroundColor(.offWhite)
                    
                        LabeledTextFieldView(label:"Plate Number", text:$plate)
                        .frame(maxWidth: .infinity, alignment: .center)
                
                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
            }
            .scrollContentBackground(.hidden)
            .frame(maxHeight: .infinity)
            
            Spacer()
            
            Button(action: {
                licensePlate = plate
                onNext()
            }) {
                Text("Next")
                    .bold()
                    .foregroundColor(Color(hex:"#801c20"))
                    .frame(maxWidth: 100)
                    .padding()
                    .background(Color(hex: "#fee2e3"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 5)
                
            }
            
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .bodyBackground()
        .onboardingNavigation(title: "License Plate", progress: step.progressText)
    }
    
    
}
#Preview {
    NavigationStack {
        LicensePlateView(
            step: .licensePlate,
            onNext: {},
            licensePlate: .constant("DH454JKI")
        )
    }
}
