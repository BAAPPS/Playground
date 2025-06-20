//
//  ContentView.swift
//  PathLog
//
//  Created by D F on 6/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var goalItems = GoalViewModel()
    @State private var showGoalView = false
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(goalItems.goals){ goal in
                    GoalRowView(goal: goal)
                    
                }
                .onDelete(perform: goalItems.removeGoal)
            }
            .navigationTitle("PathLog")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("Add a Goal", systemImage: "plus"){
                    showGoalView = true
                }
            }
        }
        .sheet(isPresented: $showGoalView){
            AddGoalView(goals: goalItems)
        }
    }
    
}

#Preview {
    ContentView()
}
