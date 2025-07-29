//
//  VehicleTypeView.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import SwiftUI

struct VehicleTypeView: View {
    var step: DriverOnboardingStep = .vehicleType
    var onNext: (DriverModel.Vehicle) -> Void
    
    
    @State private var make = "Honda"
    @State private var model = "Accord"
    @State private var year: Int? = 2025
    @State private var color = "Gray"
    @State private var type = "Sports"
    
    var body: some View {
        VStack(spacing: 24) {
            ScrollView {
                VStack(spacing: 24) {
                    
                    Spacer()
                    
                    Text("What's your vehicle type?")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                        .foregroundColor(.offWhite)
                    
                    HStack(spacing: 16) {
                        LabeledTextFieldView(label:"Make", text:$make)
                        LabeledTextFieldView(label:"Model", text: $model)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack(spacing: 16) {
                        LabeledTextFieldView(label:"Color", text: $color)
                        LabeledTextFieldView(label:"Type", text: $type)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    LabeledTextFieldView(label:"Year", value: $year, formatter: LabeledTextFieldView.intFormatter)
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
                guard let year = year else { return }
                let vehicle = DriverModel.Vehicle(make: make, model: model, year: year, color: color, type: type)
                onNext(vehicle)
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
        .onboardingNavigation(title: "Vehicle Type", progress: step.progressText)
    }
    
    
}


#Preview {
    NavigationStack {
        VehicleTypeView(step: .vehicleType, onNext: {_ in })
    }
}
