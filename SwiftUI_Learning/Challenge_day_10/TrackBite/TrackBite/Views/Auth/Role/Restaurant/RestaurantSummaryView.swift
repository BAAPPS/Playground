//
//  RestaurantSummaryView.swift
//  TrackBite
//
//  Created by D F on 7/28/25.
//

import SwiftUI
import MapKit

struct RestaurantSummaryView: View {
    @Environment(RestaurantVM.self) var restaurantVME
    @Environment(LocalAuthVM.self) var localAuthVM
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.33182, longitude: -122.03118),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    private func updateCamera(with coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        cameraPosition = .region(region)
    }
    
    var step: RestaurantOnboardingStep = .summary
    var onNext: () -> Void
    
    var body: some View {
        @Bindable var restaurantVM = restaurantVME
        VStack(spacing: 24)
        {
            RestaurantMapView(
                cameraPosition: .constant(cameraPosition),
                annotationCoordinate: restaurantVM.coordinate,
                annotationTitle: restaurantVM.name.isEmpty ? "Restaurant" : restaurantVM.name
            )
            .frame(height: 300)
            .ignoresSafeArea(edges:.top)
            
            
            .onAppear(){
                updateCamera(with: restaurantVM.coordinate)
            }
            
            VStack{
                HStack{
                    Image(systemName: "house")
                        .textStyle(color: .offPink, font: .title2)
                    Text(restaurantVM.name)
                        .textStyle(color: .offWhite, font: .title3)
                }
                .frame(maxWidth:.infinity, alignment: .leading)
                
                HStack{
                    Image(systemName: "pin")
                        .textStyle(color: .offPink, font: .title3)
                        .padding(.top, 5)
                    Text(restaurantVM.address)
                        .textStyle(color: .offWhite, font: .caption)
                    
                }
                .frame(maxWidth:.infinity, alignment: .leading)
                
                if (restaurantVM.description != nil) {
                    VStack{
                        Image(systemName: "text.bubble")
                            .textStyle(color: .offPink, font: .title2)
                            .padding(20)
                        Text(restaurantVM.description ?? "Food")
                            .textStyle(color: .offWhite, font: .title3)
                    }
                }
                
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                Task {
                    await restaurantVM.onboardingComplete()
                    await localAuthVM.markOnboardingCompleteInSupabase()
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
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .bodyBackground()
    }
}

#Preview {
    let localAuthVM = LocalAuthVM.shared
    
    let restaurantVM = RestaurantVM(
        restaurantModel: RestaurantModel(
            id: UUID(),
            name: "Tartine Bakery",
            description: "The best bakery you can ever find in the bay area!",
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
    RestaurantSummaryView(step: .summary, onNext: {})
        .environment(localAuthVM)
        .environment(restaurantVM)
}
