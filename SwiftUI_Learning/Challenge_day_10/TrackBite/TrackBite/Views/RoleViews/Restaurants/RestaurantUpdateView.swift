//
//  RestaurantUpdateView.swift
//  TrackBite
//
//  Created by D F on 7/30/25.
//

import SwiftUI
import Kingfisher

struct RestaurantUpdateView: View {
    @Environment(RestaurantVM.self) var restaurantVM
    @State private var isEditMode = false
    @State private var editableRestaurant: RestaurantModel
    
    init(restaurant: RestaurantModel) {
        _editableRestaurant = State(initialValue: restaurant)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let urlString = editableRestaurant.imageURL,
               let url = URL(string: urlString),
               !urlString.isEmpty {
                ZStack(alignment: .top) {
                    KFImage(url)
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        }
                        .onFailure { error in
                            print("Kingfisher failed to load image: \(error)")
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                    
                    
                    VStack {
                        if let phone = editableRestaurant.phone {
                            Text(phone)
                                .font(.headline)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(Color.darkRedBackground)
                                .foregroundColor(.offWhite)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding(.top,80)
                        }
                    }
                    .frame(height: 300)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack{
                        Image(systemName: "fork.knife.circle")
                            .foregroundColor(.rose)
                        Text(editableRestaurant.name)
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.8))
                    }
                    Divider()
                        .frame(width: 1, height: 30)
                        .background(Color.gray.opacity(0.2))
                        .padding(.horizontal, 2)
                    HStack{
                        Image(systemName: "location")
                            .foregroundColor(.rose)
                        Text(editableRestaurant.address)
                            .font(.title3)
                            .foregroundColor(.black.opacity(0.8))
                    }
                }
                .padding()
                
                Divider()
                
                if let desc = editableRestaurant.description {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(editableRestaurant.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem{
                Button {
                    isEditMode.toggle()
                    if !isEditMode {
                        if let index = restaurantVM.restaurants.firstIndex(where: { $0.id == editableRestaurant.id }) {
                            restaurantVM.restaurants[index] = editableRestaurant
                        }
                    }
                } label: {
                    Image(systemName: isEditMode ? "checkmark" : "pencil")
                        .foregroundColor(.offWhite)
                }
            }
        }
        .sheet(isPresented: $isEditMode){
            RestaurantEditView(restaurant: $editableRestaurant)
        }
    }
}


#Preview {
     let restaurantModel = RestaurantModel(
        id: UUID(),
        name: "Tartine Bakery",
        description: "The best bakery you can ever find in the bay area!",
        imageURL: "https://plus.unsplash.com/premium_photo-1661953124283-76d0a8436b87?q=80&w=2688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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

    NavigationStack {
        RestaurantUpdateView(restaurant: restaurantModel)
            .environment(restaurantVM)
    }
}
