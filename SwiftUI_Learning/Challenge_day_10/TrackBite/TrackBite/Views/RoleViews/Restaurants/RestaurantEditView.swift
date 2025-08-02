//
//  RestaurantEditView.swift
//  TrackBite
//
//  Created by D F on 8/1/25.
//

import SwiftUI

struct RestaurantEditView: View {
    @Binding var restaurant: RestaurantModel
    @Environment(RestaurantVM.self) var restaurantVM
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $restaurant.name)
                TextField("Address", text: $restaurant.address)
                TextField("Phone", text: Binding(
                    get: { restaurant.phone ?? "" },
                    set: { restaurant.phone = $0.isEmpty ? nil : $0 }
                ))
                Section(header: Text("Description")) {
                    ZStack(alignment: .topLeading) {
                        // Placeholder
                        if (restaurant.description ?? "").isEmpty {
                            Text("Enter a description...")
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 4)
                        }
                        
                        // Multiline editor
                        TextEditor(text: Binding(
                            get: { restaurant.description ?? "" },
                            set: { restaurant.description = $0.isEmpty ? nil : $0 }
                        ))
                        .frame(minHeight: 100)
                        .padding(.horizontal, 2)
                    }
                }
                
            }
            .scrollContentBackground(.hidden)
            .padding(.top, 10)
            .navigationTitle("Edit Restaurant")
            .navigationBarColor(background: .softRose , titleColor: .offWhite)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        Task {
                            let success = await restaurantVM.updateRestaurant(restaurant)
                            if success {
                                dismiss()
                            }
                        }
                    }) {
                        Text("Save")
                            .foregroundColor(.offWhite) 
                    }
                }
            }

        }
    }
}


#Preview {
    @Previewable @State var restaurantModel = RestaurantModel(
        id: UUID(),
        name: "Tartine Bakery",
        description: "The best bakery you can ever find in the bay area!",
        imageURL: "https://plus.unsplash.com/premium_photo-1661953124283-76d0a8436b87?q=80&w=2688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHx8fHx8fA%3D%3D",
        address: "600 Guerrero St, San Francisco, CA 94110",
        latitude: 37.7615,
        longitude: -122.4241,
        phone: "444-444-4444",
        website: nil,
        ownerID: UUID(),
        createdAt: Date()
    )
    
    let restaurantVM = RestaurantVM(
        restaurantModel: RestaurantModel(
            id: UUID(),
            name: "",
            description: nil,
            imageURL: nil,
            address: "",
            latitude: 0.0,
            longitude: 0.0,
            phone: nil,
            website: nil,
            ownerID: UUID(),
            createdAt: Date()
        )
    )
    
    
    RestaurantEditView(restaurant: $restaurantModel)
        .environment(restaurantVM)
}
