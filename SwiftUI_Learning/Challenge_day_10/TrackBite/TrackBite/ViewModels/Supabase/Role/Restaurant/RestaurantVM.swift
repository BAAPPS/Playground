//
//  RestaurantVM.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import Foundation
import Observation
import MapKit
import CoreLocation

struct EquatableCoordinate: Equatable {
    let coordinate: CLLocationCoordinate2D
    
    static func == (lhs: EquatableCoordinate, rhs: EquatableCoordinate) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

@Observable
class RestaurantVM {
    var isLoading = false
    var errorMessage: String?
    private let client = SupabaseManager.shared.client
    private let geocoder = CLGeocoder()
    private var geocodeWorkItem: DispatchWorkItem?
    var restaurantModel: RestaurantModel
    

    init(restaurantModel: RestaurantModel) {
        self.restaurantModel = restaurantModel
        self.name = restaurantModel.name
        self.description = restaurantModel.description
        self.imageURL = restaurantModel.imageURL
        self.address = restaurantModel.address
        self.latitude = restaurantModel.latitude
        self.longitude = restaurantModel.longitude
        self.phone = restaurantModel.phone
    }
    
    
    var name: String = ""
    var description: String? = ""
    var imageURL: String? = ""
    var address: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var phone: String? = ""
    
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    var equatableCoordinate: EquatableCoordinate {
        EquatableCoordinate(coordinate: coordinate)
    }
    
    func geocode(address: String) {
        // Cancel previous pending geocode work
        geocodeWorkItem?.cancel()
        
        // Create new debounce work item
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.geocoder.cancelGeocode()
            self.geocoder.geocodeAddressString(address) { placemarks, error in
                if let error = error {
                    print("Geocoding failed: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let location = placemarks?.first?.location else {
                    self.errorMessage = "No location found for address."
                    return
                }
                
                DispatchQueue.main.async {
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    self.errorMessage = nil
                }
            }
        }
        
        geocodeWorkItem = workItem
        
        // Execute work item after 0.8 seconds delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: workItem)
    }
    
    var onboardingPath: [RestaurantOnboardingStep] = []
    
    func advanceToNextStep(from step: RestaurantOnboardingStep) {
        guard let currentIndex = RestaurantOnboardingStep.allCases.firstIndex(of: step),
              currentIndex + 1 < RestaurantOnboardingStep.allCases.count else { return }
        
        let nextStep = RestaurantOnboardingStep.allCases[currentIndex + 1]
        
        if !onboardingPath.contains(nextStep) {
            onboardingPath.append(nextStep)
        }
    }
    
    
    
    func onboardingComplete() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let payload = RestaurantModel.RestaurantUpdatePayload(name: name, description: description, imageURL: imageURL, address: address, latitude: latitude, longitude: longitude, phone: phone)
            
            print("payload:", payload)
            
            try await client
                .from("restaurants")
                .update(payload)
                .eq("owner_id", value:restaurantModel.ownerID.uuidString)
                .execute()
            
            
        
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
