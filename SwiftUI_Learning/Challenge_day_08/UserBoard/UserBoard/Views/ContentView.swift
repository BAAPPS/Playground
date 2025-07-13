//
//  ContentView.swift
//  UserBoard
//
//  Created by D F on 7/8/25.
//

import SwiftUI

struct ContentView: View {
    @State var authVM: SupabaseAuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing:0){
                Group{
                    if authVM.currentUser == nil {
                        CustomHeaderView(title:"Userboard")
                        AuthView(authVM: authVM)
                    }else{
                        UsersListView(authVM: authVM)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(authVM: SupabaseAuthViewModel())
}
