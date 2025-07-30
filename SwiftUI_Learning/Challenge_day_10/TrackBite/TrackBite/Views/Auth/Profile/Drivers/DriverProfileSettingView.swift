//
//  DriverProfileSettingView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct DriverProfileSettingView:  View {
    @Environment(LocalAuthVM.self) var localAuthVM
    var body: some View {
        ZStack{
            
        }
        .navigationTitle(localAuthVM.currentUser?.name ?? "\( UserRole.driver.displayName)'s Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

}

#Preview {
    let localAuthVM = LocalAuthVM.shared
    NavigationStack {
        DriverProfileSettingView()
            .environment(localAuthVM)
    }
}
