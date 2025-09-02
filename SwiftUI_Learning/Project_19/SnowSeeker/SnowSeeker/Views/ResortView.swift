//
//  ResortView.swift
//  SnowSeeker
//
//  Created by D F on 9/2/25.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(FavoritesVM.self) var favorites
    @Environment(ResortVM.self) var vm

    @State private var selectedFacility: FacilityModel?
    @State private var showingFacility = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: vm.resort.id)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        Text("Photo: \(vm.resort.imageCredit)")
                            .font(.caption2)
                            .padding(4)
                            .background(Color.black.opacity(0.6))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding(6),
                        alignment: .bottomTrailing
                    )
                
                HStack {
                    if horizontalSizeClass == .compact && dynamicTypeSize > .large {
                        VStack(spacing: 10) { ResortDetailsView() }
                        VStack(spacing: 10) { SkiDetailsView() }
                    } else {
                        ResortDetailsView()
                        SkiDetailsView()
                    }
                }
                .padding(.vertical)
                .background(.primary.opacity(0.1))
                
                Group {
                    Text(vm.resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack {
                        ForEach(vm.resort.facilityTypes) { facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            
            Button(favorites.contains(vm.resort) ? "Remove from Favorites" : "Add to Favorites") {
                if favorites.contains(vm.resort) {
                    favorites.remove(vm.resort)
                } else {
                    favorites.add(vm.resort)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("\(vm.resort.name), \(vm.resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
    }
}

#Preview {
    ResortView()
        .environment(FavoritesVM())
        .environment(ResortVM(resort: .example))
}
