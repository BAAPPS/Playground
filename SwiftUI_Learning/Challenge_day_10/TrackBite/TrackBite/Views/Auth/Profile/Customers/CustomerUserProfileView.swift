//
//  CustomerUserProfileView.swift
//  TrackBite
//
//  Created by D F on 8/3/25.
//

import SwiftUI

struct CustomerUserProfileView: View {
    @Environment(\.supabaseAuthVM) private var authVM: Bindable<SupabaseAuthVM>?

    var body: some View {
        VStack{
            Text("Account Update Page")
        }
        .navigationTitle("Update Account")
    }
}

#Preview {
    CustomerUserProfileView()
}
