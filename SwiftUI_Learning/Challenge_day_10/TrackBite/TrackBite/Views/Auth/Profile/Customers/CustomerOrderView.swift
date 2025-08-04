//
//  CustomerOrderView.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import SwiftUI

struct CustomerOrderView: View {
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel
    @State private var customerOrderVM = CustomerOrderVM.shared
    
    
 
    
    var body: some View {
        VStack {
            if customerOrderVM.isLoading {
                ProgressView("Loading Orders...")
            } else if let error = customerOrderVM.errorMessage {
                Text("❌ \(error)")
                    .foregroundColor(.red)
            } else if customerOrderVM.enrichedOrders.isEmpty {
                ContentUnavailableView(
                    "No Orders Yet",
                    systemImage: "cart.badge.questionmark",
                    description: Text("You haven't placed any orders yet. Start browsing restaurants!")
                )
            } else {
                List{
                    ForEach(OrderStatus.allCases, id: \.self) { status in
                        let filtered = customerOrderVM.enrichedOrders.filter { $0.order.status == status }
                        
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
            await customerOrderVM.currentUserOrders()
        }
    }
}

#Preview {
    let restaurantOrderViewModel = RestaurantOrderViewModel(orderModel: RestaurantOrderModel(id: UUID(), customerId: UUID(), restaurantId: UUID(), driverId: UUID(), deliveryAddress: "", status: .inProgress, estimatedTimeMinutes: 0, deliveryFee: 8.0, isPickedUp: false, isDelivered: false, orderType: .pickup, createdAt: Date(), updatedAt: Date()))
    
    
    CustomerOrderView()
        .environment(restaurantOrderViewModel)
}
