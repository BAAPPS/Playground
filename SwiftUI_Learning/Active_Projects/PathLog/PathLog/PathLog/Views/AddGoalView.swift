//
//  AddGoalsView.swift
//  PathLog
//
//  Created by D F on 6/20/25.
//

import SwiftUI

struct AddGoalView: View {
    
    var goals: GoalViewModel
    @State private var name = ""
    @State private var status: GoalStatus = .notStarted
    @State private var dueDate: Date? = nil
    @State private var hasDueDate = false
    @State private var startDate: Date? = nil
    @State private var hasStartDate = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            Form{
                Section(){
                    VStack{
                        Text("Goal Details")
                            .foregroundColor(.gray)
                        TextField("Goal Name", text: $name)
                            .textInputAutocapitalization(.never)
                            .autocapitalization(.none)
                    }
                }
                Section {
                    VStack(spacing: 0) {
                        Text("Select Goal Status")
                            .foregroundColor(.gray)
                        Picker("", selection: $status){
                            ForEach(GoalStatus.allCases, id: \.self) {status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height:100)
                        .clipped()
                    }
                }
                
                Section {
                    Toggle("Set Due Date", isOn: $hasDueDate)
                    if hasDueDate {
                        HStack {
                            DatePicker("Due Date", selection: Binding(
                                get:{
                                    dueDate ?? Date()
                                },
                                set:{
                                    dueDate = $0
                                }
                            ), displayedComponents: .date)
                            
                            Button(action: {
                                dueDate = nil
                            }){
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Toggle("Set Start Date", isOn: $hasStartDate)

                    if hasStartDate {
                        HStack {
                            DatePicker("Start Date", selection: Binding(
                                get:{
                                    startDate ?? Date()
                                },
                                set:{
                                    startDate = $0
                                }
                            ), displayedComponents: .date)
                            
                            Button(action: {
                                startDate = nil
                            }){
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(5)
            }
            .navigationTitle("Add New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("Add Goal"){
                    let newGoal = Goal(name:name, status: status, dueDate: hasDueDate ? dueDate : nil, startDate: hasStartDate ? startDate : nil)
                    goals.addGoal(newGoal)
                    dismiss()
                }
                .foregroundColor(.blue)
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
}

#Preview {
    AddGoalView(goals: GoalViewModel())
}
