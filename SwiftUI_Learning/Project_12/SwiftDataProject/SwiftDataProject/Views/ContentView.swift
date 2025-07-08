//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by D F on 7/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<User> { user in
        user.name.localizedStandardContains("R") && user.city == "London"
    }, sort: \User.name) var users: [User]
    @State private var showingUpcomingOnly = false
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate)
    ]
    
    var body: some View {
        NavigationStack {
            
            UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
                .navigationTitle("Users")
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Add Samples", systemImage: "plus") {
                            try? modelContext.delete(model: User.self)
                            
                            let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                            let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                            let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                            let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
                            
                            let job1 = Job(name: "Organize sock drawer", priority: 3)
                            let job2 = Job(name: "Make plans with Alex", priority: 4)

                            
                            modelContext.insert(first)
                            modelContext.insert(second)
                            modelContext.insert(third)
                            modelContext.insert(fourth)
                            
                            first.jobs?.append(job1)
                            second.jobs?.append(job2)
                        }
                        
                    }
                    
                    ToolbarItem(placement: .automatic){
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder){
                                Text("Sort by Name")
                                    .tag([
                                        SortDescriptor(\User.name),
                                        SortDescriptor(\User.joinDate)
                                    ])
                                Text("Sort by Join Date")
                                    .tag([
                                        SortDescriptor(\User.joinDate),
                                        SortDescriptor(\User.name)
                                    ])
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading){
                        Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                            showingUpcomingOnly.toggle()
                        }
                        
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: User.self)
}
