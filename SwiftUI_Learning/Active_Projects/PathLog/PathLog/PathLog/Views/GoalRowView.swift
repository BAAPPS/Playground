//
//  GoalRowView.swift
//  PathLog
//
//  Created by D F on 6/20/25.
//

import SwiftUI

struct GoalRowView: View {
    let goal: Goal
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                Text(goal.name)
                    .font(.headline)
                Text("Status: \(goal.status.rawValue)")
                    .font(.title3)
                
                if let dueDate = goal.dueDate {
                    Text("Due Date: \(dueDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                }
                
                if let startDate = goal.startDate{
                    Text("Start Date: \(startDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                }
            }
        }
        
        
    }
}

#Preview {
    GoalRowView(goal: Goal(name: "Test", status: .notStarted))
}
