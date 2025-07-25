//
//  ContentView.swift
//  TrackBite
//
//  Created by D F on 7/23/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var authVM: SupabaseAuthVM
    
    @State private var localAuthVM = LocalAuthVM.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Group {
                    if localAuthVM.currentUser != nil {
                        LoggedInView(authVM: authVM)
                    } else {
                        AuthSwitcherView(authVM: authVM)
                    }
                }
            }
        }
        .onAppear {
            localAuthVM.modelContext = modelContext
            localAuthVM.debugPrintAllLocalUsers()
        }
    }
}

#Preview {
    let authVM = SupabaseAuthVM()
    ContentView(authVM: authVM)
}
