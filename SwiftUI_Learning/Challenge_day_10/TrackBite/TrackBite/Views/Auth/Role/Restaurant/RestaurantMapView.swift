//
//  RestaurantMapView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI
import MapKit

struct RestaurantMapView: View {
    @Binding var cameraPosition: MapCameraPosition
       var annotationCoordinate: CLLocationCoordinate2D
       var annotationTitle: String
       
       var body: some View {
           Map(position: $cameraPosition) {
               Annotation(annotationTitle, coordinate: annotationCoordinate) {
                   Image(systemName: "fork.knife.circle.fill")
                       .resizable()
                       .frame(width: 32, height: 32)
                       .foregroundColor(.red)
                       .clipShape(Circle())
               }
           }
       }
}

#Preview {
    @Previewable @State var cameraPosition = MapCameraPosition.region(
         MKCoordinateRegion(
             center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
             span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
         )
     )
    RestaurantMapView(
         cameraPosition: $cameraPosition,
         annotationCoordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
         annotationTitle: "San Francisco Restaurant"
     )
}
