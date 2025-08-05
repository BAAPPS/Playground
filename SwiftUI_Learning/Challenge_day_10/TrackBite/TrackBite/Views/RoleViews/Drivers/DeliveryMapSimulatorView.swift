//
//  DeliveryMapSimulatorView.swift
//  TrackBite
//
//  Created by D F on 8/5/25.
//

import SwiftUI
import MapKit

struct SimulatedMapView: View {
    let region: MKCoordinateRegion
    let annotations: [Place]

    var body: some View {
        Map(initialPosition: .region(region)) {
            ForEach(annotations) { place in
                Annotation("",coordinate: place.coordinate) {
                    PlaceAnnotationView(type: place.type)
                }
            }
        }
        .frame(height: 400)
        .cornerRadius(15)
    }
}




struct PlaceAnnotationView: View {
    let type: Place.PlaceType
    
    var body: some View {
        switch type {
        case .driver:
            Image(systemName: "car.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
        case .restaurant:
            Image(systemName: "fork.knife")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.red)
        case .customer:
            Image(systemName: "house.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.green)
        }
    }
}


struct DeliveryMapSimulatorView: View {
    let restaurantCoordinate: CLLocationCoordinate2D
    let customerCoordinate: CLLocationCoordinate2D
    @State private var driverCoordinate: CLLocationCoordinate2D
    @State private var progress: Double = 0
    @State private var timer: Timer?
    
    init(restaurantCoordinate: CLLocationCoordinate2D, customerCoordinate: CLLocationCoordinate2D) {
        self.restaurantCoordinate = restaurantCoordinate
        self.customerCoordinate = customerCoordinate
        _driverCoordinate = State(initialValue: restaurantCoordinate)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            SimulatedMapView(region: region, annotations: annotations)
                .onAppear {
                    startMovingDriver()
                }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .padding(.horizontal)
            
            Text("Delivery Progress: \(Int(progress * 100))%")
                .font(.headline)
                .padding(.bottom, 20)
        }
        .padding()
        .navigationTitle("Delivery Simulator")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            timer?.invalidate()
        }
    }

    
    
    // Center the map between restaurant and customer, zoomed out enough to see both
    var region: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(
            latitude: (restaurantCoordinate.latitude + customerCoordinate.latitude) / 2,
            longitude: (restaurantCoordinate.longitude + customerCoordinate.longitude) / 2)
        
        let latDelta = abs(restaurantCoordinate.latitude - customerCoordinate.latitude) * 2.5
        let lonDelta = abs(restaurantCoordinate.longitude - customerCoordinate.longitude) * 2.5
        
        return MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
    }
    
    // Annotations for Map pins
    var annotations: [Place] {
        [
            Place(id: "restaurant", coordinate: restaurantCoordinate, type: .restaurant),
            Place(id: "customer", coordinate: customerCoordinate, type: .customer),
            Place(id: "driver", coordinate: driverCoordinate, type: .driver)
        ]
    }
    
    func startMovingDriver() {
        // Simulate driver moving from restaurant to customer over 10 seconds updating every 0.1 sec
        let steps = 100
        var currentStep = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
            if currentStep >= steps {
                t.invalidate()
                return
            }
            currentStep += 1
            progress = Double(currentStep) / Double(steps)
            
            // Linear interpolation between restaurant and customer coords
            let lat = restaurantCoordinate.latitude + (customerCoordinate.latitude - restaurantCoordinate.latitude) * progress
            let lon = restaurantCoordinate.longitude + (customerCoordinate.longitude - restaurantCoordinate.longitude) * progress
            driverCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
}



#Preview {
    DeliveryMapSimulatorView(
        restaurantCoordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),  // San Francisco
        customerCoordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094)    // Nearby location
    )
}
