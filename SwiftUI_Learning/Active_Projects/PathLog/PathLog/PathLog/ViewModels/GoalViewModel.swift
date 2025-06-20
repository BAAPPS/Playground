//
//  GoalViewModel.swift
//  PathLog
//
//  Created by D F on 6/20/25.
//

import Foundation
import Observation

@Observable
class GoalViewModel {
    var goals = [Goal](){
        didSet{
            saveGoals()
        }
    }
    init(){
        loadGoals()
    }
    
    func addGoal(_ goal:Goal){
        goals.append(goal)
    }
    
    func removeGoal(at offsets: IndexSet){
        goals.remove(atOffsets: offsets)
    }
    
    private func saveGoals(){
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: "Goals")
        }
    }
    
    private func loadGoals(){
        guard let data = UserDefaults.standard.data(forKey: "Goals"),
           let decoded = try? JSONDecoder().decode([Goal].self, from: data) else {
            goals = []
            return
        }
        goals = decoded
    }
}
