//
//  DriversRoleView.swift
//  TrackBite
//
//  Created by D F on 7/29/25.
//

import SwiftUI

struct DriversRoleView: View {
    @Environment(LocalAuthVM.self) var localAuthVM
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let localAuthVM = LocalAuthVM.shared
 
    DriversRoleView()
        .environment(localAuthVM)
}
