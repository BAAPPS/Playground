//
//  DriverVM.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import Foundation
import Observation

@Observable
class DriverVM {
    var isLoading = false
    var errorMessage: String?
    private let client = SupabaseManager.shared.client
    
    var driverModel: DriverModel
    
    init(driverModel: DriverModel) {
        self.driverModel = driverModel
    }
    
    var vehicle: DriverModel.Vehicle?
    var licensePlate: String = ""
    var isAvailable: Bool = false
    
    func onboardingComplete() async {
        guard let vehicle = vehicle else {
            errorMessage = "Vehicle data incomplete"
            return
        }
        isLoading = true
        errorMessage = nil
        
        do {
            let payload = DriverModel.DriverUpdatePayload(vehicle: vehicle, licensePlate: licensePlate, isAvailable: isAvailable)
            
            try await client
                .from("drivers")
                .update(payload)
                .eq("id", value:driverModel.id.uuidString)
                .execute()
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
}
