//
//  DriversOrderView.swift
//  TrackBite
//
//  Created by D F on 8/8/25.
//

import SwiftUI

struct DriversOrderView: View {
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel
    @State private var driversOrderVM = DriversOrdersViewModel.shared
    
    var body: some View {
        VStack {
            if driversOrderVM.isLoading {
                ProgressView("Loading Orders...")
            } else if let error = driversOrderVM.errorMessage {
                Text("❌ \(error)")
                    .foregroundColor(.red)
            } else if driversOrderVM.enrichedOrders.isEmpty {
                ContentUnavailableView(
                    "No Delivery Orders Completed Yet",
                    systemImage: "shippingbox",
                    description: Text("You haven't completed any orders yet. Start delivering!")
                )
            } else {
                List{
                    ForEach(OrderStatus.allCases, id: \.self) { status in
                        let filtered = driversOrderVM.enrichedOrders.filter { $0.order.status == status }
                        
                        if !filtered.isEmpty {
                            HStack{
                                Text("Order:")
                                    .foregroundColor(.black.opacity(0.8))
                                    .font(.title3)
                                Text(status.rawValue.capitalized)
                                    .font(.title3)
                                    .foregroundColor(Color.softRose)
                            }
                            .frame(maxWidth:.infinity, alignment: .center)
                            Divider()
                          
                            ForEach(filtered, id:\.order.id) { (order, restaurant) in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(restaurant.restaurantName)
                                        .font(.headline)
                                        .foregroundColor(Color.darkRedBackground)
                                    Text(restaurant.address)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding(.top, 5)
                                    
                                    if let phone = restaurant.phone {
                                        Text(phone)
                                            .font(.caption)
                                            .foregroundColor(.gray.opacity(0.8))
                                            .padding(.top, 5)
                                    }
                                }
                                .padding(.vertical, 8)
                                .listRowSeparator(.visible)
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .padding(.top, 10)
                .listStyle(.inset)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .navigationTitle("Order Status")
                .backButton()
            }
        }
        .task {
            await driversOrderVM.fetchCurrentDriverOrders()
        }
    }
}

#Preview {
    DriversOrderView()
}
