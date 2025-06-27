//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by D F on 6/27/25.
//

import SwiftUI


struct AddressView: View {
    @Bindable var order: OrderModel
    @State private var showingCheckout = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.streetAddress)
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }

                Section {
                    Button("Check out") {
                        order.save()      // Save order here
                        showingCheckout = true
                    }
                    .disabled(order.hasValidAddress == false)
                }
            }
            .navigationTitle("Delivery details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showingCheckout) {
                CheckoutView(order: order)
            }
        }
    }
}

#Preview {
    AddressView(order: OrderModel())
}
