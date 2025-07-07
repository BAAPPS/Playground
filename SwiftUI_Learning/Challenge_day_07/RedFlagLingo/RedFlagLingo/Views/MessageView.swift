//
//  MessageView.swift
//  RedFlagLingo
//
//  Created by D F on 7/6/25.
//

import SwiftUI

struct MessageView: View {
    let messages:[MessageModel]
    var body: some View {
        List{
            ForEach(messages.sorted(by:{$0.date < $1.date})) { message in
                VStack(alignment: .leading, spacing:10) {
                    Text(message.sender?.username ?? "Unknown")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(message.content)
                        .font(.body)
                        .foregroundColor(message.isFlagged ? .red : .primary)
                    
                    Text(message.date.formatted())
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    if let alert = message.scamAlertMessage {
                        Text("⚠️ \(alert)")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 2)
                        
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Conversation")
    }
    
}
#Preview {
    MessageView(messages:[
        MessageModel(
           content: "You’ve won a free crypto investment!",
           date: Date(),
           isFlagged: true,
           scamAlertMessage: "This message appears to be a phishing scam."
       ),
        MessageModel(
           content: "Hey",
           date: Date(),
           isFlagged: false
       )
    ])
}
