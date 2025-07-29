//
//  DriverOnboardingView.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import SwiftUI
import SwiftUI

struct DriverOnboardingView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @State private var path: [DriverOnboardingStep] = []
    @State private var vehicle: DriverModel.Vehicle? = nil
    @State private var licensePlate = ""
    @State private var availability = ""
    
    
    @State private var driverVM: DriverVM = DriverVM(
        driverModel: DriverModel(
            id: UUID(), // temp UUID
            vehicle: .init(make: "", model: "", year: 0, color: "", type: ""),
            licensePlate: "",
            isAvailable: false,
            createdAt: Date(),
            deletedAt: nil
        )
    )
    
    
    var body: some View {
        NavigationStack(path: $path) {
            StepView(step: .vehicleType, onNext: {
                path.append(.licensePlate)
            }, vehicle: $vehicle,
                     licensePlate: $licensePlate,
                     availability: $availability,
                     driverVM: $driverVM)
            .navigationDestination(for: DriverOnboardingStep.self) { step in
                StepView(step: step, onNext: {
                    if let currentIndex = DriverOnboardingStep.allCases.firstIndex(of: step),
                       currentIndex + 1 < DriverOnboardingStep.allCases.count {
                        path.append(DriverOnboardingStep.allCases[currentIndex + 1])
                    }
                }, vehicle: $vehicle,
                         licensePlate: $licensePlate,
                         availability: $availability,
                         driverVM: $driverVM)
            }
            .bodyBackground()
        }
        .onAppear {
            let userUUID = UUID(uuidString: localAuthVM.currentUser?.id ?? "") ?? UUID()
            let model = DriverModel(
                id: userUUID,
                vehicle: DriverModel.Vehicle(make: "", model: "", year: 0, color: "", type: ""),
                licensePlate: "",
                isAvailable: false,
                createdAt: Date(),
                deletedAt: nil
            )
            driverVM = DriverVM(driverModel: model)
        }
    }
}

#Preview {
    
    let localAuthVM = LocalAuthVM.shared
    NavigationStack {
        DriverOnboardingView()
            .environment(localAuthVM)
    }
}
