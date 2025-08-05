//
//  RestaurantOrdersListView.swift
//  TrackBite
//
//  Created by D F on 8/4/25.
//

import SwiftUI

struct GroupedOrderKey: Hashable {
    let status: OrderStatus
    let type: OrderType
}


struct RestaurantOrdersListView: View {
    
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel
    @State private var selectedOrder: RestaurantOrderModel? = nil
    
    var body: some View {
        List{
            ForEach(OrderStatus.allCases, id:\.self) {status in
                let anyForStatus = OrderType.allCases.contains { type in
                    restaurantOrderViewModel.groupedOrders[GroupedOrderKey(status: status, type: type)]?.isEmpty == false
                }
                
                let statusCapitalized = status.rawValue.capitalized
                
                if anyForStatus {
                    
                    HStack {
                        Text("Orders:")
                        Text(statusCapitalized)
                            .foregroundStyle(Color.softRose)
                        
                    }
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    
                    ForEach(OrderType.allCases, id:\.self) { type  in
                        let key = GroupedOrderKey(status:status, type: type)
                        let orders = restaurantOrderViewModel.groupedOrders[key] ?? []
                        
                        if !orders.isEmpty {
                            VStack(alignment:.leading, spacing:8) {
                                Text(type.displayName)
                                    .font(.headline)
                                    .foregroundColor(status.foregroundDisplayNameColor)
                                
                                Divider()
                                
                                ForEach(Array(orders.enumerated()), id: \.element.id) { index, order in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Button {
                                            selectedOrder = order
                                        } label: {
                                            VStack(alignment: .leading, spacing: 4) {
                                                if order.orderType == .delivery {
                                                    Text("Delivery Address: \(order.deliveryAddress)")
                                                        .foregroundColor(status.foregroundDeliveryTextColor)
                                                        .italic()
                                                } else {
                                                    Text("Pickup Order")
                                                        .foregroundColor(status.foregroundOrderColor)
                                                        .italic()
                                                }
                                                
                                                Text("Created: \(order.createdAt?.formatted(date: .abbreviated, time: .shortened) ?? "N/A")")
                                                    .foregroundColor(status.foregroundCreatedDateColor)
                                            }
                                            .padding(.vertical, 4)
                                        }
                                        
            
                                        if index < orders.count - 1 {
                                            Rectangle()
                                                .fill(Color.offWhite)
                                                .frame(height: 1)
                                        }
                                    }
                                }
                                           
                            }
                            .listRowSeparator(.visible)
                            .listRowBackground(Color.clear)
                            .padding()
                            .background(status.backgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        }
                        
                    }
                }
                
                
            }
        }
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .fullScreenCover(item: $selectedOrder) { order in
            NavigationStack {
                RestaurantOrderUpdateView(order: order)
            }
        }
        
        
    }
}

#Preview {
    let restaurantOrderViewModel = RestaurantOrderViewModel(orderModel: RestaurantOrderModel(
        id: UUID(),
        customerId: UUID(),
        restaurantId: UUID(),
        driverId: UUID(),
        deliveryAddress: "123 Test Ave",
        status: .pending,
        estimatedTimeMinutes: 20,
        deliveryFee: 5.0,
        isPickedUp: false,
        isDelivered: false,
        orderType: .delivery,
        createdAt: Date(),
        updatedAt: Date()
    ))
    
    // Dummy orders
    restaurantOrderViewModel.restaurantCustomerOrders = [
        .init(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "456 Delivery Rd",
            status: .pending,
            estimatedTimeMinutes: 30,
            deliveryFee: 4.0,
            isPickedUp: false,
            isDelivered: false,
            orderType: .delivery,
            createdAt: Date().addingTimeInterval(-3600),
            updatedAt: Date()
        ),
        .init(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "456 Delivery Rd",
            status: .pending,
            estimatedTimeMinutes: 30,
            deliveryFee: 4.0,
            isPickedUp: false,
            isDelivered: false,
            orderType: .delivery,
            createdAt: Date().addingTimeInterval(-3600),
            updatedAt: Date()
        ),
        .init(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "",
            status: .cancelled,
            estimatedTimeMinutes: 15,
            deliveryFee: 0.0,
            isPickedUp: true,
            isDelivered: false,
            orderType: .pickup,
            createdAt: Date().addingTimeInterval(-7200),
            updatedAt: Date()
        ),
        .init(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "789 Done Blvd",
            status: .completed,
            estimatedTimeMinutes: 0,
            deliveryFee: 0.0,
            isPickedUp: true,
            isDelivered: true,
            orderType: .pickup,
            createdAt: Date().addingTimeInterval(-14400),
            updatedAt: Date()
        ),
        .init(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "789 Done Blvd",
            status: .inProgress,
            estimatedTimeMinutes: 0,
            deliveryFee: 0.0,
            isPickedUp: true,
            isDelivered: true,
            orderType: .pickup,
            createdAt: Date().addingTimeInterval(-14400),
            updatedAt: Date()
        ),
        .init(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "789 Done Blvd",
            status: .inProgress,
            estimatedTimeMinutes: 0,
            deliveryFee: 0.0,
            isPickedUp: true,
            isDelivered: true,
            orderType: .delivery,
            createdAt: Date().addingTimeInterval(-14400),
            updatedAt: Date()
        ),
        .init(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "789 Done Blvd",
            status: .completed,
            estimatedTimeMinutes: 0,
            deliveryFee: 0.0,
            isPickedUp: true,
            isDelivered: true,
            orderType: .delivery,
            createdAt: Date().addingTimeInterval(-14400),
            updatedAt: Date()
        ),
        .init(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "789 Done Blvd",
            status: .cancelled,
            estimatedTimeMinutes: 0,
            deliveryFee: 0.0,
            isPickedUp: true,
            isDelivered: true,
            orderType: .delivery,
            createdAt: Date().addingTimeInterval(-14400),
            updatedAt: Date()
        ),
        .init(
            id: UUID(),
            customerId: UUID(),
            restaurantId: UUID(),
            driverId: nil,
            deliveryAddress: "789 Done Blvd",
            status: .pending,
            estimatedTimeMinutes: 0,
            deliveryFee: 0.0,
            isPickedUp: true,
            isDelivered: true,
            orderType: .pickup,
            createdAt: Date().addingTimeInterval(-14400),
            updatedAt: Date()
        )
    ]
    
    return NavigationStack {
        RestaurantOrdersListView()
            .environment(restaurantOrderViewModel)
    }
}
