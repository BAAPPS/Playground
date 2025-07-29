//
//  RestaurantLocationView.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import SwiftUI
import MapKit

struct RestaurantAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct RestaurantLocationView: View {
    @Environment(RestaurantVM.self) var restaurantVME
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.33182, longitude: -122.03118),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    @State private var annotations: [RestaurantAnnotation] = []
    
    
    private func updateCamera(with coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        cameraPosition = .region(region)
    }
    
    
    var step: RestaurantOnboardingStep = .restaurantLocationInfo
    var onNext: () -> Void
    var body: some View {
        @Bindable var restaurantVM = restaurantVME
        
        VStack(spacing: 24) {
            RestaurantMapView(cameraPosition: $cameraPosition, annotationCoordinate: restaurantVM.coordinate, annotationTitle: restaurantVM.name)
            .padding(.top, 20)
            .onAppear {
                updateCamera(with: restaurantVM.coordinate)
                annotations = [RestaurantAnnotation(coordinate: restaurantVM.coordinate)]
            }
            .onChange(of: restaurantVM.equatableCoordinate) {oldCoordinates, newCoordinate in
                updateCamera(with: newCoordinate.coordinate)
            }
            VStack(spacing: 24) {
                Text("Restaurant Address")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                    .foregroundColor(.offWhite)
                
                LabeledTextFieldView(label:"Address", text: Binding(
                    get: { restaurantVM.address },
                    set: { newAddress in
                        restaurantVM.address = newAddress
                        restaurantVM.geocode(address: newAddress)
                    }
                ))
            }
            .padding()
            
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
            .padding(.bottom, 50)
            
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .bodyBackground()
        
    }
}


private struct PreviewWrapper: View {
    @State private var restaurantVM = RestaurantVM(
        restaurantModel: RestaurantModel(
            id: UUID(),
            name: "Tartine Bakery",
            description: nil,
            imageURL: nil,
            address: "600 Guerrero St, San Francisco, CA 94110",
            latitude: 37.7615,
            longitude: -122.4241,
            phone: nil,
            website: nil,
            ownerID: UUID(),
            createdAt: Date()
        )
    )
    
    var body: some View {
        RestaurantLocationView(step: .restaurantLocationInfo, onNext: {})
            .environment(restaurantVM)
    }
}

#Preview {
    PreviewWrapper()
}

