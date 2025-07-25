//
//  ContentView.swift
//  BucketList
//
//  Created by D F on 7/22/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var viewModel = ViewModel()

    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )

    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
//                            Button {
//                                viewModel.selectedPlace = location
//                            } label: {
//                                Image(systemName: "star.circle")
//                                    .resizable()
//                                    .foregroundStyle(.red)
//                                    .frame(width: 44, height: 44)
//                                    .background(.white)
//                                    .clipShape(.circle)
//                            }
                            Image(systemName: "star.circle")
                                   .resizable()
                                   .foregroundStyle(.red)
                                   .frame(width: 44, height: 44)
                                   .background(.white)
                                   .clipShape(.circle)
                                   .contextMenu {
                                       Button("Edit Location") {
                                           viewModel.selectedPlace = location
                                       }
                                   }
                        }
                    }
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) {
                        viewModel.update(location: $0)
                    }
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}

