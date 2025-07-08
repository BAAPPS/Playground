//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by D F on 7/8/25.
//

import SwiftUI
import SwiftData

struct UsersView: View {
    @Query var users:[User]
    
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]){
        _users = Query(filter: #Predicate<User>{ user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }
    
    var body: some View {
        List(users) { user in
            HStack {
                Text(user.name)
                Spacer()
                Text(String(user.unwrappedJobs.count))
                    .fontWeight(user.unwrappedJobs.count > 1 ? .black : .regular)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(user.unwrappedJobs.count > 1 ? .green : .purple)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
    }
}

#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
