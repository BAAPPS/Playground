//
//  UserViewModel.swift
//  RedFlagLingo
//
//  Created by D F on 7/6/25.
//

import Foundation
import SwiftData
import Observation

@Observable
class UserViewModel {
    var users: [UserModel] = []
    var selectedUser: UserModel?
    let context: ModelContext
    
    init (context: ModelContext){
        self.context = context
        loadUsers()
    }
    
    func loadUsers(){
        do {
            users = try context.fetch(FetchDescriptor<UserModel>())
        }catch{
            print("Failed to load users: \(error.localizedDescription)")
        }
    }
    
    func addUser(username: String){
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
             print("⚠️ Username is empty — not adding user.")
             return
         }
        
        let newUser = UserModel(username: username)
        context.insert(newUser)
        do{
            try context.save()
            loadUsers()
        }catch{
            print("Failed to save new user: \(error.localizedDescription)")
        }
        
    }
}

