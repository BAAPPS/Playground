//
//  SplashEditApp.swift
//  SplashEdit
//
//  Created by D F on 7/14/25.
//

import SwiftUI
import SwiftData

@main
struct SplashEditApp: App {
    @State private var authVM = SupabaseAuthViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(authVM: authVM)
                .task{
                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
                    
                    if authVM.networkMonitor.isConnected {
                        await authVM.restoreSession()
                        
                    } else {
                        print("🚫 Skipping restoreSession — no internet")
                        if let cachedUser = authVM.loadCachedUser() {
                            authVM.currentUser = cachedUser
                            print("✅ Loaded cached user in offline mode")
                        }
                    }
                }
        }.modelContainer(for:UsersModel.self)
    }
}
