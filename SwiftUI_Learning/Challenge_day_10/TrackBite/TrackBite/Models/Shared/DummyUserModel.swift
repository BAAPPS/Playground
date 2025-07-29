//
//  dummyUserModel.swift
//  TrackBite
//
//  Created by D F on 7/27/25.
//

import Foundation

struct DummyUsersModel: Codable {
    let drivers: [DummyUser]
    let customers: [DummyUser]
    let restaurants: [DummyUser]
}

struct DummyUser: Codable {
    let name: String
    let email: String
    let password: String
}
