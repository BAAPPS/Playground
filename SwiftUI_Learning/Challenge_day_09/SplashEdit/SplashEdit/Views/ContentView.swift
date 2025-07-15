//
//  ContentView.swift
//  SplashEdit
//
//  Created by D F on 7/14/25.
//

import SwiftUI

struct ContentView: View {
    @State var authVM: SupabaseAuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                Group {
                    if authVM.currentUser == nil {
                        AuthSwicherView(authVM: authVM)
                    }else{
                       LoggedInView(authVM: authVM)
                    }
                }
            }
        }
        
    }
}

#Preview {
    let vm = SupabaseAuthViewModel()
    vm.currentUser = SupabaseUsersModel(id: UUID(), username: "MockUser", created_at: Date())
    return ContentView(authVM: vm)
}
