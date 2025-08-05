//
//  RestaurantOrderUpdateView.swift
//  TrackBite
//
//  Created by D F on 8/5/25.
//

import SwiftUI

struct RestaurantOrderUpdateView: View {
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel
    @State private var isEditMode = false
    @State private var editableOrder: RestaurantOrderModel
    
    init(order: RestaurantOrderModel) {
        _editableOrder = State(initialValue: order)
    }
    
    
    var body: some View {
        
        VStack(alignment:.leading, spacing:10){
            
            Spacer()
            
            if editableOrder.orderType == .delivery {
                Text("Delivery Address: \(editableOrder.deliveryAddress)")
                Text("Order Deliver Status: \(editableOrder.isDelivered == true ? "✅ Delivered" : "⏳ Enroute")")
            } else {
                Text("Pickup Order")
                    .foregroundColor(.secondary)
                    .italic()
                Text("Order Pick Status: \(editableOrder.isPickedUp == true ? "✅ Picked up" : "⏳ Awaiting pickup")")
            }
            
            Text("Created: \(editableOrder.createdAt?.formatted(date: .abbreviated, time: .shortened) ?? "N/A")")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Order Status: \(editableOrder.status.rawValue.capitalized)")
        .navigationBarTitleDisplayMode(.inline)
        .backButton(imageName: "chevron.down")
        .onAppear {
            print("✅ Showing update view for order \(editableOrder.id)")
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    isEditMode.toggle()
                    if !isEditMode {
                        if let index = restaurantOrderViewModel.restaurantCustomerOrders.firstIndex(where: { $0.id == editableOrder.id }) {
                            restaurantOrderViewModel.restaurantCustomerOrders[index] = editableOrder
                        }
                    }
                } label: {
                    Image(systemName: isEditMode ? "checkmark" : "pencil")
                        .foregroundColor(.offWhite)
                }
            }
        }
        .sheet(isPresented: $isEditMode, onDismiss: {
            if let index = restaurantOrderViewModel.restaurantCustomerOrders.firstIndex(where: { $0.id == editableOrder.id }) {
                restaurantOrderViewModel.restaurantCustomerOrders[index] = editableOrder
            }
        }) {
            RestaurantOrderEditView(order: $editableOrder)
        }
        
        
        
        
    }
}

#Preview {
    
    let mockOrder =   RestaurantOrderModel(
        id: UUID(),
        customerId: UUID(),
        restaurantId: UUID(),
        driverId: nil,
        deliveryAddress: "",
        status: .completed,
        estimatedTimeMinutes: 10,
        deliveryFee: 0.0,
        isPickedUp: true,
        isDelivered: true,
        orderType: .pickup,
        createdAt: Date().addingTimeInterval(-3600),
        updatedAt: Date()
    )
    let restaurantOrderViewModel = RestaurantOrderViewModel(orderModel: RestaurantOrderModel(id: UUID(), customerId: UUID(), restaurantId: UUID(), driverId: UUID(), deliveryAddress: "", status: .inProgress, estimatedTimeMinutes: 0, deliveryFee: 8.0, isPickedUp: false, isDelivered: false, orderType: .pickup, createdAt: Date(), updatedAt: Date()))
    
    NavigationStack {
        RestaurantOrderUpdateView(order: mockOrder)
            .environment(restaurantOrderViewModel)
    }
}
