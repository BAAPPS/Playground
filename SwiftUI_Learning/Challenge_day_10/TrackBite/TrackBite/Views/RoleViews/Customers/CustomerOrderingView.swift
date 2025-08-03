//
//  CustomerOrderingView.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import SwiftUI

struct CustomerOrderingView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel
    let restaurant: RestaurantOwnerSnapshotModel
    @State private var selectedOrderType: OrderType = .pickup
    @State private var deliveryAddress: String = ""
    @State private var isPlacingOrder = false
    @State private var orderError: String?
    @State private var showSuccess = false
    
    
    
    func placeOrder() async {
        guard let currentUserId = localAuthVM.currentUser?.id,
              let userId = UUID(uuidString: currentUserId) else {
            orderError = "User not logged in."
            return
        }
        guard selectedOrderType == .pickup || !deliveryAddress.trimmingCharacters(in: .whitespaces).isEmpty else {
            orderError = "Please enter a delivery address."
            return
        }
        
        isPlacingOrder = true
        orderError = nil
        
        let newOrder = RestaurantOrderModel(
            id: UUID(),
            customerId:userId,
            restaurantId: restaurant.restaurantId,
            driverId: nil,
            deliveryAddress: deliveryAddress,
            status: .pending,
            estimatedTimeMinutes: nil,
            deliveryFee: nil,
            isPickedUp: false,
            isDelivered: false,
            orderType: selectedOrderType,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        await restaurantOrderViewModel.addCustomerOrder(newOrder)
        
        if let errorMsg = restaurantOrderViewModel.errorMessage {
            orderError = errorMsg
        } else {
            // success: clear form or navigate back
            deliveryAddress = ""
            showSuccess = true
        }
        
        isPlacingOrder = false
    }
    
    var body: some View {
        VStack{
            Picker("Order Type", selection: $selectedOrderType) {
                ForEach(OrderType.allCases) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            TextField("Delivery Address", text: $deliveryAddress)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .frame(maxWidth:.infinity, alignment: .leading)
            
            if let error = orderError {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Button{
                Task{
                    await placeOrder()
                }
            } label: {
                if restaurantOrderViewModel.isLoading || isPlacingOrder {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Place Order")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(selectedOrderType == .delivery && deliveryAddress.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding()
            
            
        }
        .navigationTitle("🛒 Ordering: \(restaurant.restaurantName)")
        .navigationBarTitleDisplayMode(.inline)
        .backButton()
        .alert("Order placed!", isPresented: $showSuccess) {
            Button("OK", role: .cancel) { }
        }
    }
    
}

#Preview {
    let localAuthVM = LocalAuthVM.shared
    let restaurantModel = RestaurantOwnerSnapshotModel(
        id: UUID(),
        userId: UUID(),
        userName: "",
        userEmail: "",
        restaurantId: UUID(),
        restaurantName: "",
        snapshotCreatedAt: Date(),
        description: "",
        imageURL: "",
        address: "",
        phone: ""
    )
    
    let restaurantOrderViewModel = RestaurantOrderViewModel(orderModel: RestaurantOrderModel(id: UUID(), customerId: UUID(), restaurantId: UUID(), driverId: UUID(), deliveryAddress: "", status: .inProgress, estimatedTimeMinutes: 0, deliveryFee: 8.0, isPickedUp: false, isDelivered: false, orderType: .pickup, createdAt: Date(), updatedAt: Date()))
    
    CustomerOrderingView(restaurant: restaurantModel)
        .environment(localAuthVM)
        .environment(restaurantOrderViewModel)
}
