//
//  SummaryView.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import SwiftUI

struct SummaryView:  View {
    @Environment(LocalAuthVM.self) var localAuthVM
    var step: DriverOnboardingStep = .vehicleType
    let vehicle: DriverModel.Vehicle?
    let licensePlate: String
    let availability: String
    
    let driverVM: DriverVM
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            if let vehicle = vehicle {
                Section{
                    Text("Vehicle Information")
                        .foregroundColor(.offWhite)
                        .font(.title2)
                    HStack{
                        Text("Make:")
                            .foregroundColor(.offPink)
                            .font(.title3)
                        Text("\(vehicle.make)")
                            .foregroundColor(.offWhite)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 15)
                    
                    HStack{
                        Text("Model:")
                            .foregroundColor(.offPink)
                            .font(.title3)
                        Text("\(vehicle.model)")
                            .foregroundColor(.offWhite)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 15)
                    
                    
                    HStack{
                        Text("Color:")
                            .foregroundColor(.offPink)
                            .font(.title3)
                        Text("\(vehicle.color)")
                            .foregroundColor(.offWhite)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 15)
                    
                    
                    HStack{
                        Text("Type:")
                            .foregroundColor(.offPink)
                            .font(.title3)
                        Text("\(vehicle.type)")
                            .foregroundColor(.offWhite)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 15)
                    
                    
                    HStack{
                        Text("Year:")
                            .foregroundColor(.offPink)
                            .font(.title3)
                        Text("\(String(format: "%d", vehicle.year))")
                            .foregroundColor(.offWhite)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 15)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Section {
                    HStack{
                        Text("License Plate:")
                            .foregroundColor(.offPink)
                            .font(.title3)
                        Text("\(licensePlate)")
                            .foregroundColor(.offWhite)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Section {
                    HStack{
                        Text("Availability:")
                            .foregroundColor(.offPink)
                            .font(.title3)
                        Text("\(availability)")
                            .foregroundColor(.offWhite)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Text("No driver data available")
            }
            
            Spacer()
            Button(action: {
                Task {
                    driverVM.vehicle = vehicle
                    driverVM.licensePlate = licensePlate
                    driverVM.isAvailable = availability == "Available"
                    await driverVM.onboardingComplete()
                    localAuthVM.hasCompletedOnboarding = true
                    print("Set hasCompletedOnboarding to \(localAuthVM.hasCompletedOnboarding)")
                    
                    
                }
            }) {
                Text("Finish")
                    .bold()
                    .foregroundColor(.offWhite)
                    .frame(maxWidth: 200)
                    .padding()
                    .background(Color.softRose)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 5)
                
            }
            
            Spacer()
            Spacer()
            
        }
        .padding()
        .bodyBackground()
        .onboardingNavigation(title: "Confirm", progress: step.progressText)
    }
}

#Preview {
    let driverModel = DriverModel(
        id: UUID(),
        vehicle: DriverModel.Vehicle(
            make: "Toyota",
            model: "Corolla",
            year: 2022,
            color: "White",
            type: "Sedan"
        ),
        licensePlate: "sfsdf43343",
        isAvailable: false,
        createdAt: Date(),
        deletedAt: nil
    )
    
    let driverVM = DriverVM(driverModel: driverModel)
    driverVM.vehicle = driverModel.vehicle
    driverVM.licensePlate = driverModel.licensePlate
    driverVM.isAvailable = driverModel.isAvailable
    
    let localAuthVM = LocalAuthVM.shared
    
    return NavigationStack {
        SummaryView(
            step: .summary,
            vehicle: driverVM.vehicle,
            licensePlate: driverVM.licensePlate,
            availability: driverVM.isAvailable ? "Available" : "Busy",
            driverVM: driverVM,
        )
        .environment(localAuthVM)
    }
}
