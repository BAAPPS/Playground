//
//  UserListRowView.swift
//  UserBoard
//
//  Created by D F on 7/13/25.
//

import SwiftUI

import SwiftUI

struct UserListRowView<T: UserDisplayable & Identifiable>: View {
    var users: [T]

    var body: some View {
        ForEach(users) { user in
            HStack(alignment: .center) {
                Text(user.username)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text(user.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            Divider()
        }
    }
}


#Preview {
    UserListRowView<UserProfile>(users: [
        UserProfile(id: UUID(), username: "TestUser1", created_at: Date()),
        UserProfile(id: UUID(), username: "TestUser2", created_at: Date().addingTimeInterval(-3600))
    ])
    .background(Color.black)  // optional to see text better
}
