//
//  CustomerProfile.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct CustomerProfileSettingView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    @Environment(\.supabaseAuthVM) private var authVM: Bindable<SupabaseAuthVM>?
    @Environment(RestaurantOrderViewModel.self) var restaurantOrderViewModel

    var body: some View {
        VStack{
           Text("Your Settings")
                .font(.system(size: 30, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(.darkRedBackground)
            Spacer()
            
            List {
                NavigationLink {
                    CustomerOrderView()
                        .environment(restaurantOrderViewModel)
                } label: {
                    HStack {
                        Image(systemName: "bag")
                            .foregroundColor(.darkRedBackground)
                        Text("My Orders")
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    
                }
                
                NavigationLink {
                    CustomerUserProfileView()
                        .environment(\.supabaseAuthVM, authVM)
                } label: {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.darkRedBackground)
                    Text("Account")
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .listStyle(.insetGrouped)
            
            Spacer()
        }
        .navigationTitle(localAuthVM.currentUser?.name ?? "\( UserRole.restaurant.displayName)'s Profile")
        .navigationBarTitleDisplayMode(.inline)
    }


}

#Preview {
    let localAuthVM = LocalAuthVM.shared
    
    let restaurantOrderViewModel = RestaurantOrderViewModel(orderModel: RestaurantOrderModel(id: UUID(), customerId: UUID(), restaurantId: UUID(), driverId: UUID(), deliveryAddress: "", status: .inProgress, estimatedTimeMinutes: 0, deliveryFee: 8.0, isPickedUp: false, isDelivered: false, orderType: .pickup, createdAt: Date(), updatedAt: Date()))
    NavigationStack {
        CustomerProfileSettingView()
            .environment(localAuthVM)
            .environment(restaurantOrderViewModel)
    }
}
