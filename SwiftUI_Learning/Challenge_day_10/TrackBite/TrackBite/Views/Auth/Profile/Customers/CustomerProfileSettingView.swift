//
//  CustomerProfile.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct CustomerProfileSettingView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    var body: some View {
        ZStack{
            
        }
        .navigationTitle(localAuthVM.currentUser?.name ?? "\( UserRole.customer.displayName)'s Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

}

#Preview {
    let localAuthVM = LocalAuthVM.shared
    NavigationStack {
        CustomerProfileSettingView()
            .environment(localAuthVM)
    }
}
