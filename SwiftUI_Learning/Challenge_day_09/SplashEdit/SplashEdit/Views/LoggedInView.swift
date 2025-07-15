//
//  LoggedInView.swift
//  SplashEdit
//
//  Created by D F on 7/15/25.
//

import SwiftUI

struct LoggedInView: View {
    @Bindable var authVM: SupabaseAuthViewModel
    
    var body: some View {
        VStack {
            Text("Welcome, \(authVM.currentUser?.username ?? "Unknown User")")
                .font(.largeTitle)
                .padding()
        }
    }
}

#Preview {
    LoggedInView(authVM: SupabaseAuthViewModel())
}
