//
//  AvailabilityView.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import SwiftUI

struct AvailabilityView: View {
    var step: DriverOnboardingStep = .vehicleType
    var onNext: () -> Void
    
    @Binding var availability: String
    

    let options = ["Available", "Busy", "Offline"]
    
    var body: some View {
        VStack(spacing: 24) {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer()
                    
                    Text("What's your availability?")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                        .foregroundColor(.offWhite)
                    
                    Picker("Availability", selection: $availability) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal)
                    
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
        .onboardingNavigation(title: "Availability", progress: step.progressText)
    }
}

#Preview {
    NavigationStack {
        AvailabilityView(step: .availability,
                         onNext: {},
                         availability: .constant("Available")
        )
    }
}
