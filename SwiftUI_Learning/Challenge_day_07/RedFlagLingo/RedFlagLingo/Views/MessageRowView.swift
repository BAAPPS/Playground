//
//  MessageRowView.swift
//  RedFlagLingo
//
//  Created by D F on 7/7/25.
//

import SwiftUI

struct MessageRowView: View {
    let message: MessageModel
    var body: some View {
            VStack(alignment: .leading, spacing:10) {
                Text(message.sender?.username ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.isFlagged ? .red : .white)
                Text(message.date.formatted())
                    .font(.caption2)
                    .foregroundColor(.white)
                if let alert = message.scamAlertMessage {
                    Text("⚠️ \(alert)")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            .padding(20)
            .background(Color(hex: "#2c313a"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .listRowBackground(Color(hex: "#2c313a"))
    }
}
#Preview {
    
    MessageRowView(message: MessageModel(
        content: "You've won a free iPhone!",
        date: Date(),
        isFlagged: true,
        sender: UserModel(username: "Scammer"),
        receiver: UserModel(username: "You"),
        scamAlertMessage: "This message appears to be a phishing scam.",
    ))
}
