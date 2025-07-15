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
                    await authVM.restoreSession()
                }
        }.modelContainer(for:UsersModel.self)
    }
}
