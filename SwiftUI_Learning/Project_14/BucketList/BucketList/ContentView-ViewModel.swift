//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by D F on 7/22/25.
//

import Foundation
import CoreLocation
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")

        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = false

        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }

        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }

        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
        }

        func update(location: Location) {
            guard let selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
        }

        func authenticate() {
            let context = LAContext()
            var error: NSError?

            #if targetEnvironment(simulator)
            // Bypass biometric auth in simulator
            isUnlocked = true
            #else
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        DispatchQueue.main.async {
                            isUnlocked = true
                        }
                    }
                }
            }
            #endif
        }
    }
}
