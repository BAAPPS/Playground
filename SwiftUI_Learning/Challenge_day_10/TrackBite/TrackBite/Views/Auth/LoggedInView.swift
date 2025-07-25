//
//  LoggedInView.swift
//  TrackBite
//
//  Created by D F on 7/25/25.
//

import SwiftUI
import SwiftData

struct LoggedInView: View {
    @Bindable var authVM: SupabaseAuthVM
    
    var body: some View {
        Text("Welcome \(LocalAuthVM.shared.currentUser?.email ?? "Unknown User")")
    }
}

#Preview {
    let authVM = SupabaseAuthVM()
    NavigationView {
        LoggedInView(authVM: authVM)
    }
}
