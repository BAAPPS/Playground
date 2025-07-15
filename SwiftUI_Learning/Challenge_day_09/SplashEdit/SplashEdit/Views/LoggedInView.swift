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
        ZStack {
                Color(hex: "#edf2f4")
                    .ignoresSafeArea()
            VStack {
                
            }
        }
        .navigationTitle("Welcome, \(authVM.currentUser?.username ?? "Unknown User")")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        LoggedInView(authVM: SupabaseAuthViewModel())
    }
}
