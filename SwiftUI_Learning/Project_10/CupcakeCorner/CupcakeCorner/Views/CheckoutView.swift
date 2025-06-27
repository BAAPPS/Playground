//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by DF on 06/27/2025.
//

import SwiftUI

struct CheckoutView: View {
    var order: OrderModel

    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var errorMessage = ""
    @State private var showingError = false


    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }.alert("Error", isPresented: $showingError) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }

    }

    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "POST"

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

            // 🟡 Debug: Show raw JSON response as a string
            if let rawString = String(data: data, encoding: .utf8) {
                print("✅ Raw Response JSON:\n\(rawString)")
            } else {
                print("⚠️ Could not decode response as a string")
            }

//            // Just show a dummy confirmation message for now
//            confirmationMessage = "Your order was placed successfully (response logged in Xcode)"
//            showingConfirmation = true
            
            let decodedOrder = try JSONDecoder().decode(OrderResponse.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(OrderModel.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            errorMessage = "Order failed: \(error.localizedDescription)"
              showingError = true
        }
    }

}

#Preview {
    CheckoutView(order: OrderModel())
}
