// StepView.swift
// TrackBite
//
// Created by D F on 7/27/25.
//

import SwiftUI

struct StepView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    let step: DriverOnboardingStep
    var onNext: () -> Void = {}

    @Binding var vehicle: DriverModel.Vehicle?
    
    @Binding var licensePlate: String
    
    @Binding var availability: String
    
    @Binding var driverVM: DriverVM
    
    
    var body: some View {
        switch step {
        case .vehicleType:
            VehicleTypeView(step: step) { selectedVehicle in
                vehicle = selectedVehicle
                onNext()
            }

        case .licensePlate:
            LicensePlateView(step: step, onNext: onNext, licensePlate: $licensePlate)

        case .availability:
            AvailabilityView(step: step, onNext: onNext, availability: $availability)

        case .summary:
            SummaryView(step: step, vehicle: vehicle, licensePlate: licensePlate, availability: availability, driverVM: driverVM)
        }
    }
}


struct StepView_Preview: View {
    @State private var vehicle: DriverModel.Vehicle? = nil
    @State private var licensePlate: String = ""
    @State private var availability: String = ""
    
    @State private var driverModel = DriverModel(
        id: UUID(),
        vehicle: DriverModel.Vehicle(
            make: "Toyota",
            model: "Corolla",
            year: 2022,
            color: "White",
            type: "Sedan"
        ),
        licensePlate: "",
        isAvailable: false,
        createdAt: Date(),
        deletedAt: nil
    )

    @State private var driverVM: DriverVM
    
    
    let localAuthVM = LocalAuthVM.shared

    init() {
        let model = DriverModel(
            id: UUID(),
            vehicle: DriverModel.Vehicle(
                make: "Toyota",
                model: "Corolla",
                year: 2022,
                color: "White",
                type: "Sedan"
            ),
            licensePlate: "",
            isAvailable: false,
            createdAt: Date(),
            deletedAt: nil
        )
        _driverVM = State(wrappedValue: DriverVM(driverModel: model))
    }

    var body: some View {
        StepView(
            step: .vehicleType,
            onNext: {
                print("Next tapped")
            },
            vehicle: $vehicle,
            licensePlate: $licensePlate,
            availability: $availability,
            driverVM: $driverVM,
        )
        .environment(localAuthVM)
    }
}

#Preview {
    StepView_Preview()
}

