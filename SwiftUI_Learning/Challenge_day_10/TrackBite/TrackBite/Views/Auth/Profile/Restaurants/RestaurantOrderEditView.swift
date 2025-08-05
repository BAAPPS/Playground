//
//  RestaurantOrderEditView.swift
//  TrackBite
//
//  Created by D F on 8/5/25.
//

import SwiftUI

struct RestaurantOrderEditView: View {
    @Binding var order: RestaurantOrderModel
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            Form {
                HStack{
                    Text("Order Status")
                        .font(.title2)
                        .frame(maxWidth:.infinity, alignment: .center)
                    
                    Picker("", selection: $order.status) {
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            Text(status.rawValue.capitalized)
                                .tag(status)
                        }
                        
                    }
                }
                .pickerStyle(.menu)
                
            }
            .scrollContentBackground(.hidden)
            .padding(.top, 10)
            .navigationTitle("Edit Order")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(background: .softRose , titleColor: .offWhite)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        Task {
                            let success = await restaurantOrderViewModel.updateCustomerOrder(order)
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
    @Previewable @State var mockOrder =  RestaurantOrderModel(
        id: UUID(),
        customerId: UUID(),
        restaurantId: UUID(),
        driverId: nil,
        deliveryAddress: "",
        status: .completed,
        estimatedTimeMinutes: 10,
        deliveryFee: 0.0,
        isPickedUp: false,
        isDelivered: false,
        orderType: .pickup,
        createdAt: Date().addingTimeInterval(-3600),
        updatedAt: Date()
    )
    let restaurantOrderViewModel = RestaurantOrderViewModel(orderModel: RestaurantOrderModel(id: UUID(), customerId: UUID(), restaurantId: UUID(), driverId: UUID(), deliveryAddress: "", status: .inProgress, estimatedTimeMinutes: 0, deliveryFee: 8.0, isPickedUp: false, isDelivered: false, orderType: .pickup, createdAt: Date(), updatedAt: Date()))
    
    RestaurantOrderEditView(order:$mockOrder)
        .environment(restaurantOrderViewModel)
}
