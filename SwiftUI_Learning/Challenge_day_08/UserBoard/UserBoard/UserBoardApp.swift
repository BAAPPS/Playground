//
//  UserBoardApp.swift
//  UserBoard
//
//  Created by D F on 7/8/25.
//

import SwiftUI
import SwiftData

@main
struct UserBoardApp: App {
    
    @State private var authVM = SupabaseAuthViewModel()
    
    init(){
        setUpNavBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(authVM: authVM)
                .task{
                    await authVM.restoreSession()
                }
        }
        .modelContainer(for: UserProfile.self)
    }
}
