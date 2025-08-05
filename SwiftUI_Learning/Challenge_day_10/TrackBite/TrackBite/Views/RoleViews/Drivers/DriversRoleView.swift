//
//  DriversRoleView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI
import CoreLocation

struct DriversRoleView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(DriversOrdersViewModel.self) var driversOrdersViewModel
    
    @State private var selectedOrder: RestaurantOrderModel?
    @State private var restaurantCoordinate: CLLocationCoordinate2D?
    @State private var customerCoordinate: CLLocationCoordinate2D?
    @State private var isShowingMap = false
    
    func geocodeAddress(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let location = placemarks?.first?.location {
                completion(location.coordinate)
            } else {
                print("Geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if driversOrdersViewModel.restaurantDeliveryOrders.isEmpty {
                        Text("No delivery orders available.")
                            .foregroundColor(.gray)
                            .padding(.top, 100)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(driversOrdersViewModel.restaurantDeliveryOrders, id: \.id) { order in
                            VStack(alignment: .leading, spacing: 8) {
                                if let restaurant = driversOrdersViewModel.restaurant(for: order) {
                                    Text("Delivery from: \(restaurant.address)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                HStack {
                                    Image(systemName: "shippingbox")
                                        .foregroundColor(.rose)
                                    Text("Delivery to")
                                        .font(.headline)
                                    Spacer()
                                    Text(order.status.rawValue.capitalized)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Text(order.deliveryAddress)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                if let fee = order.deliveryFee {
                                    Text("Delivery Fee: $\(fee, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                if let created = order.createdAt {
                                    Text("Created: \(created.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .onTapGesture {
                                // When tapped, fetch coordinates and show map
                                selectedOrder = order
                                restaurantCoordinate = driversOrdersViewModel.restaurantCoordinate(for: order)
                                customerCoordinate = nil
                                
                                if restaurantCoordinate != nil {
                                    geocodeAddress(order.deliveryAddress) { coord in
                                        DispatchQueue.main.async {
                                            customerCoordinate = coord
                                            if coord != nil {
                                                isShowingMap = true
                                            } else {
                                                // Handle geocode failure (optional for now)
                                            }
                                        }
                                    }
                                } else {
                                    // Handle missing restaurant coordinate (optional for now)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: (UIApplication.shared.connectedScenes
                        .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
                        .first ?? 90) + 30) // add 30 for nav bar height
                }
            }
            .navigationTitle("Available Deliveries")
            .scrollContentBackground(.hidden)
            .bodyBackground(color: .lightWhite)
            .navigationBarColor(background: .darkRedBackground , titleColor: .lightWhite)
            .task {
                await driversOrdersViewModel.fetchAllDeliveryOrdersFromAllRestaurants()
            }
            .navigationDestination(isPresented: $isShowingMap) {
                if let restCoord = restaurantCoordinate, let custCoord = customerCoordinate {
                    DeliveryMapSimulatorView(
                        restaurantCoordinate: restCoord,
                        customerCoordinate: custCoord
                    )
                } else {
                    Text("Loading map...")
                }
            }
        }
    }
}

#Preview {
    let localAuthVM = LocalAuthVM.shared
    let driversOrderViewModel = DriversOrdersViewModel(orderModel: RestaurantOrderModel(id: UUID(), customerId: UUID(), restaurantId: UUID(), driverId: UUID(), deliveryAddress: "", status: .inProgress, estimatedTimeMinutes: 0, deliveryFee: 8.0, isPickedUp: false, isDelivered: false, orderType: .pickup, createdAt: Date(), updatedAt: Date()))
    DriversRoleView()
        .environment(localAuthVM)
        .environment(driversOrderViewModel)
}
